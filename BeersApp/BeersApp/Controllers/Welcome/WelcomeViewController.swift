//
//  WelcomeViewController.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 4.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import LGButton

class WelcomeViewController: BAViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var logoImageView: BALogo!
    @IBOutlet weak var logoImageYConstraint: NSLayoutConstraint!
    
    //MARK: Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AuthenticationManager.shared.successfulLogin = { () -> Void in
            self.performSegue(withIdentifier: SegueConstants.goToHome, sender: self)
        }
        
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
        
        if let token = AccessToken.current,
            !token.isExpired {
            AuthenticationManager.shared.getFacebookUserData()
            self.performSegue(withIdentifier: SegueConstants.goToHome, sender: self)
        }
        
        if UserDefaults.standard.hasPreviousLogin() {
            
            let email = UserDefaults.standard.getEmailForLogin()
            let user = UserModel(idToken: nil, firstName: nil, lastName: nil, fullName: nil, email: email, profilePicture: nil)
            
            UserSessionManager.shared.setCurrentSession(user: user, auth: .email)
            self.performSegue(withIdentifier: SegueConstants.goToHome, sender: self)
            
        }
    }
    
    //MARK: Button Actions
    @IBAction func continueWithGooglePressed(_ sender: LGButton) {
        AuthenticationManager.shared.login(with: .google)
    }
    
    @IBAction func continueWithFacebookPressed(_ sender: LGButton) {
        AuthenticationManager.shared.login(with: .facebook)
    }
    
    @IBAction func continueWithEmailPressed(_ sender: LGButton) {
        performSegue(withIdentifier: SegueConstants.goToLogin, sender: self)
    }
    
    
    //MARK: Utils Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueConstants.goToHome {
            AuthenticationManager.shared.prepareToGoToHomeScreen(segue: segue)
        }
        
    }
    
}
