//
//  BlockGridView.swift
//  Block Drop
//
//  Created by Jack Elia on 8/6/22.
//

import SwiftUI

struct BlockGridView: View {
    var body: some View {
        VStack {
            Text("Game Grid Goes Here")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
    }
}

struct BlockGridView_Previews: PreviewProvider {
    static var previews: some View {
        BlockGridView()
    }
}
