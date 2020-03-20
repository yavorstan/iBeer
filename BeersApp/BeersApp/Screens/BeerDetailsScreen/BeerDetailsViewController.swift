//
//  BeerDetailsViewController.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 6.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BeerDetailsViewController: BAViewController {
  
    var delegate: ResponseManagerDelegate?
    
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    @IBOutlet weak var heartShappedButton: UIButton!
    
    @IBOutlet weak var image: BADownloadImageViewWithBorder!
    @IBOutlet weak var beerName: BALabel!
    @IBOutlet weak var beerDescription: UILabel!
    
    @IBOutlet weak var beerABV: UILabel!
    @IBOutlet weak var beerIBU: UILabel!
    @IBOutlet weak var beerEBC: UILabel!
    
    var selectedBeerId = Int()
    var beer: BeerDetailsModel?
    
//                  "\(URLConstants.getBeerById)\(selectedBeerId):      <- API
    let viktorDB = "https://dev11.imperiax.info/beers/public/beers/1"
    let gabiDB = "https://belot-dev5.imperialhero.org/beers/1"
    
    //MARK: Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RequestManager.shared.fetch(url: "\(URLConstants.getBeerById)\(selectedBeerId)", delegate: delegate, responseManager: BeerDetailsResponseManager())
        checkIfFavourite()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        self.tabBarController?.navigationItem.hidesBackButton = false
        beerDescription.font = UIFont.defaultDescriptionFont.font
        beerABV.font = UIFont.defaultDescriptionFont.font
        beerIBU.font = UIFont.defaultDescriptionFont.font
        beerEBC.font = UIFont.defaultDescriptionFont.font
    }
    
    //MARK: Buttons Actions
    @IBAction func buttonABVPressed(_ sender: UIButton) {
        let textMessage = BeerInfoTextConstants.ABV
        super.showPopOver(sender: sender, text: textMessage, height: BeerInfoTextConstants.ABVWindowHeight)
    }
    @IBAction func buttonIBUPressed(_ sender: UIButton) {
        let textMessage = BeerInfoTextConstants.IBU
        super.showPopOver(sender: sender, text: textMessage, height: BeerInfoTextConstants.IBUWindowsHeight)
    }
    @IBAction func buttonEBCPressed(_ sender: UIButton) {
        let textMessage = BeerInfoTextConstants.EBC
        super.showPopOver(sender: sender, text: textMessage, height: BeerInfoTextConstants.EBCWindownHeight)
    }
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        let favouriteBeer = BeersListModel(id: beer!.id, name: beer!.name, tagLine: beer!.tagLine, image_url: beer!.image_url)
        UserDefaults.standard.manageBeer(beer: favouriteBeer)
        if UserDefaults.standard.checkIfFavourite(beerID: selectedBeerId) {
            heartShappedButton.tintColor = .red
        } else {
            heartShappedButton.tintColor = UIColor.DefaultTextColor.color
        }
        self.view.layoutIfNeeded()
    }
    
    //MARK: Util Methods
    private func checkIfFavourite() {
        if UserDefaults.standard.checkIfFavourite(beerID: selectedBeerId) {
            heartShappedButton.tintColor = .red
        } else {
            heartShappedButton.tintColor = UIColor.DefaultTextColor.color
        }
    }
    
}

//MARK: - ResponseManagerDelegate
extension BeerDetailsViewController: ResponseManagerDelegate {
    func didGetResponse(_ responseManager: ResponseManagerDelegate, _ beerList: [BABeerModel]) {
        DispatchQueue.main.async {
            
            self.beer = beerList[0] as? BeerDetailsModel
            self.beerName.text = self.beer?.name
            self.beerDescription.text = "Description:\n\(self.beer!.description)"
            let stringURL = self.beer!.image_url
            let url = (URL(string: stringURL))
            self.image.populateImage(withURL: url!)
            self.image.activityIndicator.isHidden = true
    
            self.beerABV.text = self.beer!.abv == -1 ? "ABV: n/a" : "ABV: \(self.beer!.abv)%"
            self.beerIBU.text = self.beer!.ibu == -1 ? "IBU: n/a" : "IBU: \(self.beer!.ibu)"
            self.beerEBC.text = self.beer!.ebc == -1 ? "EBC: n/a" : "EBC: \(self.beer!.ebc)"
        }
    }
    
    func didFailWithError(error: Error) {
        super.failedWithError(error: error)
    }
}
