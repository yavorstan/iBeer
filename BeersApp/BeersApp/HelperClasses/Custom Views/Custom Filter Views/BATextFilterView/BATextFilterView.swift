//
//  BATextFilterView.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 23.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BATextFilterView: UIView {
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var label: BALabel!
    @IBOutlet weak var textField: BATextField!
    
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
    func setup() {
        Bundle.main.loadNibNamed("BATextFilterView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

//MARK: - Filterable
extension BATextFilterView: Filterable {
    func setFilterDescriptionName(to name: String) {
        self.label.text = name
    }
    
    func hasFilter() -> Bool {
        return !textField.text!.isEmpty && textField.text != ""
    }
    
    func getTextFieldInputForURL() -> String {
        var currentURL = ""
        if hasFilter() {
            currentURL = self.label.text!.lowercased() + "="
            return "\(currentURL)\(textField.text!)&"
        }
        return currentURL
    }
    
    func clearFilter() {
        textField.text = ""
    }
}
