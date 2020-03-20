//
//  BAButton.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 4.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BAButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = CGFloat(BAButtonConstants.cornerRadius)
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = Float(BAButtonConstants.shadowOpacity)
        self.layer.shadowRadius = CGFloat(BAButtonConstants.shadowRadius)
        self.backgroundColor = UIColor.DefaultAppColor.color
        self.setTitleColor(UIColor.DefaultTextColor.color, for: .normal)
    }
}
