//
//  BADownloadImageViewWithBorder.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 6.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BADownloadImageViewWithBorder: BADownloadImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = UIColor.DefaultAppColor.color?.cgColor
        
        self.layer.borderWidth = CGFloat(BAImageConstants.borderWidth)
        self.layer.cornerRadius = CGFloat(BAImageConstants.cornerRadius)
    }
    
   override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = UIColor.DefaultAppColor.color?.cgColor
    }
    
}




