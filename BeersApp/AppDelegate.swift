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

@UIApplicationMain
@available(iOS 13.0, *)
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    var isDarkTheme = UserDefaults.standard.isDarkTheme()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = GoogleSignInConstant.clientID
        
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
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

