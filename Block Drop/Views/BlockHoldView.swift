//
//  BlockHoldView.swift
//  Block Drop
//
//  Created by Jack Elia on 8/6/22.
//

import SwiftUI

struct BlockHoldView: View {
        
    @State var blocks = [Block]()
    @State var selectedBlockOffset = CGSize.zero
    
    var body: some View {
        HStack {
            ForEach(0..<blocks.count, id: \.self) { i in
                var block = blocks[i]
                block.image
                    .resizable()
                    .frame(width: 96, height: 96, alignment: .center)
                    .offset(selectedBlockOffset)
                    // Sets the offset to where the user drags the block
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                block.offset = gesture.translation
                                selectedBlockOffset = gesture.translation
                                print(selectedBlockOffset)
                            }
                        
                            .onEnded { _ in
                                // Do stuff for dropping the block
                            }
                    )
                if i < blocks.count - 1 { // Spacers after everything but the last
                    Spacer()
                }
            }
        }
        .padding(20)
        .background(.green)
        .onAppear {
            self.refillBlocks()
        }
    }
    
    let maxBlocks = 3
    
    /// Refills the blocks to max, starting at the front of the block array
    func refillBlocks() {
        for _ in blocks.count..<maxBlocks {
            let newBlock = Block(shape: [], image: Image("block-example"), offset: .zero)
            blocks.insert(newBlock, at: 0)
        }
    }
    
    /// A struct representing each game piece used in the game
    struct Block: Identifiable {
        
        var id = UUID()
        /// 2D Array with 1 representing a block, 0 an empty tile
        var shape: [[Int]]
        /// The transparent image (png) that adheres to the shape of the block
        var image: Image
        /// The current x, y position on the screen relative to where the block starts
        var offset: CGSize
        
    }
}

struct BlockHoldView_Previews: PreviewProvider {
    static var previews: some View {
        BlockHoldView()
    }
}
