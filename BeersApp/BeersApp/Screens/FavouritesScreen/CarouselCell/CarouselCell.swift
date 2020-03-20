//
//  CarouselCell.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 19.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class CarouselCell: UICollectionViewCell {

    var imageTapped: ((CarouselCell) -> (Int))?
    
    @IBOutlet weak var favouriteIndicator: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var outerView: UIView!
    
    @IBOutlet weak var beerImage: BADownloadImageView!
    @IBOutlet weak var beerName: BALabel!
    @IBOutlet weak var beerTagline: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        beerName.font = UIFont.defaultTitleFont.font
        beerTagline.font = UIFont.defaultDescriptionFont.font
        
        outerView.layer.borderWidth = CGFloat(CarouselConstants.borderWidth)
        outerView.layer.borderColor = UIColor.DefaultAppColor.color?.cgColor
        outerView.layer.cornerRadius = CGFloat(CarouselConstants.cornerRadius)
        outerView.backgroundColor = UIColor.CellBackgroundColor.color
    }
    
    func populate(beer: BeersListModel) {
        self.beerName.text = beer.name
        self.beerTagline.text = beer.tagLine
        let stringURL = beer.image_url
        let url = (URL(string: stringURL))!
        self.beerImage.populateImage(withURL: url)
        manageFavouriteIndicator(beerID: beer.id)
    }
    
    func manageFavouriteIndicator(beerID: Int) {
        if #available(iOS 13.0, *) {
            if UserDefaults.standard.checkIfFavourite(beerID: beerID) {
                self.favouriteIndicator.image = UIImage(systemName: "heart.fill")
                self.favouriteIndicator.tintColor = .red
            } else {
                self.favouriteIndicator.image = UIImage(systemName: "heart")
                self.favouriteIndicator.tintColor = UIColor.DefaultTextColor.color
            }
        }
    }
    
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        let beerID = imageTapped?(self)
        manageFavouriteIndicator(beerID: beerID!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        outerView.layer.borderColor = UIColor.DefaultAppColor.color?.cgColor
    }

}
