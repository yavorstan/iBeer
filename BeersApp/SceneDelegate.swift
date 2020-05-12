//
//  SceneDelegate.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 4.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var isDarkTheme = UserDefaults.standard.isDarkTheme()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let context = connectionOptions.urlContexts.first else { return }
        
        if context.url.scheme == "open" {
            self.pushBeerDetailsVC()
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let context = URLContexts.first else { return }
        
        if context.url.scheme == "open" {
            self.pushBeerDetailsVC()
        }
        
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: context.url,
            sourceApplication: context.options.sourceApplication,
            annotation: context.options.annotation
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
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        isDarkTheme = UserDefaults.standard.isDarkTheme()
        if isDarkTheme {
            window?.overrideUserInterfaceStyle = .dark
        } else {
            window?.overrideUserInterfaceStyle = .light
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

