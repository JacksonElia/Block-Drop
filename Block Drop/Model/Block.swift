//
//  Block.swift
//  Block Drop
//
//  Created by Jack Elia on 8/7/22.
//

import Foundation
import SwiftUI

/// A class representing each game piece used in the game
class Block: ObservableObject {
    
    var id = UUID()
    /// 2D Array with 1 representing a block, 0 an empty tile
    @Published var shape: [[Int]]
    /// The transparent image (png) that adheres to the shape of the block
    @Published var image: Image
    /// The current x, y position relative to where the block starts
    @Published var offset = CGSize.zero
    /// The current x, y position relative to the screen
    @Published var position = CGPoint.zero
    /// true if the user is dragging the block
    var isPickedUp = false
    /// true if the block should be invisible
    var isSpent = false
    /// true if the block can be placed on the grid
    var fitsOnGrid = false
    /// A number representing the tile
    var tileType = Int.random(in: 2...4)
    
    init(shape: [[Int]], image: Image) {
        self.shape = shape
        self.image = image
    }
    
}

let blockShapes: [[[Int]]] = [
    [
        [0, 0, 0],
        [0, 1, 0],
        [0, 0, 0]
    ],
    [
        [0, 0, 0],
        [1, 1, 1],
        [0, 0, 0]
    ],
    [
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 0]
    ],
    [
        [0, 0, 1],
        [0, 1, 0],
        [1, 0, 0]
    ],
    [
        [0, 0, 0],
        [1, 1, 0],
        [0, 0, 0]
    ],
    [
        [0, 1, 0],
        [1, 1, 1],
        [0, 0, 0]
    ],
    [
        [0, 0, 1],
        [0, 0, 1],
        [1, 1, 1]
    ],
    [
        [0, 0, 1],
        [1, 1, 1],
        [0, 0, 0]
    ],
    [
        [1, 0, 0],
        [1, 1, 1],
        [0, 0, 0]
    ],
    [
        [0, 1, 1],
        [1, 1, 0],
        [0, 0, 0]
    ],
    [
        [1, 1, 0],
        [0, 1, 1],
        [0, 0, 0]
    ],
    [
        [1, 1, 0],
        [1, 1, 0],
        [0, 0, 0]
    ],
    [
        [1, 0, 0],
        [0, 1, 0],
        [0, 0, 0]
    ]
]

// This is used to show that the player "spent" the block
let emptyBlock = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0]
]
