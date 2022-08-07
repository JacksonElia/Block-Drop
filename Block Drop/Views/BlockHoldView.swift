//
//  BlockHoldView.swift
//  Block Drop
//
//  Created by Jack Elia on 8/6/22.
//

import SwiftUI

struct BlockHoldView: View {
        
    @State var blocks = [Block]()
    @StateObject var block1 = Block(shape: [], image: Image("block-example"))
    @StateObject var block2 = Block(shape: [], image: Image("block-example"))
    @StateObject var block3 = Block(shape: [], image: Image("block-example"))
    
    var body: some View {
        HStack {
            ForEach(0..<blocks.count, id: \.self) { i in
                let block = blocks[i]
                block.image
                    .resizable()
                    .frame(width: 96, height: 96, alignment: .center)
                    .offset(block.offset)
                    // Sets the offset to where the user drags the block
                    .gesture(
                        DragGesture(minimumDistance: .zero, coordinateSpace: .named("blockHold"))
                            .onChanged { gesture in
                                block.offset = gesture.translation
                                block.position = gesture.location
                                print(block.position)
                            }
                        
                            .onEnded { _ in
                                // Do stuff for dropping the block
                                block.offset = .zero
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
            blocks = [block1, block2, block3]
        }
        .coordinateSpace(name: "blockHold")
    }
    
    let maxBlocks = 3
    
    /// A class representing each game piece used in the game
    class Block: ObservableObject {
        
        var id = UUID()
        /// 2D Array with 1 representing a block, 0 an empty tile
        var shape: [[Int]]
        /// The transparent image (png) that adheres to the shape of the block
        @Published var image: Image
        /// The current x, y position relative to where the block starts
        @Published var offset = CGSize.zero
        /// The current x, y position relative to the screen
        @Published var position = CGPoint.zero  // TODO: Make this where the block actually starts
        
        init(shape: [[Int]], image: Image) {
            self.shape = shape
            self.image = image
        }
        
    }
}

struct BlockHoldView_Previews: PreviewProvider {
    static var previews: some View {
        BlockHoldView()
    }
}
