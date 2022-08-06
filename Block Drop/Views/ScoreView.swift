//
//  ScoreView.swift
//  Block Drop
//
//  Created by Jack Elia on 8/6/22.
//

import SwiftUI

struct ScoreView: View {
    var body: some View {
        HStack {
            Text("Title Goes Here")
            Spacer()
            Text("Score Goes here")
        }
        .padding(20)
        .background(.purple)
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView()
    }
}
