//
//  RegisterViewController.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 8.05.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit
import Firebase
import LGButton

class RegisterViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var emailTextField: BATextFilterView!
    @IBOutlet weak var passwordTextField: BATextFilterView!
    @IBOutlet weak var repeatPasswordTextfield: BATextFilterView!
    
    @IBOutlet weak var wrongInputLabel: UILabel!
    
    @IBOutlet weak var registerButton: LGButton!
    
    //MARK: - Variables
    var email = String()
    var password = String()
    
    //MARK: Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.textField.text = ""
        passwordTextField.textField.text = ""
        repeatPasswordTextfield.textField.text = ""
        
        wrongInputLabel.text = ""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.setFilterDescriptionName(to: NSLocalizedString("str_email", comment: ""))
        passwordTextField.setFilterDescriptionName(to: NSLocalizedString("str_password", comment: ""))
        repeatPasswordTextfield.setFilterDescriptionName(to: NSLocalizedString("str_repeat_password", comment: ""))
        
        passwordTextField.textField.isSecureTextEntry = true
        repeatPasswordTextfield.textField.isSecureTextEntry = true
        
        registerButton.titleString = NSLocalizedString("str_register", comment: "")
        
    }
    
    //MARK: Buttons Actions
    @IBAction func registerButtonPressed(_ sender: LGButton) {
        
        if validCredentials() {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if error != nil {
                    self.wrongInputLabel.text = NSLocalizedString("str_error_creating_user", comment: "")
                } else {
                    
                    self.wrongInputLabel.text = ""
                    
                    let user = UserModel(idToken: nil, firstName: nil, lastName: nil, fullName: nil, email: self.email, profilePicture: nil)
                    UserSessionManager.shared.setCurrentSession(user: user, auth: .email)
                    
                    UserDefaults.standard.savePreviousLogin()
                    UserDefaults.standard.saveUserEmail(email: self.email)
                    
                    self.performSegue(withIdentifier: SegueConstants.goToHome, sender: self)
                    
                }
                
            }
            
        }
        
    }
    
    //MARK: Util Methods
    private func validCredentials() -> Bool {
        return validateEmail() && validatePassword() && validatePasswordMatch()
    }
    
    private func validateEmail() -> Bool {
        
        self.email = emailTextField.textField.text!
        
        //Valid email address of type: example@domain.com
        if isRegexValid(string: self.email, regexPattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}") {
            self.wrongInputLabel.text = ""
            emailTextField.textField.makeBorderDefaultColor()
            return true
        } else {
            self.wrongInputLabel.text = NSLocalizedString("str_invalid_email", comment: "")
            emailTextField.textField.makeBorderRedColor()
            return false
        }
        
    }
    
    private func validatePassword() -> Bool {
        
        self.password = passwordTextField.textField.text!
        //Minimum eight characters, at least one upper and one lower letter and one number
        if isRegexValid(string: self.password, regexPattern: "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$") {
            
            self.wrongInputLabel.text = ""
            passwordTextField.textField.makeBorderDefaultColor()
            return true
            
        } else {
            
            self.wrongInputLabel.text = NSLocalizedString("str_invalid_password", comment: "")
            PopupManager.shared.showInfoPopup(title: NSLocalizedString("str_warning", comment: ""), message: NSLocalizedString("str_password_info", comment: ""))
            passwordTextField.textField.makeBorderRedColor()
            return false
            
        }
        
    }
    
    private func validatePasswordMatch() -> Bool {
        
        if  passwordTextField.textField.text! == repeatPasswordTextfield.textField.text! {
            
            self.wrongInputLabel.text = ""
            repeatPasswordTextfield.textField.makeBorderDefaultColor()
            return true
            
        } else {
            
            self.wrongInputLabel.text = NSLocalizedString("str_passwords_dont_match", comment: "")
            repeatPasswordTextfield.textField.makeBorderRedColor()
            return false
            
        }
        
    }
    
    private func isRegexValid(string: String, regexPattern: String) -> Bool {
        
        let range = NSRange(location: 0, length: string.utf16.count)
        let regex = try! NSRegularExpression(pattern: regexPattern)
        return regex.firstMatch(in: string, options: [], range: range) != nil
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueConstants.goToHome {
            AuthenticationManager.shared.prepareToGoToHomeScreen(segue: segue)
        }
        
    }
    
}
