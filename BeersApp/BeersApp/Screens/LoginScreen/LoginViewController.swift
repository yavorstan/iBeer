//
//  LoginAndRegisterViewController.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 7.05.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit
import Firebase
import LGButton

class LoginViewController: BAViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var emailTextField: BATextFilterView!
    @IBOutlet weak var passwordTextField: BATextFilterView!
    
    @IBOutlet weak var incorrectCredentialsLabel: UILabel!
    
    @IBOutlet weak var loginButton: LGButton!
    @IBOutlet weak var registerButton: LGButton!
    
    //MARK: Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.textField.text = ""
        passwordTextField.textField.text = ""
        
        incorrectCredentialsLabel.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AuthenticationManager.shared.successfulLogin = { () -> Void in
            self.incorrectCredentialsLabel.isHidden = true
            self.performSegue(withIdentifier: SegueConstants.goToHome, sender: self)
        }
        AuthenticationManager.shared.unsuccessfulLogin = { () -> Void in
            self.incorrectCredentialsLabel.isHidden = false
            self.passwordTextField.textField.text = ""
        }
        
        emailTextField.setFilterDescriptionName(to: NSLocalizedString("str_email", comment: ""))
        passwordTextField.setFilterDescriptionName(to: NSLocalizedString("str_password", comment: ""))
        
        passwordTextField.textField.isSecureTextEntry = true
        
        incorrectCredentialsLabel.text = NSLocalizedString("str_incorrect_credentials", comment: "")
        
        loginButton.titleString = NSLocalizedString("str_login", comment: "")
        registerButton.titleString = NSLocalizedString("str_register", comment: "")
    }
    
    //MARK: Buttons Actions
    @IBAction func loginButtonPressed(_ sender: LGButton) {
        let email = emailTextField.textField.text
        let password = passwordTextField.textField.text
        if email != nil && password != nil {
            let loginInformation = [email, password] as AnyObject
            AuthenticationManager.shared.loginInformation = loginInformation
            AuthenticationManager.shared.login(with: .email)
        } else {
            self.incorrectCredentialsLabel.isHidden = false
        }
    }
    @IBAction func registerButtonPressed(_ sender: LGButton) {
        performSegue(withIdentifier: SegueConstants.goToRegister, sender: self)
    }
    
    //MARK: Util Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueConstants.goToHome {
            AuthenticationManager.shared.prepareToGoToHomeScreen(segue: segue)
        }
    }
    
}
