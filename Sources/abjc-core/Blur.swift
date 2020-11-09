//
//  Blur.swift
//  
//
//  Created by Noah Kamara on 09.11.20.
//

import SwiftUI

public struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .prominent
    
    public init(_ style: UIBlurEffect.Style = .prominent) {
        self.style = style
    }
    public func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct Blur_Previews: PreviewProvider {
    static var previews: some View {
        Blur()
    }
}
