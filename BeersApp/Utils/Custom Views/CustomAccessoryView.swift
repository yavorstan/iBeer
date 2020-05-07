//
//  CustomAccessoryView.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 1.04.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class CustomAccessoryView: UIView {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    var clearHandler: (() -> ())?
    var doneHandler: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doneButton.setTitle(NSLocalizedString("btn_done", comment: ""), for: .normal)
        clearButton.setTitle(NSLocalizedString("btn_clear", comment: ""), for: .normal)
        self.tintColor = UIColor.DefaultTextColor.color
        self.backgroundColor = UIColor.DefaultAppColor.color
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        if let callback = self.doneHandler {
            callback()
        }
    }
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        if let callback = self.clearHandler {
            callback()
        }
    }
}
