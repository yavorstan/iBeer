//
//  BABackground.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 4.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

class BABackground: UIImageView {
    
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
        self.image = UIImage(named: "background")
        self.contentMode = .scaleAspectFill
        self.alpha = 0.9
    }
    
}
