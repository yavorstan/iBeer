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
import SwiftUI
import FBSDKLoginKit
import GoogleMobileAds

class SettingsScreenViewController: BAViewController {
    
    @IBOutlet weak var settingsButton: UITabBarItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var darkModeLabel: BALabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var darkModeIcon: UIImageView!
    
    @IBOutlet weak var darkModeIconConstraint: NSLayoutConstraint!
    @IBOutlet weak var darkModeLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var darkModeSwitchConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var notificationsIcon: UIImageView!
    
    @IBOutlet weak var favouritesStyleSwitch: UISegmentedControl!
    @IBOutlet weak var favouritesStyleIcon: UIImageView!
    
    @IBOutlet weak var randomBeerSwitch: UISegmentedControl!
    
    @IBOutlet weak var beersPerPageSwitch: UISegmentedControl!
    @IBOutlet weak var beersPerPageLabel: BALabel!
    
    @IBOutlet weak var languageSwitch: UISegmentedControl!
    @IBOutlet weak var languageLabel: BALabel!
    
    @IBOutlet weak var developerPageIcon: UIImageView!
    @IBOutlet weak var developerPageLabel: BALabel!
    @IBOutlet weak var aboutUsButton: BAButton!
    @IBOutlet weak var developerPageConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var watchAdvertButton: BAButton!
    @IBOutlet weak var watchAdvertLabel: BALabel!
    
    @IBOutlet weak var allowAdvertsSwitch: UISwitch!
    @IBOutlet weak var allowAdvertsLabel: BALabel!
    
    @IBOutlet weak var userAvatar: BADownloadImageForAvatar!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userFullName: BALabel!
    
    var langaugeChanged = false
    
    @IBOutlet weak var timer: BATimerLabel!
    
    var rewardedAd: GADRewardedAd?
    
    var userDidWatchAd = false
    
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var watchAdvertView: UIView!
    @IBOutlet weak var watchAdvertViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var advertsSettingsView: UIView!
    @IBOutlet weak var advertsSettingsViewTopConstraint: NSLayoutConstraint!
    
    //MARK: Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.rightBarButtonItems = []
        
        darkModeSwitch.setOn(UserDefaults.standard.isDarkTheme(), animated: false)
        notificationsSwitch.setOn(UserDefaults.standard.notificationsAreEnabled(), animated: false)
        if UserDefaults.standard.isCarouselStyle() {
            favouritesStyleSwitch.selectedSegmentIndex = SegmentedControlConstants.favouritesCarouselStyle
        } else {
            favouritesStyleSwitch.selectedSegmentIndex = SegmentedControlConstants.favouritesTableStyle
        }
        
        if UserDefaults.standard.randomBeerIsFromFavourites() {
            randomBeerSwitch.selectedSegmentIndex = SegmentedControlConstants.randomBeerFromFavorites
        } else {
            randomBeerSwitch.selectedSegmentIndex = SegmentedControlConstants.randomBeerFromAllBeers
        }
        
        if UserDefaults.standard.getBeersPerPage() == 10 {
            beersPerPageSwitch.selectedSegmentIndex = SegmentedControlConstants.tenBeersPerPage
        } else if UserDefaults.standard.getBeersPerPage() == 25 {
            beersPerPageSwitch.selectedSegmentIndex = SegmentedControlConstants.twentyFiveBeersPerPage
        } else {
            beersPerPageSwitch.selectedSegmentIndex = SegmentedControlConstants.fiftyBeersPerPage
        }
        beersPerPageLabel.text = NSLocalizedString("str_pages", comment: "")
        
        let appleLanguages = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        if appleLanguages[0] == "en-BG" || appleLanguages[0] == "en" {
            languageSwitch.selectedSegmentIndex = SegmentedControlConstants.englishLanguage
        } else if appleLanguages[0] == "bg-BG" || appleLanguages[0] == "bg" {
            languageSwitch.selectedSegmentIndex = SegmentedControlConstants.bulgarianLanguage
        } else {
            languageSwitch.selectedSegmentIndex = SegmentedControlConstants.arabicLanguage
        }
        languageLabel.text = NSLocalizedString("str_language", comment: "")
        
        developerPageLabel.text = NSLocalizedString("str_developer_page", comment: "")
        aboutUsButton.setTitle(NSLocalizedString("str_about_us", comment: ""), for: .normal)
        
        watchAdvertLabel.text = NSLocalizedString("str_watch_ad", comment: "")
        watchAdvertButton.setTitle(NSLocalizedString("str_watch_button", comment: ""), for: .normal)
        allowAdvertsLabel.text = NSLocalizedString("str_allow_ads", comment: "")
        
        if AdvertsManager.shared.userAllowedAdverts {
            allowAdvertsSwitch.setOn(true, animated: false)
            watchAdvertViewHeightConstraint.constant = SettingsScrollViewConstants.watchAdvertViewHeight
            watchAdvertView.isHidden = false
            advertsSettingsViewTopConstraint.constant = SettingsScrollViewConstants.allowSettingsViewTopConstraint
            self.scrollViewHeightConstraint.constant = SettingsScrollViewConstants.adSettingsHeight
        } else {
            allowAdvertsSwitch.setOn(false, animated: false)
            watchAdvertViewHeightConstraint.constant = 0
            watchAdvertView.isHidden = true
            advertsSettingsViewTopConstraint.constant = 0
            self.scrollViewHeightConstraint.constant = SettingsScrollViewConstants.onlyWatchAdButtonHeight
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            darkModeIcon.isHidden = false
            darkModeLabel.isHidden = false
            darkModeSwitch.isHidden = false
            darkModeIconConstraint.constant = 27
            darkModeLabelConstraint.constant = 28
            darkModeSwitchConstraint.constant = 15
            darkModeSwitch.onTintColor = UIColor.DefaultTextColor.color
            darkModeSwitch.thumbTintColor = UIColor.DefaultAppColor.color
            darkModeSwitch.backgroundColor = .lightGray
            darkModeSwitch.layer.cornerRadius = darkModeSwitch.frame.height / 2
            darkModeIcon.tintColor = UIColor.DefaultTextColor.color
        } else {
            darkModeIcon.isHidden = true
            darkModeLabel.isHidden = true
            darkModeSwitch.isHidden = true
            darkModeIconConstraint.constant = -23
            darkModeLabelConstraint.constant = -20
            darkModeSwitchConstraint.constant = -30
        }
        
        notificationsSwitch.onTintColor = UIColor.DefaultTextColor.color
        notificationsSwitch.thumbTintColor = UIColor.DefaultAppColor.color
        notificationsSwitch.backgroundColor = .lightGray
        notificationsSwitch.layer.cornerRadius = darkModeSwitch.frame.height / 2
        
        notificationsIcon.tintColor = UIColor.DefaultTextColor.color
        
        if #available(iOS 13.0, *) {
            favouritesStyleSwitch.selectedSegmentTintColor = UIColor.DefaultAppColor.color
            favouritesStyleSwitch.backgroundColor = .systemGray3
            randomBeerSwitch.selectedSegmentTintColor = UIColor.DefaultAppColor.color
            randomBeerSwitch.backgroundColor = .systemGray3
            beersPerPageSwitch.selectedSegmentTintColor = UIColor.DefaultAppColor.color
            beersPerPageSwitch.backgroundColor = .systemGray3
            languageSwitch.selectedSegmentTintColor = UIColor.DefaultAppColor.color
            languageSwitch.backgroundColor = .systemGray3
        } else {
            
            favouritesStyleSwitch.tintColor = UIColor.DefaultAppColor.color
            favouritesStyleSwitch.backgroundColor = .gray
            randomBeerSwitch.tintColor = UIColor.DefaultAppColor.color
            randomBeerSwitch.backgroundColor = .gray
            beersPerPageSwitch.tintColor = UIColor.DefaultAppColor.color
            beersPerPageSwitch.backgroundColor = .gray
            languageSwitch.tintColor = UIColor.DefaultAppColor.color
            languageSwitch.backgroundColor = .gray
        }
        favouritesStyleIcon.tintColor = UIColor.DefaultTextColor.color
        
        if #available(iOS 13.0, *) {
            developerPageIcon.isHidden = false
            developerPageLabel.isHidden = false
            aboutUsButton.isHidden = false
            developerPageConstraint.constant = 15
        } else {
            developerPageIcon.isHidden = true
            developerPageLabel.isHidden = true
            aboutUsButton.isHidden = true
            developerPageConstraint.constant = -83
        }
        
        allowAdvertsSwitch.onTintColor = UIColor.DefaultTextColor.color
        allowAdvertsSwitch.thumbTintColor = UIColor.DefaultAppColor.color
        allowAdvertsSwitch.backgroundColor = .lightGray
        allowAdvertsSwitch.layer.cornerRadius = darkModeSwitch.frame.height / 2
        
        userAvatar.populateImage(withURL: SessionManager.shared.user?.profilePicture)
        userEmail.text = SessionManager.shared.user?.email
        userFullName.text = SessionManager.shared.user?.fullName
        
        if AdvertsManager.shared.appHasAdverts {
            self.watchAdvertView.isHidden = false
            if AdvertsManager.shared.userCanEnableAdverts {
                self.advertsSettingsView.isHidden = false
                self.scrollViewHeightConstraint.constant = SettingsScrollViewConstants.adSettingsHeight
            } else {
                self.advertsSettingsView.isHidden = true
                self.scrollViewHeightConstraint.constant = SettingsScrollViewConstants.onlyWatchAdButtonHeight
            }
            self.setupAdverts()
        } else {
            self.watchAdvertView.isHidden = true
            self.scrollViewHeightConstraint.constant = SettingsScrollViewConstants.noAdsHeight
        }
        
        if UserDefaults.standard.hasTimerForAd() {
            
            let timeOfRewardedAd = Date().timeIntervalSince(SessionManager.shared.timeOfRewardedAdWatch!)
            if timeOfRewardedAd < AdvertsConstants.timeIntervalForRewardedAd {
                self.watchAdvertButton.isHidden = true
                
                let rewardedAdRemainingTime = AdvertsConstants.timeIntervalForRewardedAd-timeOfRewardedAd
                timer.startTimer(forSeconds: rewardedAdRemainingTime, completion: { () -> Void in
                    self.watchAdvertButton.isHidden = false
                    UserDefaults.standard.saveIfHasTimerForAd(false)
                })
                
            } else {
                self.watchAdvertButton.isHidden = false
                UserDefaults.standard.saveIfHasTimerForAd(false)
            }
        }
        
    }
    
    //MARK: Buttons Actions
    @available(iOS 13.0, *)
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        AuthenticationManager.shared.logout(authenticationType: SessionManager.shared.authType!)
        AuthenticationManager.shared.successfulLogout = { () -> Void in
            weak var weakSelf = self
            weakSelf?.navigationController?.popToRootViewController(animated: true)
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
        if sender.selectedSegmentIndex == SegmentedControlConstants.favouritesTableStyle {
            UserDefaults.standard.saveFavouritesStyleToPhoneMemory(isCarousel: false)
        } else {
            UserDefaults.standard.saveFavouritesStyleToPhoneMemory(isCarousel: true)
        }
    }
    @IBAction func randomBeerSwitchActivated(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == SegmentedControlConstants.randomBeerFromAllBeers {
            UserDefaults.standard.saveRandomBeerSetting(fromFavourites: false)
        } else {
            if FavouriteBeersManager.shared.getFavouriteBeersArray()!.isEmpty {
                sender.selectedSegmentIndex = SegmentedControlConstants.randomBeerFromAllBeers
                HUD.flash(.label(NSLocalizedString("str_no_fav_beers", comment: "")), delay: 1.2)
                return
            }
            UserDefaults.standard.saveRandomBeerSetting(fromFavourites: true)
        }
    }
    @IBAction func beerPerPageSwitchActivated(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == SegmentedControlConstants.tenBeersPerPage {
            UserDefaults.standard.saveBeersPerPage(amount: 10)
            URLConstants.beersByPage = 10
            URLConstants.withPages = "&per_page=\(URLConstants.beersByPage)&"
        } else if sender.selectedSegmentIndex == SegmentedControlConstants.twentyFiveBeersPerPage {
            UserDefaults.standard.saveBeersPerPage(amount: 25)
            URLConstants.beersByPage = 25
            URLConstants.withPages = "&per_page=\(URLConstants.beersByPage)&"
        } else {
            UserDefaults.standard.saveBeersPerPage(amount: 50)
            URLConstants.beersByPage = 50
            URLConstants.withPages = "&per_page=\(URLConstants.beersByPage)&"
        }
    }
    @IBAction func languageButtonPressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == SegmentedControlConstants.englishLanguage {
            self.updateAppLanguageTo(language: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        } else if sender.selectedSegmentIndex == SegmentedControlConstants.bulgarianLanguage {
            self.updateAppLanguageTo(language: "bg")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        } else {
            self.updateAppLanguageTo(language: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        UserDefaults.standard.saveIfLanguageChange(isChanged: true)
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let root = storyboard.instantiateInitialViewController() as! UINavigationController

        UIApplication.shared.keyWindow?.rootViewController = root
    }
    @available(iOS 13.0, *)
    @IBSegueAction func aboutUsButtonPressed(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: DeveloperPage())
    }
    @IBAction func watchAdvertButtonPressed(_ sender: Any) {
        if rewardedAd?.isReady == true {
            rewardedAd?.present(fromRootViewController: self, delegate:self)
        }
    }
    @IBAction func allowAdvertsSwitch(_ sender: UISwitch) {
        if sender.isOn {
            UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.watchAdvertView.isHidden = false
                self.watchAdvertViewHeightConstraint.constant = SettingsScrollViewConstants.watchAdvertViewHeight
                self.advertsSettingsViewTopConstraint.constant = SettingsScrollViewConstants.allowSettingsViewTopConstraint
                self.scrollViewHeightConstraint.constant = SettingsScrollViewConstants.adSettingsHeight
            }, completion: nil)
            
            AdvertsManager.shared.userAllowedAdverts = true
            UserDefaults.standard.saveIfAdvertsAreAllowed(true)
            if (rewardedAd?.isReady) != nil {
                self.rewardedAd = AdvertsManager.shared.createAndLoadRewardedAd()
            }
        } else {
            UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.watchAdvertView.isHidden = true
                self.watchAdvertViewHeightConstraint.constant = 0
                self.advertsSettingsViewTopConstraint.constant = 0
                self.scrollViewHeightConstraint.constant = SettingsScrollViewConstants.onlyWatchAdButtonHeight
            }, completion: nil)
            
            AdvertsManager.shared.userAllowedAdverts = false
            UserDefaults.standard.saveIfAdvertsAreAllowed(false)
        }
    }
    
    
    //MARK: Util Methods
    private func updateAppLanguageTo(language: String) {
        UserDefaults.standard.set(["\(language)-BG"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        Bundle.setLanguage(language)
    }
    
    
    //MARK: Adverts Methods
    private func setupAdverts() {
        rewardedAd = GADRewardedAd(adUnitID: AdvertsConstants.rewaredAdUnitID)
        AdvertsManager.shared.setupAdverts(rewardedAd!)
    }
}

//MARK: - RewardedAdDelegate
extension SettingsScreenViewController: GADRewardedAdDelegate {
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        self.userDidWatchAd = true
    }
    
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
    }
    
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        self.rewardedAd = AdvertsManager.shared.createAndLoadRewardedAd()
        self.watchAdvertButton.isHidden = true
        
        if self.userDidWatchAd {
            HUD.flash(.label(NSLocalizedString("str_reward_ad", comment: "")), delay: 1.0)
            self.userDidWatchAd = false
        }
        
        UserDefaults.standard.saveIfHasTimerForAd(true)
        UserDefaults.standard.saveDateOfAdTimerStart(date: Date())
        
        timer.startTimer(forSeconds: AdvertsConstants.timeIntervalForRewardedAd, completion: { () -> Void in
            self.watchAdvertButton.isHidden = false
            UserDefaults.standard.saveIfHasTimerForAd(false)
        })
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        HUD.flash(.label("Couldn't display advert!"), delay: 0.6)
        watchAdvertButton.isHidden = false
        timer.invalidate()
    }
    
}
