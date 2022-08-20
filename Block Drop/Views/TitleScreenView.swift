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
        VStack {
            Image("block_drop_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding([.leading, .trailing], 10)
                .padding([.bottom], -50)
            Spacer()
            Text("Play")
                .foregroundColor(.white)
                .onTapGesture {
                    isOnTitleScreen = false
                }
            Spacer()
            Text("Help")
                .foregroundColor(.white)
                .onTapGesture {
                    helpShowing = true
                }
                .popover(isPresented: $helpShowing) {
                    
                }
            Spacer()
            Text("Credits")
                .foregroundColor(.white).onTapGesture {
                    creditsShowing = true
                }
                .popover(isPresented: $creditsShowing) {
                    
                }
            Spacer()
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
