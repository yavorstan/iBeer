//
//  BATextField.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 22.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BATextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = CGFloat(BAButtonConstants.cornerRadius)
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = Float(BAButtonConstants.shadowOpacity)
        self.layer.shadowRadius = CGFloat(BAButtonConstants.shadowRadius)
        
        self.borderStyle = .roundedRect
        
        self.autocorrectionType = .no
        
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.DefaultAppColor.color?.cgColor
        self.layer.borderWidth = 2.0
        self.textColor = UIColor.black
        self.font = UIFont.defaultTitleFont.font
        self.clipsToBounds = true
        
        let customAcc = Bundle.main.loadNibNamed("CustomAccessoryView", owner: self, options: nil)?.first as! CustomAccessoryView?
        
        customAcc?.doneHandler = { () -> Void in
            self.endEditing(true)
        }
        customAcc?.clearHandler = { () -> Void in
            self.text = ""
            self.endEditing(true)
        }
        
        self.inputAccessoryView = customAcc
    }
    
    func makeBorderRedColor() {
        self.layer.borderColor = UIColor.red.cgColor
    }
    func makeBorderDefaultColor() {
        self.layer.borderColor = UIColor.DefaultAppColor.color?.cgColor
    }
    
    override func becomeFirstResponder() -> Bool {
        self.layer.borderColor = UIColor.lightGray.cgColor
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        let isDarkTheme = UserDefaults.standard.isDarkTheme()
        if isDarkTheme {
            self.layer.borderColor = #colorLiteral(red: 0.1521503329, green: 0.1761028469, blue: 0.2010999322, alpha: 1)
        } else {
            self.layer.borderColor = #colorLiteral(red: 1, green: 0.8301557241, blue: 0.3206228965, alpha: 1)
        }
        return super.resignFirstResponder()
    }
    
    func changeDoneHandler(_ paramHandler: @escaping () -> ()) {
        let accView = self.inputAccessoryView as! CustomAccessoryView
        accView.doneHandler = paramHandler
    }
}
