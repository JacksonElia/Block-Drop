//
//  ContentView.swift
//  Block Drop
//
//  Created by Jack Elia on 8/5/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var isOnTitleScreen = true
    
    var body: some View {
        if isOnTitleScreen {
            TitleScreenView(isOnTitleScreen: $isOnTitleScreen)
        } else {
            GameView(isOnTitleScreen: $isOnTitleScreen)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}
