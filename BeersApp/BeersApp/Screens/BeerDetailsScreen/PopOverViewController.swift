//
//  PopOverViewController.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 9.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class PopOverViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    
    var textMessage = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.font = UIFont.defaultInfoFont.font
        textLabel.text = textMessage
        textLabel.textColor = UIColor.DefaultTextColor.color
        self.view.backgroundColor = UIColor.DefaultAppColor.color
    }
}
