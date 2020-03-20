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

class WelcomeViewController: BAViewController {

    @IBOutlet weak var logoImageView: BALogo!
    @IBOutlet weak var logoImageYConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    
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
        signInButton.backgroundColor = UIColor.DefaultAppColor.color
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    //MARK: Button Actions
    @IBAction func signInButtonPressed(_ sender: Any) {
        HUD.show(.progress)
        signInButton.isEnabled = false
        GIDSignIn.sharedInstance()?.signIn()
        HUD.hide(animated: true)
        self.performSegue(withIdentifier: SegueConstants.goToHome, sender: self)
    }
    
    //MARK: Utils Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabBarController = segue.destination as? UITabBarController
        tabBarController?.selectedIndex = 1
    }
}

//MARK: - GoogleSignInDelegate

extension WelcomeViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        var picture = URL(string: URLConstants.defaultImageForUser)
        if user.profile.hasImage {
            picture = user.profile.imageURL(withDimension: 200)
        }
        let user = User(idToken: idToken!, firstName: givenName!, lastName: familyName!, fullName: fullName!, email: email!, profilePicture: picture!)
        UserDefaults.standard.saveUserInPhoneMemory(user: user)
        
        self.performSegue(withIdentifier: SegueConstants.goToHome, sender: self)
    }
}
