//
//  PopupManager.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 18.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit
import SCLAlertView

class PopupManager {
    
    var yesTapped: (() -> ())?
    
    func showConfirmPopup(title: String, message: String) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont.defaultTitleFont.font,
            kTextFont: UIFont.defaultDescriptionFont.font,
            kButtonFont: UIFont.defaultDescriptionFont.font,
            showCloseButton: false,
            showCircularIcon: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Yes") {
            self.yesTapped!()
        }
        alertView.addButton("No") {
            return
        }
        alertView.showNotice(title, subTitle: message, circleIconImage: UIImage(named: "d.circle"))
    }
}
