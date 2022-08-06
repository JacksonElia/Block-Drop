//
//  BlockHoldView.swift
//  Block Drop
//
//  Created by Jack Elia on 8/6/22.
//

import SwiftUI

struct BlockHoldView: View {
    
    @ObservedObject var blockContainer = BlockContainer()
    
    var body: some View {
        HStack {
            ForEach(0..<blockContainer.blocks.count, id: \.self) { i in
                let block = blockContainer.blocks[i]
                block.image
                    .resizable()
                    .frame(width: 96, height: 96, alignment: .center)
                if i < blockContainer.blocks.count - 1 { // Spacers after everything but the last
                    Spacer()
                }
            }
        }
        .padding(20)
        .background(.green)
        .onAppear {
            blockContainer.refillBlocks()
            print("refill")
        }
    }
}

struct BlockHoldView_Previews: PreviewProvider {
    static var previews: some View {
        BlockHoldView()
    }
}
