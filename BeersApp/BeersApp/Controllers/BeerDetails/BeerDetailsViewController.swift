//
//  BeerDetailsViewController.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 6.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit
import PKHUD
import FBSDKShareKit

class BeerDetailsViewController: BAViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var infoButtons: [UIButton]!
        
    @IBOutlet weak var backgroundView: BABackground!
    @IBOutlet weak var image: BADownloadImageViewWithBorder!
    @IBOutlet weak var beerName: BALabel!
    
    @IBOutlet weak var beerABV: UILabel!
    @IBOutlet weak var beerIBU: UILabel!
    @IBOutlet weak var beerEBC: UILabel!
    
    @IBOutlet weak var firstBrewed: UILabel!
    @IBOutlet weak var beerDescription: UILabel!
    @IBOutlet weak var beerDescriptionImage: UIImageView!
    @IBOutlet weak var recommendedFood: UILabel!
    @IBOutlet weak var brewingTips: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var contributedBy: UILabel!
    
    //MARK: - Variables
    var delegate: ResponseManagerDelegate?

    var selectedBeerId = Int()
    var beer: BeerDetailsModel?
    var url = String()
    
    var addToFavouritesButton: UIBarButtonItem?
    var fbShareButton: UIBarButtonItem?
    
    //MARK: Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for button in infoButtons {
            button.imageView?.image = UIImage.image(withName: "info.circle", width: 10, height: 10, withColor: .blue)
        }
        
        addToFavouritesButton = UIBarButtonItem(title: "favourite", style: .plain, target: self, action: #selector(addToFavouritesButtonPressed))
        self.checkIfFavourite()
        
        fbShareButton = UIBarButtonItem(title: "fb", style: .plain, target: self, action: #selector(shareToFB))
        fbShareButton?.image = UIImage(named: "facebook")?.resizeImage(targetSize: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysOriginal)

        self.navigationItem.rightBarButtonItems = [addToFavouritesButton!, fbShareButton!]
        
        RequestManager.shared.fetch(url: self.url, delegate: delegate, responseManager: BeerDetailsResponseManager())
        checkIfFavourite()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        self.placeBackgroundAtForemostPostition(background: backgroundView)
        
        self.tabBarController?.navigationItem.hidesBackButton = false
        
        image.backgroundColor = UIColor.CellBackgroundColor.color
        
        beerDescription.font = UIFont.defaultDescriptionFont.font
        
        beerABV.font = UIFont.defaultDescriptionFont.font
        beerIBU.font = UIFont.defaultDescriptionFont.font
        beerEBC.font = UIFont.defaultDescriptionFont.font
        firstBrewed.font = UIFont.defaultDescriptionFont.font
        ingredientsLabel.font = UIFont.defaultDescriptionFont.font
        recommendedFood.font = UIFont.defaultDescriptionFont.font
        brewingTips.font = UIFont.defaultDescriptionFont.font
        contributedBy.font = UIFont.defaultDescriptionFont.font
        
    }
    
    //MARK: Buttons Actions
    @IBAction func buttonABVPressed(_ sender: UIButton) {
        let textMessage = NSLocalizedString("abv", comment: "")
        super.showPopOver(sender: sender, text: textMessage, height: BeerInfoTextConstants.ABVWindowHeight)
    }
    
    @IBAction func buttonIBUPressed(_ sender: UIButton) {
        let textMessage = NSLocalizedString("ibu", comment: "")
        super.showPopOver(sender: sender, text: textMessage, height: BeerInfoTextConstants.IBUWindowsHeight)
    }
    
    @IBAction func buttonEBCPressed(_ sender: UIButton) {
        let textMessage = NSLocalizedString("ebc", comment: "")
        super.showPopOver(sender: sender, text: textMessage, height: BeerInfoTextConstants.EBCWindownHeight)
    }
    
    @objc func addToFavouritesButtonPressed() {
        
        let favouriteBeer = BeersListModel(id: beer!.id, name: beer!.name, tagLine: beer!.tagLine, image_url: (beer?.image_url)!)
        FavouriteBeersManager.shared.manageBeer(beer: favouriteBeer)
        self.checkIfFavourite()
        self.view.layoutIfNeeded()
        
    }
    
    /* Works only on real device */
    @objc private func shareToFB() {
        
        let content = SharePhotoContent()
        content.photos = [SharePhoto(image: self.image.imageView.image!, userGenerated: true)]
        let dialog = ShareDialog.init(fromViewController: self, content: content, delegate: self)
        dialog.show()
        
    }
    
    //MARK: Util Methods
    private func checkIfFavourite() {

        if FavouriteBeersManager.shared.checkIfFavourite(beerID: selectedBeerId) {
            addToFavouritesButton!.image = UIImage.image(withName: "heart.fill", width: 25, height: 25, withColor: .red)
            addToFavouritesButton?.tintColor = . red
        } else {
            addToFavouritesButton!.image = UIImage.image(withName: "heart", width: 25, height: 25, withColor: .white)
            addToFavouritesButton?.tintColor = UIColor.DefaultTextColor.color
        }
        
    }
    
    private func subTitles(bold: String, normal: String) -> NSMutableAttributedString {
        return NSMutableAttributedString().bold(bold) + NSMutableAttributedString().normal(normal)
    }
    
    private func replaceOccurences(ingredients: [Ingredient], replace replacee: String, with replacement: String) -> NSMutableAttributedString {
        
        var attrString = NSMutableAttributedString()
        for ingredient in ingredients {
            
            let response = "\(ingredient.amount)"
            let replacedAmount = response.replacingOccurrences(of: "Amount(value:", with: "")
            let replacedUnits = replacedAmount.replacingOccurrences(of: replacee, with: " \(replacement)")
            attrString = attrString + NSMutableAttributedString().normal("\t\n • \(ingredient.name): \(replacedUnits)")
            
        }
        
        return attrString
        
    }
    
}

//MARK: - ResponseManagerDelegate
extension BeerDetailsViewController: ResponseManagerDelegate {
    
    func didGetResponse(_ responseManager: ResponseManagerDelegate, _ beerList: [BABeerModel]) {
        
        DispatchQueue.main.async {
            
            self.beer = beerList[0] as? BeerDetailsModel
            self.beerName.text = self.beer!.name
            let stringURL = self.beer?.image_url
            let url = (URL(string: stringURL!))
            self.image.populateImage(withURL: url)
            self.image.activityIndicator.isHidden = true
            
            self.beerABV.text = self.beer!.abv == -1 ? "ABV: n/a" : "ABV: \(self.beer!.abv)%"
            self.beerIBU.text = self.beer!.ibu == -1 ? "IBU: n/a" : "IBU: \(self.beer!.ibu)"
            self.beerEBC.text = self.beer!.ebc == -1 ? "EBC: n/a" : "EBC: \(self.beer!.ebc)"
            
            self.firstBrewed.attributedText = self.subTitles(bold: NSLocalizedString("date", comment: ""), normal: "\(self.beer?.firstBrewed ?? "n/a")")
            
            self.beerDescription.attributedText = self.subTitles(bold: NSLocalizedString("description", comment: ""), normal: "\n\(self.beer!.description)")
            
            var allFoodPairings = String()
            for food in self.beer!.foodPairing {
                allFoodPairings += " \n • \(food)"
            }
            self.recommendedFood.attributedText = self.subTitles(bold: NSLocalizedString("goes_well", comment: ""), normal: allFoodPairings)
            
            self.brewingTips.attributedText = self.subTitles(bold: NSLocalizedString("brewing_tips", comment: ""), normal: "\n\(self.beer!.brewingTips)")
            
            self.ingredientsLabel.attributedText =
                NSMutableAttributedString().bold(NSLocalizedString("malt", comment: ""))
                + self.replaceOccurences(ingredients: self.beer!.malt, replace: ", unit: \"kilograms\")", with: "kg")
                + NSMutableAttributedString().bold("\n\n\(NSLocalizedString("hops", comment: ""))")
                + self.replaceOccurences(ingredients: self.beer!.hops, replace: ", unit: \"grams\")", with: "gr")
                + NSMutableAttributedString().bold("\n\n\(NSLocalizedString("yeast", comment: "")) ")
                + NSMutableAttributedString().normal("\n • \(self.beer!.yeast)")
            
            self.contributedBy.attributedText = self.subTitles(bold: NSLocalizedString("contributor", comment: ""), normal: "\n \(self.beer!.contributedBy)")
            
            self.placeBackgroundAtLastPosition(background: self.backgroundView)
            
        }
        
    }
    
    func didFailWithError(error: Error) {
        super.failedWithError(error: error)
    }
    
}

//MARK: - Share to Facebook
extension BeerDetailsViewController: SharingDelegate {
    
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        HUD.flash(.label(NSLocalizedString("str_share_successful", comment: "")), delay: 0.8)
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        HUD.flash(.label(NSLocalizedString("str_share_error", comment: "")), delay: 0.8)
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        HUD.flash(.label(NSLocalizedString("str_share_canceled", comment: "")), delay: 0.8)
    }
    
}
