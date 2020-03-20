//
//  SettingsScreenViewController.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 5.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit
import GoogleSignIn
import PKHUD
import UserNotifications
import SCLAlertView

class SettingsScreenViewController: BAViewController {
    
    let user = UserDefaults.standard.getUserFromPhoneMemory()
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var darkModeIcon: UIImageView!
    
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var notificationsIcon: UIImageView!
    
    @IBOutlet weak var favouritesStyleSwitch: UISegmentedControl!
    @IBOutlet weak var favouritesStyleIcon: UIImageView!
    
    @IBOutlet weak var userAvatar: BADownloadImageForAvatar!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userFullName: BALabel!
    
    //MARK: Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.rightBarButtonItems = []
        
        darkModeSwitch.setOn(UserDefaults.standard.isDarkTheme(), animated: false)
        notificationsSwitch.setOn(UserDefaults.standard.notificationsAreEnabled(), animated: false)
        if UserDefaults.standard.isCarouselStyle() {
            favouritesStyleSwitch.selectedSegmentIndex = 1
        } else {
            favouritesStyleSwitch.selectedSegmentIndex = 0
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        darkModeSwitch.onTintColor = UIColor.DefaultAppColor.color
        darkModeIcon.tintColor = UIColor.DefaultTextColor.color
        
        notificationsSwitch.onTintColor = UIColor.DefaultAppColor.color
        notificationsIcon.tintColor = UIColor.DefaultTextColor.color
        
        if #available(iOS 13.0, *) {
            favouritesStyleSwitch.selectedSegmentTintColor = UIColor.DefaultAppColor.color
        } else {
        }
        favouritesStyleIcon.tintColor = UIColor.DefaultTextColor.color
        
        userAvatar.populateImage(withURL: user.profilePicture)
        userEmail.text = user.email
        userFullName.text = user.fullName
    }
    
    //MARK: Buttons Actions
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        let popupManager = PopupManager()
        weak var weakSelf = self
        popupManager.showConfirmPopup(title: "WARNING", message: "Are you sure you want to logout?")
        popupManager.yesTapped = { () in
            GIDSignIn.sharedInstance().signOut()
            weakSelf?.navigationController?.popToRootViewController(animated: true)
            HUD.flash(.label("Logged Out"), delay: 0.6)
        }
    }
    @IBAction func themeSwitchActivated(_ sender: UISwitch) {
        if #available(iOS 13.0, *){
            if sender.isOn {
                UserDefaults.standard.saveThemeModeToPhoneMemory(isDark: true)
                UIApplication.shared.windows.first!.overrideUserInterfaceStyle = .dark
            } else {
                UserDefaults.standard.saveThemeModeToPhoneMemory(isDark: false)
                UIApplication.shared.windows.first!.overrideUserInterfaceStyle = .light
            }
        }
    }
    @IBAction func notificationsSwitchActivated(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.saveNotificationsMode(enabled: true)
            LocalPushNotificationsManager.subscribe()
        } else {
            UserDefaults.standard.saveNotificationsMode(enabled: false)
            LocalPushNotificationsManager.unSubscribe()
        }
    }
    @IBAction func favouritesStyleSwitchActivated(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UserDefaults.standard.saveFavouritesStyleToPhoneMemory(isCarousel: false)
        } else {
            UserDefaults.standard.saveFavouritesStyleToPhoneMemory(isCarousel: true)
        }
    }
    
}
