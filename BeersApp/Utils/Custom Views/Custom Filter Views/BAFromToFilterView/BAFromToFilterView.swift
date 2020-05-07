//
//  BAFromToFilterView.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 23.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit
import PKHUD

class BAFromToFilterView: UIView {
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var label: BALabel!
    @IBOutlet weak var fromTextField: BATextField!
    @IBOutlet weak var toTextField: BATextField!
    
    @IBOutlet weak var fromLabel: BALabel!
    @IBOutlet weak var toLabel: BALabel!
    
    //MARK: Lyfecylce Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func setup() { Bundle.main.loadNibNamed("BAFromToFilterView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        fromTextField.delegate = self
        toTextField.delegate = self
        fromLabel.text = NSLocalizedString("from", comment: "")
        toLabel.text = NSLocalizedString("to", comment: "")
    }
    
    //MARK: Util Methods
    private func hasFromInput() -> Bool {
        return fromTextField.text != "" && !fromTextField.text!.isEmpty
    }
    private func hasToInput() -> Bool {
        return toTextField.text != "" && !toTextField.text!.isEmpty
    }
    
    private func hasValidInput(_ textField: BATextField) -> Bool {
        let currentTextFieldValue = NumberFormatter().number(from: textField.text!)?.doubleValue
        if hasMoreThanOneDecimalPoint(textField){
            textField.makeBorderRedColor()
            return false
        } else if textField == fromTextField && hasToInput() {
            let toTextFieldValue = NumberFormatter().number(from: toTextField.text!)?.doubleValue
            if currentTextFieldValue ?? 0 > toTextFieldValue! {
                textField.makeBorderRedColor()
                return false
            }
        } else if textField == toTextField && hasToInput() && hasFromInput() {
            let fromTextFieldValue = NumberFormatter().number(from: fromTextField.text!)?.doubleValue
            if currentTextFieldValue ?? 0 < fromTextFieldValue! {
                textField.makeBorderRedColor()
                return false
            }
        }
        return true
    }
    
    private func hasMoreThanOneDecimalPoint(_ textField: BATextField) -> Bool {
        guard let input = textField.text, !textField.text!.isEmpty else {
            return false
        }
        let decimalPoints = input.filter { $0 == Character(String(".")) }
        if decimalPoints.count > 1 {
            return true
        }
        return false
    }
    
}

//MARK: - Filterable
extension BAFromToFilterView: Filterable {
    func setFilterDescriptionName(to name: String) {
        self.label.text = name
    }
    
    func hasFilter() -> Bool {
        let allTextFields = [fromTextField, toTextField]
        for textField in allTextFields {
            if !hasValidInput(textField!) {
                return false
            }
        }
        return true
    }
    
    func getTextFieldInputForURL() -> String {
        var currentURL = ""
        var finalURL = ""
        if hasFromInput() {
            currentURL = self.label.text!.lowercased() + "_gt="
            finalURL += "\(currentURL)\(fromTextField.text!)&"
        }
        if hasToInput() {
            currentURL = self.label.text!.lowercased() + "_lt="
            finalURL += "\(currentURL)\(toTextField.text!)&"
        }
        return finalURL
    }
    
    func clearFilter() {
        fromTextField.text = ""
        toTextField.text = ""
    }
}

//MARK: - TextFieldDelegate
extension BAFromToFilterView: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let currentTextField = textField as! BATextField
        if !hasValidInput(currentTextField) {
            HUD.flash(.label("Wrong input!"), delay: 0.7)
            return false
        }
        return true
    }
}


