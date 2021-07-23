//
//  BALineDivider.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 6.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BALineDivider: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.backgroundColor = UIColor.DefaultAppColor.color?.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.backgroundColor = UIColor.DefaultAppColor.color?.cgColor
    }
    
}
