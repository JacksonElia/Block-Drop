//
//  TitleScreenView.swift
//  Block Drop
//
//  Created by Jack Elia on 8/15/22.
//

import SwiftUI

struct TitleScreenView: View {
    
    @Binding var isOnTitleScreen: Bool
    
    var body: some View {
        VStack {
            Text("Play")
                .onTapGesture {
                    isOnTitleScreen = false
                }
        }
    }
}

struct TitleScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TitleScreenView(isOnTitleScreen: .constant(true))
    }
}
