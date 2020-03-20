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
    
    @IBOutlet weak var noBeersFoundLabel: BALabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchBarCancelLabel: UILabel!
    
    var delegate: ResponseManagerDelegate?
    var allBeersList = [BeersListModel]()
    var selectedBeerId = Int()
    var currentPage = 1
    
    var hasNextPage = true
    
    var isSearching = Bool()
    
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
        let filter = UIBarButtonItem(title: "Filters", style: .plain, target: self, action: #selector(filterTapped))
        self.tabBarController?.navigationItem.rightBarButtonItems = [filter]
        tableView.reloadData()
        searchBar.barTintColor = UIColor.DefaultAppColor.color
        searchBar.searchTextField.tintColor = UIColor.DefaultTextColor.color
        searchBarCancelLabel.textColor = UIColor.DefaultTextColor.color
        noBeersFoundLabel.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.placeholder = "Search beer by name..."
        self.tabBarController?.navigationItem.hidesBackButton = true
        delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CellConstants.BeersListCell, bundle: nil), forCellReuseIdentifier: CellConstants.BeersListCell)
        RequestManager.shared.fetch(url: "\(URLConstants.getBeersListPage)\(currentPage)\(URLConstants.beersPerPage)", delegate: delegate, responseManager: BeerListResponseManager())
    }
    
    @objc func filterTapped () {
        performSegue(withIdentifier: SegueConstants.goToFilterScreen, sender: self)
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !self.isSearching{
            if indexPath.section == tableView.numberOfSections - 1 &&
                indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                if hasNextPage {
                    currentPage += 1
                    RequestManager.shared.fetch(url: "\(URLConstants.getBeersListPage)\(currentPage)\(URLConstants.beersPerPage)", delegate: delegate, responseManager: BeerListResponseManager())
                }
            }
        } else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellConstants.BeersListCell, for: indexPath) as! BeersListCell
        cell.populate(beer: allBeersList[indexPath.row])
        let beer = self.allBeersList[indexPath.row]
        cell.imageTapped = { (self) in
            UserDefaults.standard.manageBeer(beer: beer)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueConstants.goToBeerDetails  {
            let vc = segue.destination as! BeerDetailsViewController
            vc.selectedBeerId = selectedBeerId
        }
    }
}

//MARK: - Search Bar

extension HomeScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty || searchText == "" {
            self.isSearching = false
            self.currentPage = 1
            self.allBeersList.removeAll()
            RequestManager.shared.fetch(url: "\(URLConstants.getBeersListPage)\(currentPage)\(URLConstants.beersPerPage)", delegate: delegate, responseManager: BeerListResponseManager())
        } else {
            self.isSearching = true
            RequestManager.shared.fetch(url: "https://api.punkapi.com/v2/beers?beer_name=\(searchText)", delegate: delegate, responseManager: BeerListResponseManager())
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearching = false
        self.currentPage = 1
        self.allBeersList.removeAll()
        self.searchBar.text = ""
        RequestManager.shared.fetch(url: "\(URLConstants.getBeersListPage)\(currentPage)\(URLConstants.beersPerPage)", delegate: delegate, responseManager: BeerListResponseManager())
        tableView.reloadData()
        searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
        searchBar.endEditing(true)
    }
}
