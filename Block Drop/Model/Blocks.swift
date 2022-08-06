//
//  Blocks.swift
//  Block Drop
//
//  Created by Jack Elia on 8/6/22.
//

import Foundation
import SwiftUI

class BlockContainer: ObservableObject {
    
    @Published var blocks: [Block] = []
    let maxBlocks = 3

    /// Refills the blocks to max, starting at the front of the block array
    func refillBlocks() {
        for _ in blocks.count..<maxBlocks {
            let newBlock = Block(shape: [], image: Image("block-example"))
            blocks.insert(newBlock, at: 0)
        }
    }
    
    /// Rotates each block clockwise, 90 degrees
    func rotateBlocks() {}
    
    /// A struct representing each game piece used in the game
    struct Block: Identifiable {
        
        var id = UUID()
        /// 2D Array with 1 representing a block, 0 an empty tile
        var shape: [[Int]]
        /// The transparent image (png) that adheres to the shape of the block
        var image: Image
        
    }
    
}
