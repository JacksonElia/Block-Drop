//
//  TitleScreenView.swift
//  Block Drop
//
//  Created by Jack Elia on 8/15/22.
//

import SwiftUI

struct TitleScreenView: View {
    
    @Binding var isOnTitleScreen: Bool
    @Binding var gamemode: Int
    @State var gamemodesShowing = false
    @State var helpShowing = false
    @State var creditsShowing = false
    
    var body: some View {
        VStack {
            Image("block_drop_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding([.leading, .trailing], 10)
                .padding([.bottom], -30)
            Spacer()
            VStack {
                Image("start_up_button_\(getRandomButtonImageNumber()).play")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(10)
                    .onTapGesture {
                        gamemodesShowing = true
                    }
                    .popover(isPresented: $gamemodesShowing) {
                        VStack {
                            Text("Gamemodes")
                            Spacer()
                            VStack {
                                Image("menu_button_1.normal")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(10)
                                    .onTapGesture {
                                        isOnTitleScreen = false
                                        gamemode = 0
                                    }
                                Image("menu_button_1.increment")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(10)
                                    .onTapGesture {
                                        isOnTitleScreen = false
                                        gamemode = 1
                                    }
                                Image("menu_button_1.match")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(10)
                                    .onTapGesture {
                                        isOnTitleScreen = false
                                        gamemode = 2
                                    }
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(30)
                        .background(Color(0x393939))
                        .onTapGesture {
                            gamemodesShowing = false
                        }
                    }
                Spacer()
                Image("start_up_button_\(getRandomButtonImageNumber()).help")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(10)
                    .onTapGesture {
                        helpShowing = true
                    }
                    .popover(isPresented: $helpShowing) {
                        VStack {
                            Text("Help")
                            Spacer()
                            VStack(alignment: .leading, spacing: 30) {
                                Text("The goal of this game is to keep playing for as long as you can and to get as many points as possible.")
                                Text("1. Place a block by dragging and dropping it onto the board.")
                                Text("2. Keep an eye on the timer in the top left corner. If it hits 0, you lose. You can extend the time by placing a block.")
                                Text("3. You get points and clear space when you fill a row, column, or subsection of the board up with blocks.")
                            }
                            .font(.custom("DINCondensed-Bold", size: 30))
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(30)
                        .background(Color(0x393939))
                        .onTapGesture {
                            helpShowing = false
                        }
                    }
                Spacer()
                Image("start_up_button_\(getRandomButtonImageNumber()).credits")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(10)
                    .onTapGesture {
                        creditsShowing = true
                    }
                    .popover(isPresented: $creditsShowing) {
                        VStack {
                            Text("Credits")
                            Spacer()
                            VStack(alignment: .leading, spacing: 30) {
                                Text("This game is dedicated to our mother. I made it as a gift to her and so I could learn more about app development with SwiftUI.")
                                Text("Programming done by me. Check out my [website](https://traptricker.github.io/)!")
                                    .onTapGesture {
                                        UIApplication.shared.open(URL(string: "https://traptricker.github.io/")!, options: [:])
                                        
                                    }
                                Text("Art done by my sibling.")
                            }
                            .font(.custom("DINCondensed-Bold", size: 30))
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(30)
                        .background(Color(0x393939))
                        .onTapGesture {
                            creditsShowing = false
                        }
                    }
                Spacer()
            }
        }
        .font(.custom("DINCondensed-Bold", size: 60))
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .background(Color(0x393939))
    }
    
    func getRandomButtonImageNumber() -> Int {
        return Int.random(in: 1...4)
    }
    
}

struct TitleScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TitleScreenView(isOnTitleScreen: .constant(true), gamemode: .constant(0))
    }
}
