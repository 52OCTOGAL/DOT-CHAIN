//
//  CapsuleButtonStyle.swift
//  BilanGame2
//
//  Created by Awo-Bilan Dahir  on 12/06/2025.
//


import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
    var background: Color = .brandPrimary
    var foreground: Color = .white

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .foregroundColor(foreground)
            .background(Capsule().fill(background))
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
