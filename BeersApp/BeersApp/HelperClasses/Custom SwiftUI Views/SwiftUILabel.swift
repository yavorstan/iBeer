//
//  SwiftUILabel.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 9.04.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct SwiftUILabel: View {
    
    let text: String
    let font: Font
    
    var body: some View {
        Text(text)
            .foregroundColor(Color(UIColor.DefaultTextColor.color!))
            .font(font)
            .bold()
    }
}

@available(iOS 13.0, *)
struct SwiftUILabel_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUILabel(text: "text", font: Font(UIFont.defaultTitleFont.font))
    }
}
