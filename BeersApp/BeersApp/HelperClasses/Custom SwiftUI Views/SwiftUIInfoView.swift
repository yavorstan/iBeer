//
//  InfoView.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 9.04.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct SwiftUIInfoView: View {
    
    let text: String
    let imageName: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .frame(width: 350, height: 50, alignment: .center)
            .foregroundColor(Color(UIColor.DefaultFiltersViewColor.color!))
            .overlay(
                HStack{
                    Image(systemName: imageName)
                        .foregroundColor(Color(UIColor.DefaultTextColor.color!))
                        .frame(width: CGFloat(25), height: CGFloat(25), alignment: .center)
                    Text(text)
                        .font(.system(size: 15))
                }
        )
            .padding(.all)
    }
}

@available(iOS 13.0, *)
struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIInfoView(text: "*text*", imageName: "phone.fill")
            .previewLayout(.sizeThatFits)
    }
}
