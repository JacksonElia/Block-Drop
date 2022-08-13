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
    var shape: [[Int]]
    /// The transparent image (png) that adheres to the shape of the block
    @Published var image: Image
    /// The current x, y position relative to where the block starts
    @Published var offset = CGSize.zero
    /// The current x, y position relative to the screen
    @Published var position = CGPoint.zero
    /// true if the user is dragging the block
    var isPickedUp = false
    /// true if the block can be placed on the grid
    var fitsOnGrid = false
    
    init(shape: [[Int]], image: Image) {
        self.shape = shape
        self.image = image
    }
    
}
