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
    }
    
    func populate(beer: BeersListModel) {
        self.beerName.text = beer.name
        self.beerTagLine.text = beer.tagLine
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
}
