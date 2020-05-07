//
//  BeersListCell.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 6.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BeersListCell: UITableViewCell {
    
    var imageTapped: ((BeersListCell) -> (Int))?

    @IBOutlet weak var favouriteIndicator: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var beerName: BALabel!
    @IBOutlet weak var beerImage: BADownloadImageViewWithBorder!
    @IBOutlet weak var indicatorImage: UIImageView!
    @IBOutlet weak var lineDivider: BALineDivider!
    
    @IBOutlet weak var beerTagLine: UILabel!
    
    @IBOutlet weak var cellBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackground.backgroundColor = UIColor.CellBackgroundColor.color
        beerTagLine.textColor = UIColor.DefaultTextColor.color
        beerTagLine.font = UIFont.defaultDescriptionFont.font
        indicatorImage.tintColor = UIColor.DefaultTextColor.color
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.DefaultFiltersViewColor.color
        self.selectedBackgroundView = backgroundView
    }
    
    func populate(beer: BeersListModel) {
        self.beerName.text = beer.name
        self.beerTagLine.text = beer.tagLine
        let stringURL = beer.image_url
        let url = URL(string: stringURL)
        self.beerImage.populateImage(withURL: url)
        self.beerImage.activityIndicator.isHidden = true
        manageFavouriteIndicator(beerID: beer.id)
    }
    
    func manageFavouriteIndicator(beerID: Int) {
            if FavouriteBeersManager.shared.checkIfFavourite(beerID: beerID) {
                self.favouriteIndicator.tintColor = .red
                self.favouriteIndicator.image = UIImage.image(withName: "heart.fill", width: 12, height: 12, withColor: .red)
            } else {
                self.favouriteIndicator.tintColor = UIColor.DefaultTextColor.color
                self.favouriteIndicator.image = UIImage.image(withName: "heart", width: 12, height: 12, withColor: UIColor.DefaultTextColor.color)
            }
        }
    
    
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        let beerID = imageTapped?(self)
        manageFavouriteIndicator(beerID: beerID!)
    }
}
