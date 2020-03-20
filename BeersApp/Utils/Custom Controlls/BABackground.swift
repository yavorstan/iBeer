//
//  BABackground.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 4.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BABackground: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.image = #imageLiteral(resourceName: "background")
        self.contentMode = .scaleAspectFill
        self.alpha = 0.9
    }
    
}
