//
//  SwiftUIBackgroundView.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 9.04.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct SwiftUIBackgroundView: View {
    var body: some View {
        Image("background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.vertical)
            .opacity(0.8)
            .scaleEffect(1)
    }
}

@available(iOS 13.0, *)
struct SwiftUIBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIBackgroundView()
    }
}
