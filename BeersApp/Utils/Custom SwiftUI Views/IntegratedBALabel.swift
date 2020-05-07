//
//  IntegratedBALabel.swift
//  BeersApp
//
//  Created by Yavor Stanoev on 10.04.20.
//  Copyright © 2020 Yavor Stanoev. All rights reserved.
//

import SwiftUI

struct IntegratedBALabel: UIViewRepresentable {
    
    var text: String
    
    class Coordinator: NSObject {
        var parent: IntegratedBALabel
        init(parent: IntegratedBALabel) {
            self.parent = parent
        }
        
        @objc func setText(text: String) {
            self.parent.text = text
        }
    }
    
    func makeCoordinator() -> IntegratedBALabel.Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> BALabel {
        let label = BALabel(frame: .zero)
        label.text = text
        return label
    }

    func updateUIView(_ uiView: BALabel, context: Context) {
        uiView.text = text
    }
    
}
