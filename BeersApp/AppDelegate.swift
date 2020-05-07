//
//  AppDelegate.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 4.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import UserNotifications
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    var isDarkTheme = UserDefaults.standard.isDarkTheme()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = GoogleSignInConstant.clientID
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if #available(iOS 13.0, *) {
            if isDarkTheme {
                window?.overrideUserInterfaceStyle = .dark
            } else {
                window?.overrideUserInterfaceStyle = .light
            }
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            (granted, error) in
            if granted {
                print("Notifications permission granted!")
            }
        }
        
        if UserDefaults.standard.notificationsAreEnabled() {
            LocalPushNotificationsManager.subscribe()
        }
        if FavouriteBeersManager.shared.getFavouriteBeersArray() == nil {
            UserDefaults.standard.set(try? PropertyListEncoder().encode([BeersListModel]()), forKey: UserDefaultsKeys.favouriteBeersArray.rawValue)
        }
        
        if UserDefaults.standard.getBeersPerPage()! == 0 {
            UserDefaults.standard.saveBeersPerPage(amount: 25)
        }
        
        if UserDefaults.standard.isFirstLaunch() {
            UserDefaults.standard.saveIfAdvertsAreAllowed(true)
            UserDefaults.standard.saveIfHasTimerForAd(false)
            
            if let userDefaults = UserDefaults(suiteName: GroupIdentifier.identifier) {
                userDefaults.set(try? PropertyListEncoder().encode([BeersListModel]()), forKey: "widget")
            }
        }
        
        if UserDefaults.standard.hasTimerForAd() {
            SessionManager.shared.timeOfRewardedAdWatch = UserDefaults.standard.getDateOfAdTimerStart()
        }
        
         if let url = launchOptions?[.url] as? URL {
            if url.scheme == "open" {
                self.pushBeerDetailsVC()
            }
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        if url.scheme == "open" {
            self.pushBeerDetailsVC()
        }
        
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(
        _ application: UIApplication,
        open url: URL,
        sourceApplication: String?,
        annotation: Any
    ) -> Bool {
        
        return ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation
        )
    }
    
    private func pushBeerDetailsVC() {
        let rootViewController = self.window!.rootViewController as! UINavigationController
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "details") as! BeerDetailsViewController
        
        let id = UserDefaults(suiteName: GroupIdentifier.identifier)?.integer(forKey: "id")
        vc.selectedBeerId = id!
        vc.url = "\(URLConstants.getBeerById)\(id!)"
        
        rootViewController.pushViewController(vc, animated: true)
    }
    
    // MARK: UISceneSession Lifecycle
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if UserDefaults.standard.hasTimerForAd() {
            SessionManager.shared.timeOfRewardedAdWatch = UserDefaults.standard.getDateOfAdTimerStart()
        }
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

