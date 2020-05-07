//
//  BATabBarController.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 5.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BATabBarController: UITabBarController {
    
    let imageNames = ["heart.fill", "house.fill", "gear"]
    
    //MARK: Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.barTintColor = UIColor.DefaultAppColor.color
        tabBar.tintColor = UIColor.DefaultTextColor.color
        
        for i in 0...2 {
            self.tabBar.items![i].image = UIImage.image(withName: imageNames[i], width: 26, height: 26, withColor: nil)
            self.tabBar.items![i].selectedImage = UIImage.image(withName: imageNames[i], width: 26, height: 26, withColor: nil)
        }
    }
    
}
