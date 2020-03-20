//
//  BATabBarController.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 5.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BATabBarController: UITabBarController {
    
    //MARK: Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.barTintColor = UIColor.DefaultAppColor.color
        tabBar.tintColor = UIColor.DefaultTextColor.color
    }
    
}
