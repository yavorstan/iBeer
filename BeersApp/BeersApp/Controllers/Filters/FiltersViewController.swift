//
//  FiltersViewController.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 20.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit
import PKHUD

class FiltersViewController: BAViewController {
    
    //MARK: - Constants
    let screenBounds = UIScreen.main.bounds
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noBeersFoundLabel: BALabel!
    @IBOutlet weak var collapsableFiltersView: UIView!
    @IBOutlet weak var collapseButton: UIButton!
    @IBOutlet weak var collapsableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButton: BAButton!
    @IBOutlet weak var filtersView: BAFiltersView!
    
    //MARK: - Varables
    var filtersURL = ""
    
    var delegate: ResponseManagerDelegate?
    var allBeersList = [BeersListModel]()
    var selectedBeerId = Int()
    var hasNextPage = true
    var currentPage = 1
    
    var isCollapsed = Bool()
    
    //MARK: Lifecycle Methods
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.currentPage = 1
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let clearButton = UIBarButtonItem(title: NSLocalizedString("str_clear", comment: ""), style: .plain, target: self, action: #selector(clearTapped))
        self.navigationItem.rightBarButtonItem = clearButton
        
        collapsableViewBottomConstraint.constant = 0
        collapseButton.setImage(UIImage(named: ImagesNamesConstants.chevronUp), for: .normal)
        
        noBeersFoundLabel.text = NSLocalizedString("str_no_beers_matching_parameters", comment: "")
        noBeersFoundLabel.isHidden = true
        
        filtersView.backgroundColor = UIColor.DefaultFiltersViewColor.color
        collapsableFiltersView.backgroundColor = UIColor.DefaultFiltersViewColor.color
        collapsableFiltersView.layer.cornerRadius = 20
        collapsableFiltersView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        collapseButton.tintColor = UIColor.DefaultTextColor.color
        
        collapsableFiltersView.layer.shadowOffset = CGSize(width: 0, height: 3)
        collapsableFiltersView.layer.shadowColor = UIColor.DefaultTextColor.color?.cgColor
        collapsableFiltersView.layer.shadowOpacity = Float(BAButtonConstants.shadowOpacity)
        collapsableFiltersView.layer.shadowRadius = CGFloat(4)
        
        delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CellConstants.BeersListCell, bundle: nil), forCellReuseIdentifier: CellConstants.BeersListCell)
        RequestManager.shared.fetch(url: "\(URLConstants.getBeersListPage)\(currentPage)\(URLConstants.withPages)", delegate: delegate, responseManager: BeerListResponseManager())
        
    }
    
    //MARK: Buttons Actions
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        if !isCollapsed {
            
            if self.filtersView.hasFilters() {
                self.filtersURL = self.filtersView.getFinalURL()
                self.currentPage = 1
                self.allBeersList.removeAll()
                RequestManager.shared.fetch(url: "\(URLConstants.getBeersListPage)\(self.currentPage)\(URLConstants.withPages)&\(self.filtersURL)", delegate: self.delegate, responseManager: BeerListResponseManager())
                self.manageFilterView()
                
            } else {
                HUD.flash(.label(NSLocalizedString("str_wrong_input", comment: "")))
                return
            }
            
        }
        
    }
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        self.manageFilterView()
    }
    
    //MARK: Util Methods
    private func manageFilterView() {
        
        if isCollapsed {
            self.setFiltersViewState(collapsed: false)
        } else {
            self.setFiltersViewState(collapsed: true)
        }
        
    }
    
    private func setFiltersViewState(collapsed: Bool) {
        
        UIView.animate(withDuration: FiltersViewConstants.animationDuration, delay: FiltersViewConstants.animationDelay, options: [.curveEaseOut], animations: {
            
            if collapsed {
                
                self.collapsableViewBottomConstraint.constant = self.screenBounds.height
                self.collapseButton.setImage(UIImage(named: ImagesNamesConstants.chevronDown), for: .normal)
                self.isCollapsed = true
                self.filtersView.isHidden = true
                self.navigationItem.rightBarButtonItems = []
                self.view.layoutIfNeeded()
                
            } else {
                
                self.collapsableViewBottomConstraint.constant = 0
                self.collapseButton.setImage(UIImage(named: ImagesNamesConstants.chevronUp), for: .normal)
                self.isCollapsed = false
                DispatchQueue.main.asyncAfter(deadline: .now() + FiltersViewConstants.animationDuration) {
                    self.filtersView.isHidden = false
                    let clearButton = UIBarButtonItem(title: "Clear Filters", style: .plain, target: self, action: #selector(self.clearTapped))
                    self.navigationItem.rightBarButtonItems = [clearButton]
                }
                self.view.layoutIfNeeded()
                
            }
            
        }, completion: nil)
        
    }
    
    @objc private func clearTapped() {
        filtersView.clearAllFilters()
    }
    
}

//MARK: - ResponseManagerDelegate
extension FiltersViewController: ResponseManagerDelegate {
    
    func didGetResponse(_ responseManager: ResponseManagerDelegate, _ beerList: [BABeerModel]) {
        
        DispatchQueue.main.async {
            
            if beerList.isEmpty && self.currentPage == 1 {
                self.tableView.isHidden = true
                self.noBeersFoundLabel.isHidden = false
                self.hasNextPage = false
                return
            } else {
                self.tableView.isHidden = false
                self.noBeersFoundLabel.isHidden = true
                self.hasNextPage = true
                let temp = beerList as! [BeersListModel]
                self.allBeersList.append(contentsOf: temp)
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    func didFailWithError(error: Error) {
        super.failedWithError(error: error)
    }
    
}

//MARK: - TableViewDataSource
extension FiltersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allBeersList.count
    }
    
    //Reloads table data when bottom is reached
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let bottomEdge = self.tableView.contentOffset.y + self.tableView.frame.size.height
        if bottomEdge >= self.tableView.contentSize.height {
            if hasNextPage {
                currentPage += 1
                if self.filtersView.hasFilters() {
                    RequestManager.shared.fetch(url: "\(URLConstants.getBeersListPage)\(currentPage)\(URLConstants.withPages)&\(self.filtersURL)", delegate: self.delegate, responseManager: BeerListResponseManager())
                } else {
                    RequestManager.shared.fetch(url: "\(URLConstants.getBeersListPage)\(currentPage)\(URLConstants.withPages)", delegate: delegate, responseManager: BeerListResponseManager())
                }
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
extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        selectedBeerId = allBeersList[indexPath.row].id
        performSegue(withIdentifier: SegueConstants.goToBeerDetails, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueConstants.goToBeerDetails  {
            let vc = segue.destination as! BeerDetailsViewController
            vc.url = "\(URLConstants.getBeerById)\(selectedBeerId)"
            vc.selectedBeerId = selectedBeerId
        }
        
    }
    
}
