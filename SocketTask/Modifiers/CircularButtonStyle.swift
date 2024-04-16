//
//  CircularButtonStyle.swift
//  SocketTask
//
//  Created by Tim Nazar on 4/16/24.
//

import SwiftUI

struct CircularButtonStyle: ButtonStyle {
    private let backgroundColor: Color
    
    init(backgroundColor: Color = .green) {
        self.backgroundColor = backgroundColor
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(32)
            .frame(minWidth: 140, minHeight: 140)
            .background(backgroundColor)
            .foregroundColor(.white)
            .clipShape(.circle)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)

    }
}
