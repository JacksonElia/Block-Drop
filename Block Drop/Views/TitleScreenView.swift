//
//  TitleScreenView.swift
//  Block Drop
//
//  Created by Jack Elia on 8/15/22.
//

import SwiftUI

struct TitleScreenView: View {
    
    @State var helpShowing = false
    @State var creditsShowing = false
    @Binding var isOnTitleScreen: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Play")
                .foregroundColor(.white)
                .onTapGesture {
                    isOnTitleScreen = false
                }
            Text("Help")
                .foregroundColor(.white)
                .onTapGesture {
                    helpShowing = true
                }
                .popover(isPresented: $helpShowing) {
                    
                }
            Text("Credits")
                .foregroundColor(.white).onTapGesture {
                    creditsShowing = true
                }
                .popover(isPresented: $creditsShowing) {
                    
                }
        }
        .font(.custom("DINCondensed-Bold", size: 60))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .background(Color(0x393939))
    }
}

struct TitleScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TitleScreenView(isOnTitleScreen: .constant(true))
    }
}
