//
//  BALabel.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 6.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BALabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.textColor = UIColor.DefaultTextColor.color
        self.font = UIFont.defaultTitleFont.font
    }
}
