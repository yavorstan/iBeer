//
//  BAViewController.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 4.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit
import UserNotifications
import PKHUD

class BAViewController: UIViewController {
    
    var isDarkMode = UserDefaults.standard.isDarkTheme()
    
    //MARK: Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad()  {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.DefaultAppColor.color
        navigationController?.navigationBar.tintColor = UIColor.DefaultTextColor.color
        self.tabBarController?.title = LabelConstants.appTitle
        self.navigationController?.title = LabelConstants.appTitle
        self.view.backgroundColor = UIColor.DefaultBackgroundViewColor.color
    }

    func showPopOver(sender: UIButton, text: String, height: Int) {
        let popVC = storyboard?.instantiateViewController(withIdentifier: "popVC") as! PopOverViewController
        popVC.modalPresentationStyle = .popover
        popVC.textMessage = text
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = sender
        popOverVC?.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.minY, width: sender.bounds.width/30, height: sender.bounds.height)
        popVC.preferredContentSize = CGSize(width: PopOverConstants.width, height: height)
        self.present(popVC, animated: true)
    }
    
    func failedWithError(error: Error) {
        print(error)
        DispatchQueue.main.async {
            HUD.hide()
            HUD.flash(.label("Something went wrong!"), delay: 1.0)
        }
    }
    
    func placeBackgroundAtForemostPostition(background: BABackground) {
        background.alpha = 1
        self.view.insertSubview(background, at: self.view.subviews.count)
    }
    func placeBackgroundAtLastPosition(background: BABackground){
        background.alpha = 0.8
        self.view.insertSubview(background, at: 0)
    }
}

//MARK: - PopoverPresentationControllerDelegate
extension BAViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

