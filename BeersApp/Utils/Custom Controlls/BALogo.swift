//
//  BALogo.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 4.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BALogo: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.image = #imageLiteral(resourceName: "logo")
        self.layer.cornerRadius = CGFloat(BALogoConstants.cornerRadius)
    }
    
}
