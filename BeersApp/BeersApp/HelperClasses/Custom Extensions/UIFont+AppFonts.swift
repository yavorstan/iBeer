//
//  UIFont+AppFonts.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 10.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

extension UIFont {
    
    static let desctiptionFontSize = 16
    static let fontName = "Trebuchet MS"
    
    struct defaultTitleFont {
        static let font = UIFont(name: "Trebuchet MS", size: UIDevice.current.userInterfaceIdiom == .phone ? 19 : 24)!
    }
    
    struct defaultDescriptionFont {
        static let font = UIFont(name: "Trebuchet MS", size: UIDevice.current.userInterfaceIdiom == .phone ? 16 : 21)!
    }
    
    struct defaultInfoFont {
        static let font = UIFont(name: "Trebuchet MS", size: UIDevice.current.userInterfaceIdiom == .phone ? 13 : 17)!
    }
    
}
