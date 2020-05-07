//
//  NSMutableAttributedString+Bold.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 27.03.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    var fontSize:CGFloat { return CGFloat(UIFont.desctiptionFontSize) }
    var boldFont:UIFont { return UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: UIFont.fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    static func + (left: NSMutableAttributedString, right: NSMutableAttributedString) -> NSMutableAttributedString{
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
