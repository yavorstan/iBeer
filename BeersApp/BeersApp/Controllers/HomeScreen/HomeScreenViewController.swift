//
//  HomeScreenViewController.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 5.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD

class HomeScreenViewController: BAViewController{
    
    //MARK: - IBOutlets
    @IBOutlet weak var homeButton: UITabBarItem!
    
    @IBOutlet weak var noBeersFoundLabel: BALabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Variables
    var delegate: ResponseManagerDelegate?
    var allBeersList = [BeersListModel]()
    var selectedBeerId = Int()
    var currentPage = 1
    
    var hasNextPage = true
    
    var isSearching = Bool()
    
    var isRandomButtonPressed = false
    
    var currentNumberOfBeersPerPage = Int()
    
    //MARK: Lifecycle Methods
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
        self.searchBar.endEditing(true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let filtersButton = UIBarButtonItem(title: "Filters", style: .plain, target: self, action: #selector(filterTapped))
        filtersButton.image = UIImage.image(withName: "line.horizontal.3.decrease.circle", width: 25, height: 25, withColor: nil)
        let randomButton = UIBarButtonItem(title: "Random", style: .plain, target: self, action: #selector(randomTapped))
        randomButton.image = UIImage.image(withName: "wand.and.stars.inverse", width: 25, height: 25, withColor: nil)
        
        self.tabBarController?.navigationItem.rightBarButtonItems = [filtersButton, randomButton]
        
        let customAccessoryView = Bundle.main.loadNibNamed("CustomAccessoryView", owner: self, options: nil)?.first as! CustomAccessoryView
        
        customAccessoryView.clearHandler = { () -> Void in
            self.clearButtonPressed()
        }
        customAccessoryView.doneHandler = { () -> Void in
            self.searchBar.endEditing(true)
        }
        searchBar.inputAccessoryView = customAccessoryView
        
        searchBar.barTintColor = UIColor.DefaultAppColor.color
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.tintColor = UIColor.DefaultTextColor.color
        } else {
            searchBar.tintColor = UIColor.DefaultTextColor.color
        }
        
        noBeersFoundLabel.isHidden = true
        
        if currentNumberOfBeersPerPage != UserDefaults.standard.getBeersPerPage()! {
            
            currentNumberOfBeersPerPage = UserDefaults.standard.getBeersPerPage()!
            self.currentPage = 1
            self.allBeersList.removeAll()
            RequestManager.shared.fetch(url: "\(URLConstants.getBeersListPage)\(currentPage)\(URLConstants.withPages)", delegate: delegate, responseManager: BeerListResponseManager())
            
        }
        if allBeersList.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
        tableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("str_search_placeholder", comment: "")
        self.tabBarController?.navigationItem.hidesBackButton = true
        delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CellConstants.BeersListCell, bundle: nil), forCellReuseIdentifier: CellConstants.BeersListCell)
        
        currentNumberOfBeersPerPage = UserDefaults.standard.getBeersPerPage()!
        RequestManager.shared.fetch(url: "\(URLConstants.getBeersListPage)\(currentPage)\(URLConstants.withPages)", delegate: delegate, responseManager: BeerListResponseManager())
        
    }
    
    //MARK: - Buttons actions
    @objc func filterTapped () {
        performSegue(withIdentifier: SegueConstants.goToFilterScreen, sender: self)
    }
    
    @objc func randomTapped() {
        
        self.isRandomButtonPressed = true
        performSegue(withIdentifier: SegueConstants.goToBeerDetails, sender: self)
        self.isRandomButtonPressed = false
        
    }
    
    //MARK: Util Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueConstants.goToBeerDetails  {
            
            let vc = segue.destination as! BeerDetailsViewController
            var endpoint = String()
            if isRandomButtonPressed {
                
                if UserDefaults.standard.randomBeerIsFromFavourites() {
                    
                    let favouritesArray = FavouriteBeersManager.shared.getFavouriteBeersArray()
                    self.selectedBeerId = (favouritesArray?.randomElement()!.id)!
                    vc.selectedBeerId = selectedBeerId
                    endpoint = "\(selectedBeerId)"
                    
                } else {
                    endpoint = "random"
                }
                vc.url = "\(URLConstants.getBeerById)\(endpoint)"
                
            } else {
                vc.selectedBeerId = selectedBeerId
                vc.url = "\(URLConstants.getBeerById)\(selectedBeerId)"
            }
            
        }
        
    }
    
    func fromWidget() {
        
        let appdelgateObj = UIApplication.shared.delegate as! AppDelegate
        if let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "details") as? BeerDetailsViewController {
            
            if let window = appdelgateObj.window , let rootViewController = window.rootViewController {
                
                destinationVC.selectedBeerId = 5
                var currentController = rootViewController
                while let presentedController = currentController.presentedViewController {
                    currentController = presentedController
                }
                currentController.present(destinationVC, animated: true, completion: nil)
                
            }
            
        }
        
    }
}


//MARK: - ResponseManagerDelegate
extension HomeScreenViewController: ResponseManagerDelegate {
    
    func didGetResponse(_ responseManager: ResponseManagerDelegate, _ beerList: [BABeerModel]) {
        
        DispatchQueue.main.async {
            if !self.isSearching {
                if beerList.isEmpty {
                    self.hasNextPage = false
                    return
                }
                let temp = beerList as! [BeersListModel]
                self.allBeersList.append(contentsOf: temp)
                self.tableView.reloadData()
            } else if beerList.isEmpty {
                self.tableView.isHidden = true
                self.noBeersFoundLabel.isHidden = false
            } else {
                self.tableView.isHidden = false
                self.noBeersFoundLabel.isHidden = true
                self.allBeersList = beerList as! [BeersListModel]
                self.tableView.reloadData()
            }
        }
        
    }
    
    func didFailWithError(error: Error) {
        super.failedWithError(error: error)
    }
    
}

//MARK: - TableViewDataSource
extension HomeScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allBeersList.count
    }
    
    //Reloads table data when bottom is reached
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let bottomEdge = self.tableView.contentOffset.y + self.tableView.frame.size.height
        if bottomEdge >= self.tableView.contentSize.height {
            if !self.isSearching{
                if hasNextPage {
                    currentPage += 1
                    RequestManager.shared.fetch(url: "\(URLConstants.getBeersListPage)\(currentPage)\(URLConstants.withPages)", delegate: delegate, responseManager: BeerListResponseManager())
                }
            } else {
                return
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellConstants.BeersListCell, for: indexPath) as! BeersListCell
        cell.populate(beer: allBeersList[indexPath.row])
        let beer = self.allBeersList[indexPath.row]
        cell.imageTapped = { (self) in
            FavouriteBeersManager.shared.manageBeer(beer: beer)
            return beer.id
        }
        return cell
        
    }
}

//MARK: - TableViewDelegate
extension HomeScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        selectedBeerId = allBeersList[indexPath.row].id
        performSegue(withIdentifier: SegueConstants.goToBeerDetails, sender: self)
    }
    
}

//MARK: - Searchbar
extension HomeScreenViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty || searchText == "" {
            self.isSearching = false
            self.currentPage = 1
            self.allBeersList.removeAll()
            RequestManager.shared.fetch(url: "\(URLConstants.getBeersListPage)\(currentPage)\(URLConstants.withPages)", delegate: delegate, responseManager: BeerListResponseManager())
        } else {
            self.isSearching = true
            RequestManager.shared.fetch(url: "\(URLConstants.beerByName)\(searchText)", delegate: delegate, responseManager: BeerListResponseManager())
        }
        if searchBar.text == "" {
            self.isSearching = false
            self.currentPage = 1
            self.allBeersList.removeAll()
            RequestManager.shared.fetch(url: "\(URLConstants.getBeersListPage)\(currentPage)\(URLConstants.withPages)", delegate: delegate, responseManager: BeerListResponseManager())
        }
    }
    
    func clearButtonPressed() {
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.text = ""
            searchBar.searchTextField.endEditing(true)
        } else {
            searchBar.text = ""
            searchBar.endEditing(true)
        }
        self.isSearching = false
        self.currentPage = 1
        self.allBeersList.removeAll()
        RequestManager.shared.fetch(url: "\(URLConstants.getBeersListPage)\(currentPage)\(URLConstants.withPages)", delegate: delegate, responseManager: BeerListResponseManager())
        tableView.isHidden = false
        noBeersFoundLabel.isHidden = true
        tableView.reloadData()
    }
    
}
