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
        alertView.addButton(NSLocalizedString("yes", comment: "")) {
            self.yesTapped!()
        }
        alertView.addButton(NSLocalizedString("no", comment: "")) {
            return
        }
        alertView.showNotice(title, subTitle: message, circleIconImage: UIImage(named: "d.circle"))
    }
    
    func showInfoPopup(title: String, message: String) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont.defaultTitleFont.font,
            kTextFont: UIFont.defaultDescriptionFont.font,
            kButtonFont: UIFont.defaultDescriptionFont.font,
            showCloseButton: false,
            showCircularIcon: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton(NSLocalizedString("str_ok", comment: ""), action: {
            return
        })
        alertView.showNotice(title, subTitle: message, circleIconImage: UIImage(named: "d.circle"))
    }
    
}
