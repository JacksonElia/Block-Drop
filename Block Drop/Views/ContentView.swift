//
//  ContentView.swift
//  Block Drop
//
//  Created by Jack Elia on 8/5/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack (spacing: 0) {
            ScoreView()
            BlockGridView()
            BlockHoldView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
