//
//  BADownloadImageForAvatar.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 11.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BADownloadImageForAvatar: BADownloadImageViewWithBorder {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = CGFloat(BAAvatarConstants.borderWidth)
        self.layer.cornerRadius = self.frame.size.width / 2
        
        imageView.layer.cornerRadius = self.frame.size.width / 2
        
        self.layer.shadowOpacity = Float(BAAvatarConstants.shadowOpacity)
        self.layer.shadowRadius = CGFloat(BAAvatarConstants.shadowRadius)
        self.layer.shadowColor = UIColor.black.cgColor
    }
}
