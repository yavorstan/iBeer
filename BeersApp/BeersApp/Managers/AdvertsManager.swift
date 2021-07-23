//
//  AdvertsManager.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 15.04.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation
import GoogleMobileAds

class AdvertsManager {
    
    //MARK: - Constants
    
    /* Change this property in order to enable/disable ads at all. */
    let appHasAdverts = true
    
    static let shared = AdvertsManager()
    
    //MARK: - Variables
    
    /* Change this property to allow/disallow the user to enable/disable ads from settings. */
    var userCanEnableAdverts = true
    
    var userAllowedAdverts = Bool()
    
    //MARK: - Instance methods
    private init(){
        
        if appHasAdverts {
            
            if userCanEnableAdverts {
                userAllowedAdverts = UserDefaults.standard.areAdvertsAllowed()
            } else {
                userAllowedAdverts = true
            }
            
        } else {
            userCanEnableAdverts = false
            userAllowedAdverts = false
        }
        
    }
    
    //Load Adaptive Banner Advert
    func loadBannerAd(_ bannerView: GADBannerView, view: UIView) {
        if userAllowedAdverts {
            let frame = { () -> CGRect in
                if #available(iOS 11.0, *) {
                    return view.frame.inset(by: view.safeAreaInsets)
                } else {
                    return view.frame
                }
            }()
            let viewWidth = frame.size.width
            
            bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
            
            bannerView.load(GADRequest())
        }
    }
    
    //Load Rewarded Adverts
    func setupAdverts(_ rewardedAd: GADRewardedAd) {
        if userAllowedAdverts {
            rewardedAd.load(GADRequest()) { error in
                if let error = error {
                    print("Loading failed: \(error)")
                } else {
                    print("Loading Succeeded")
                }
            }
        }
    }
    
    func createAndLoadRewardedAd() -> GADRewardedAd? {
        if userAllowedAdverts {
            let rewardedAd = GADRewardedAd(adUnitID: AdvertsConstants.rewaredAdUnitID)
            rewardedAd.load(GADRequest()) { error in
                if let error = error {
                    print("Loading failed: \(error)")
                } else {
                    print("Loading Succeeded")
                }
            }
            return rewardedAd
        }
        return nil
    }
    
}
