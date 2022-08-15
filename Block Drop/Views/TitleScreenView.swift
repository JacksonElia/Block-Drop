//
//  TitleScreenView.swift
//  Block Drop
//
//  Created by Jack Elia on 8/15/22.
//

import SwiftUI

struct TitleScreenView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: GameView()) {
                    Text("Play")
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct TitleScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TitleScreenView()
    }
}
