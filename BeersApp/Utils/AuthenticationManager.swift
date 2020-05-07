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

//MARK: Authentication Types
public enum AuthenticationTypes {
    case google
    case facebook
}

//MARK: Authentiacion Manager
class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init(){}
    
    var successfulLogin: (() -> ())?
    var successfulLogout: (() -> ())?
    
    //MARK: Login
    func login(with loginType: AuthenticationTypes) {
        switch loginType {
        case .google:
            loginWithGoogle()
        case .facebook:
            loginWithFacebook()
        }
    }

    //MARK: Logout
    func logout(authenticationType auth: AuthenticationTypes){
        let popupManager = PopupManager()
        let title = NSLocalizedString("str_warning", comment: "")
        let message = NSLocalizedString("str_logout", comment: "")
        popupManager.showConfirmPopup(title: title, message: message)
        popupManager.yesTapped = { () in
            switch auth {
            case .google:
                GIDSignIn.sharedInstance().signOut()
            case .facebook:
                let loginManager = LoginManager()
                loginManager.logOut()
            }
            UserDefaults.standard.deleteUserFromPhoneMemory()
            SessionManager.shared.deleteCurrentSession()
            AuthenticationManager.shared.successfulLogout!()
            HUD.flash(.label(NSLocalizedString("str_logged_out", comment: "")), delay: 0.6)
        }
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
                    
                    let user = User(idToken: userID, firstName: "", lastName: "", fullName: userFullName, email: userEmail, profilePicture: facebookProfileUrl!)
                    
                    UserDefaults.standard.saveUserInPhoneMemory(user: user)
                    
                    SessionManager.shared.setCurrentSession(user: user, auth: .facebook)
                } else {
                    print(error!)
                }
            })
        }
    }
    
}

//MARK: - Google Login
private func loginWithGoogle() {
    GIDSignIn.sharedInstance()?.signIn()
}
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
        
        if URLConstants.mainURL == URLConstants.punkAPI || UserDefaults.standard.hasUserInPhoneMemory() {
            UserDefaults.standard.saveUserInPhoneMemory(user: user)
    
            SessionManager.shared.setCurrentSession(user: user, auth: .google)
            
            AuthenticationManager.shared.successfulLogin!()
        } else {
            let endpoint = "\(URLConstants.testAPIAuthenticate)\(user.idToken)"
            AF.request(endpoint, method: .post).validate(statusCode: 200..<300).response { response in
                switch response.result {
                case .success:
                    HUD.flash(.success)
                    UserDefaults.standard.saveUserInPhoneMemory(user: user)
                    
                    SessionManager.shared.setCurrentSession(user: user, auth: .google)
                    
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
