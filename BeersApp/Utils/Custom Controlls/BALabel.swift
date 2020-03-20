//
//  BALabel.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 6.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BALabel: UILabel {
    override func awakeFromNib() {
        self.textColor = UIColor.DefaultTextColor.color
        self.font = UIFont.defaultTitleFont.font
    }
}
