//
//  IntegratedBABackground.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 10.04.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct IntegratedBABackground: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<IntegratedBABackground>) -> BABackground {
        return BABackground(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    func updateUIView(_ uiView: BABackground, context: UIViewRepresentableContext<IntegratedBABackground>) {
        
    }
    
    
}

@available(iOS 13.0, *)
struct IntegratedBABackground_Previews: PreviewProvider {
    static var previews: some View {
        IntegratedBABackground()
    }
}
