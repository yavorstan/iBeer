//
//  BADateFilterView.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 23.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BADateFilterView: UIView {
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var label: BALabel!
    @IBOutlet weak var textField: BATextField!
    
    @IBOutlet weak var brewedLabel: BALabel!
    
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
    func setup() { Bundle.main.loadNibNamed("BADateFilterView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textField.font = UIFont.defaultDescriptionFont.font
        brewedLabel.text = NSLocalizedString("brewed", comment: "")
    }
    
    //MARK: Tap Actions
    @IBAction func datePicker(_ sender: UITextField) {
        let datePicker = MonthYearPickerView()
        let date = Date()
        if textField.text == "" {
            let currentMonth = Calendar.current.component(.month, from: date)
            let currentYear = Calendar.current.component(.year, from: date)
            let formattedDate = String(format: "%02d-%d", currentMonth, currentYear)
            self.textField.text = formattedDate
        }
        datePicker.onDateSelected = { (month: Int, year: Int) in
            var formattedDate = String(format: "%02d-%d", month, year)
            formattedDate = String(format: "%02d-%d", month, year)
            self.textField.text = formattedDate
        }
        sender.inputView = datePicker
    }
}

//MARK: - Filterable
extension BADateFilterView: Filterable {
    func setFilterDescriptionName(to name: String) {
        self.label.text = name
    }
    
    func hasFilter() -> Bool {
        return !textField.text!.isEmpty && textField.text != ""
    }
    
    func getTextFieldInputForURL() -> String {
        var currentURL = ""
        if hasFilter() {
            currentURL = "brewed_" + self.label.text!.lowercased() + "="
            return "\(currentURL)\(textField.text!)&"
        }
        return currentURL
    }
    
    func clearFilter() {
        textField.text = ""
    }
}
