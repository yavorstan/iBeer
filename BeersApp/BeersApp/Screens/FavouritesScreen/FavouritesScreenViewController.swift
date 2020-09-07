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
import GoogleMobileAds

class FavouritesScreenViewController: BAViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var favouritesButton: UITabBarItem!
    
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyTableLabel: BALabel!
    
    //MARK: - Variables
    var favouriteBeers = [BeersListModel]()
    var selectedBeerId = Int()
    var bannerView: GADBannerView!
    
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
        if FavouriteBeersManager.shared.getFavouriteBeersArray() == nil || FavouriteBeersManager.shared.getFavouriteBeersArray()!.isEmpty {
            tableView.isHidden = true
            carouselCollectionView.isHidden = true
            emptyTableLabel.isHidden = false
            emptyTableLabel.text = NSLocalizedString("str_no_fav_beers", comment: "")
        } else if UserDefaults.standard.isCarouselStyle() {
            self.carouselCollectionView.setContentOffset(.init(x: 0, y: 0), animated: true)
            favouriteBeers = FavouriteBeersManager.shared.getFavouriteBeersArray()!
            emptyTableLabel.isHidden = true
            tableView.isHidden = true
            carouselCollectionView.isHidden = false
            carouselCollectionView.reloadData()
        } else {
            favouriteBeers = FavouriteBeersManager.shared.getFavouriteBeersArray()!
            emptyTableLabel.isHidden = true
            tableView.isHidden = false
            carouselCollectionView.isHidden = true
            tableView.reloadData()
        }
        
        if !AdvertsManager.shared.userAllowedAdverts {
            bannerView?.removeFromSuperview()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: CarouselConstants.width, height: CarouselConstants.height)
        layout.scrollDirection = .horizontal
        layout.spacingMode = .fixed(spacing: 25)
        carouselCollectionView.collectionViewLayout = layout
        
        carouselCollectionView.delegate = self
        carouselCollectionView.dataSource = self
        carouselCollectionView.register(UINib(nibName: CarouselConstants.CarouselCell, bundle: nil), forCellWithReuseIdentifier: CarouselConstants.CarouselCell)
        
        self.tabBarController?.navigationItem.hidesBackButton = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CellConstants.BeersListCell, bundle: nil), forCellReuseIdentifier: CellConstants.BeersListCell)
        
    }
    /* Advert is loaded in viewDidAppear since this is the first time the safe are is known. */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if AdvertsManager.shared.userAllowedAdverts {
            self.setupAdverts()
            AdvertsManager.shared.loadBannerAd(bannerView, view: view)
        }
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        
        if AdvertsManager.shared.userAllowedAdverts {
            coordinator.animate(alongsideTransition: { _ in
                //                AdvertsManager.shared.loadBannerAd(self.bannerView, view: self.view)
            })
        }
        
    }
    
    //MARK: Util Methods
    private func confimBeerRemovalFromFavourites(beer: BeersListModel) {
        
        let title = NSLocalizedString("str_warning", comment: "")
        let message = String(format: NSLocalizedString("str_remove_beer_warning", comment: ""), beer.name)
        let confirmationHandler = { () in
            
            FavouriteBeersManager.shared.manageBeer(beer: beer)
            self.favouriteBeers = FavouriteBeersManager.shared.getFavouriteBeersArray()!
            self.checkIfFavouritesListIsEmpty()
            
            if self.tableView.isHidden {
                
                self.carouselCollectionView.setContentOffset(.init(x: self.carouselCollectionView.contentOffset.x - 1, y: 0), animated: true)
                self.carouselCollectionView.reloadData()
                
            } else {
                self.tableView.reloadData()
            }
            
        }
        
        PopupManager.shared.showConfirmPopup(title: title,
                                             message: message,
                                             confirmationHandler: confirmationHandler)
        
    }
    private func checkIfFavouritesListIsEmpty() {
        if favouriteBeers.isEmpty {
            tableView.isHidden = true
            carouselCollectionView.isHidden = true
            emptyTableLabel.isHidden = false
            emptyTableLabel.text = NSLocalizedString("str_no_fav_beers", comment: "")
        }
    }
    private func goToBeerDetails(for indexPath: IndexPath) {
        print(indexPath.row)
        self.selectedBeerId = (favouriteBeers[indexPath.row].id)
        performSegue(withIdentifier: SegueConstants.goToBeerDetails, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueConstants.goToBeerDetails  {
            let vc = segue.destination as! BeerDetailsViewController
            vc.selectedBeerId = selectedBeerId
            vc.url = "\(URLConstants.getBeerById)\(selectedBeerId)"
        }
    }
    
    //MARK: Adverts Methods
    private func setupAdverts() {
        bannerView = GADBannerView(adSize: kGADAdSizeFluid)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = AdvertsConstants.bannerAdUnitID
        bannerView.rootViewController = self
        
        AdvertsManager.shared.loadBannerAd(bannerView, view: view)
    }
    private func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
        ])
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
    
}

//MARK: - CarouselDelegate
extension FavouritesScreenViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToBeerDetails(for: indexPath)
    }
    
}

extension FavouritesScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CarouselCellSize.iPadSize
        } else {
            return CarouselCellSize.iPhoneSize
        }
        
    }
    
}
