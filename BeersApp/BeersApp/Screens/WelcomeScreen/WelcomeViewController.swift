//
//  WelcomeViewController.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 4.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit
import GoogleSignIn
import PKHUD
import Alamofire
import FBSDKLoginKit
import GoogleMobileAds

class WelcomeViewController: BAViewController {
    
    @IBOutlet weak var logoImageView: BALogo!
    @IBOutlet weak var logoImageYConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var fb: FBButton!
    @IBOutlet weak var googleSignInButton: UIButton!
    
    //MARK: Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logoImageYConstraint.constant = CGFloat(BALogoConstants.startingConstraintConstant)
        self.view.layoutIfNeeded()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: BALogoConstants.animationDuration, delay: 0.5, options: [.curveEaseOut], animations: {
            self.logoImageYConstraint.constant = CGFloat(BALogoConstants.finishConstraintConstant)
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AuthenticationManager.shared.successfulLogin = { () -> Void in
            self.performSegue(withIdentifier: SegueConstants.goToHome, sender: self)
        }
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        signInButton.style = .wide
        googleSignInButton.clipsToBounds = false
        
        fb.layer.cornerRadius = 5
        fb.clipsToBounds = true
        fb.setTitle("Sign in with Facebook", for: .normal)
        fb.titleLabel?.textAlignment = .center
        
        if let token = AccessToken.current,
            !token.isExpired {
            AuthenticationManager.shared.getFacebookUserData()
            self.performSegue(withIdentifier: SegueConstants.goToHome, sender: self)
        }
    }
    
    //MARK: Button Actions
    @IBAction func googleSignInPressed(_ sender: Any) {
        AuthenticationManager.shared.login(with: .google)
    }
    @IBAction func facebookSignInPressed(_ sender: FBButton) {
        AuthenticationManager.shared.login(with: .facebook)
    }
    
    //MARK: Utils Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabBarController = segue.destination as? UITabBarController
        if UserDefaults.standard.isLanguageChanged() {
            tabBarController?.selectedIndex = 2
            UserDefaults.standard.saveIfLanguageChange(isChanged: false)
        } else {
            tabBarController?.selectedIndex = 1
        }
        tabBarController?.navigationItem.hidesBackButton = true
    }
}
