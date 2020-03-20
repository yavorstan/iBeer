//
//  FavouritesScreenViewController.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 5.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit
import SCLAlertView
import UPCarouselFlowLayout

class FavouritesScreenViewController: BAViewController {
    
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyTableLabel: BALabel!
    
    var favouriteBeers = [BeersListModel]()
    
    var selectedBeerId = Int()
    
    //MARK: Lifecycle Methods
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItems = []
        if UserDefaults.standard.getFavouriteBeersArray() == nil || UserDefaults.standard.getFavouriteBeersArray()!.isEmpty {
            tableView.isHidden = true
            carouselCollectionView.isHidden = true
            emptyTableLabel.isHidden = false
            emptyTableLabel.text = "You have no favourite beers!"
        } else if UserDefaults.standard.isCarouselStyle() {
            favouriteBeers = UserDefaults.standard.getFavouriteBeersArray()!
            emptyTableLabel.isHidden = true
            tableView.isHidden = true
            carouselCollectionView.isHidden = false
            carouselCollectionView.reloadData()
        } else {
            favouriteBeers = UserDefaults.standard.getFavouriteBeersArray()!
            emptyTableLabel.isHidden = true
            tableView.isHidden = false
            carouselCollectionView.isHidden = true
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: CarouselConstants.width, height: CarouselConstants.height)
        layout.scrollDirection = .horizontal
        carouselCollectionView.collectionViewLayout = layout
        
        carouselCollectionView.delegate = self
        carouselCollectionView.dataSource = self
        carouselCollectionView.register(UINib(nibName: CarouselConstants.CarouselCell, bundle: nil), forCellWithReuseIdentifier: CarouselConstants.CarouselCell)
        
        self.tabBarController?.navigationItem.hidesBackButton = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CellConstants.BeersListCell, bundle: nil), forCellReuseIdentifier: CellConstants.BeersListCell)
    }
    
    //MARK: Util Methods
    private func confimBeerRemovalFromFavourites(beer: BeersListModel) {
        let popupManager = PopupManager()
        popupManager.showConfirmPopup(title: "WARNING", message: "Are you sure you want to remove '\(beer.name)' from favourites?")
        popupManager.yesTapped = { () in
            UserDefaults.standard.manageBeer(beer: beer)
            self.favouriteBeers = UserDefaults.standard.getFavouriteBeersArray()!
            self.checkIfFavouritesListIsEmpty()
            if self.tableView.isHidden {
                self.carouselCollectionView.reloadData()
            } else {
                self.tableView.reloadData()
            }
        }
    }
    private func checkIfFavouritesListIsEmpty() {
        if favouriteBeers.isEmpty {
            tableView.isHidden = true
            carouselCollectionView.isHidden = true
            emptyTableLabel.isHidden = false
            emptyTableLabel.text = "You have no favourite beers!"
        }
    }
    private func goToBeerDetails(for indexPath: IndexPath) {
        print(indexPath.row)
        selectedBeerId = (favouriteBeers[indexPath.row].id)
        performSegue(withIdentifier: SegueConstants.goToBeerDetails, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueConstants.goToBeerDetails  {
            let vc = segue.destination as! BeerDetailsViewController
            vc.selectedBeerId = selectedBeerId
        }
    }
    
}

//MARK: - TableViewDataSource
extension FavouritesScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteBeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellConstants.BeersListCell, for: indexPath) as! BeersListCell
        weak var weakSelf = self
        cell.populate(beer: (favouriteBeers[indexPath.row]))
        let beer = self.favouriteBeers[indexPath.row]
        cell.imageTapped = { (self) in
            weakSelf?.confimBeerRemovalFromFavourites(beer: beer)
            return beer.id
        }
        return cell
    }
}

//MARK: - TableViewDelegate
extension FavouritesScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToBeerDetails(for: indexPath)
    }
}

//MARK: - CarouselDataSource
extension FavouritesScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouriteBeers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = carouselCollectionView.dequeueReusableCell(withReuseIdentifier: CarouselConstants.CarouselCell, for: indexPath) as! CarouselCell
        weak var weakSelf = self
        cell.populate(beer: (favouriteBeers[indexPath.row]))
        let beer = self.favouriteBeers[indexPath.row]
        cell.imageTapped = { (self) in
            weakSelf?.confimBeerRemovalFromFavourites(beer: beer)
            return beer.id
        }
        return cell
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x - 1, y: 0), animated: true)
    //        return
    //    }
    
}

//MARK: - CarouselDelegate
extension FavouritesScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToBeerDetails(for: indexPath)
    }
}
