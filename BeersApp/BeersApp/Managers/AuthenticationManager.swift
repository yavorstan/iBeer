//
//  AuthenticationManager.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 13.04.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import Foundation
import PKHUD
import Alamofire
import GoogleSignIn
import FBSDKLoginKit
import Firebase

//MARK: Authentication Types
public enum AuthenticationTypes {
    case google
    case facebook
    case email
}

//MARK: Authentiacion Manager
class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init(){}
    
    //MARK: - Variables
    var successfulLogin: (() -> ())?
    var unsuccessfulLogin: (() -> ())?
    var successfulLogout: (() -> ())?
    
    var loginInformation: AnyObject?
    
    //MARK: Login
    func login(with loginType: AuthenticationTypes) {
        switch loginType {
        case .google:
            loginWithGoogle()
        case .facebook:
            loginWithFacebook()
        case .email:
            loginWithEmail()
        }
    }
    
    //MARK: Logout
    func logout(authenticationType auth: AuthenticationTypes){

        let title = NSLocalizedString("str_warning", comment: "")
        let message = NSLocalizedString("str_logout", comment: "")
        let confirmationHandler = { () in
            
            switch auth {
            case .google:
                GIDSignIn.sharedInstance().signOut()
            case .facebook:
                let loginManager = LoginManager()
                loginManager.logOut()
            case .email:
                let firebaseAuth = Auth.auth()
                do {
                    UserDefaults.standard.removePreviousLogin()
                    try firebaseAuth.signOut()
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            }
            
            UserDefaults.standard.deleteUserFromPhoneMemory()
            UserSessionManager.shared.deleteCurrentSession()
            AuthenticationManager.shared.successfulLogout!()
            HUD.flash(.label(NSLocalizedString("str_logged_out", comment: "")), delay: 0.6)
            
        }
        
        PopupManager.shared.showConfirmPopup(title: title,
                                             message: message,
                                             confirmationHandler: confirmationHandler)
        
    }
    
    //MARK: Util Methods
    func getFacebookUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                
                if error == nil{
                    let dict = result as! [String : AnyObject]
                    
                    let userID = dict["id"] as! String
                    let userFullName = dict["name"] as! String
                    let userEmail = dict["email"] as! String
                    
                    let pictureDict = dict["picture"] as! [String : AnyObject]
                    let dataDict = pictureDict["data"] as! [String : AnyObject]
                    let url = dataDict["url"] as! String
                    let facebookProfileUrl = URL(string: url)
                    
                    let user = UserModel(idToken: userID, firstName: "", lastName: "", fullName: userFullName, email: userEmail, profilePicture: facebookProfileUrl!)
                    
                    UserDefaults.standard.saveUserInPhoneMemory(user: user)
                    
                    UserSessionManager.shared.setCurrentSession(user: user, auth: .facebook)
                } else {
                    print(error!)
                }
            })
        }
    }
    
    //Prepare for segueing into the application
    func prepareToGoToHomeScreen(segue: UIStoryboardSegue) {
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

//MARK: - Google Login
private func loginWithGoogle() {
    GIDSignIn.sharedInstance()?.signIn()
}
extension WelcomeViewController: GIDSignInDelegate {
    
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
        let user = UserModel(idToken: idToken!, firstName: givenName!, lastName: familyName!, fullName: fullName!, email: email!, profilePicture: picture!)
        
        if URLConstants.mainURL == URLConstants.punkAPI || UserDefaults.standard.hasUserInPhoneMemory() {
            UserDefaults.standard.saveUserInPhoneMemory(user: user)
            
            UserSessionManager.shared.setCurrentSession(user: user, auth: .google)
            
            AuthenticationManager.shared.successfulLogin!()
        } else {
            let endpoint = "\(URLConstants.testAPIAuthenticate)\(user.idToken)"
            AF.request(endpoint, method: .post).validate(statusCode: 200..<300).response { response in
                switch response.result {
                case .success:
                    HUD.flash(.success)
                    UserDefaults.standard.saveUserInPhoneMemory(user: user)
                    
                    UserSessionManager.shared.setCurrentSession(user: user, auth: .google)
                    
                    AuthenticationManager.shared.successfulLogin!()
                case let .failure(error):
                    print(error)
                    HUD.flash(.label("Error signing in!"), delay: 0.7)
                }
            }
        }
    }
}

//MARK: - Facebook Login
private func loginWithFacebook() {
    let loginManager = LoginManager()
    loginManager.logIn(permissions: ["public_profile", "email"], from: WelcomeViewController(), handler: {
        (result, error) in
        
        if error != nil {
            print(error!)
        } else if result!.isCancelled {
            HUD.flash(.label("Login canceled!"), delay: 0.5)
        } else {
            AuthenticationManager.shared.getFacebookUserData()
            AuthenticationManager.shared.successfulLogin!()
        }
    })
}

//MARK: - Email Login
extension AuthenticationManager {
    private func loginWithEmail() {
        let loginInfo = self.loginInformation as! [String]
        
        let email = loginInfo[0]
        let password = loginInfo[1]
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            if error != nil {
                self?.unsuccessfulLogin!()
            } else {
                let user = UserModel(idToken: nil, firstName: nil, lastName: nil, fullName: nil, email: email, profilePicture: nil)
                UserSessionManager.shared.setCurrentSession(user: user, auth: .email)
                
                UserDefaults.standard.savePreviousLogin()
                UserDefaults.standard.saveUserEmail(email: email)
                
                self?.successfulLogin!()
            }
        }
    }
}

