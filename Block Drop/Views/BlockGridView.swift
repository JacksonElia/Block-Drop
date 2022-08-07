//
//  BlockGridView.swift
//  Block Drop
//
//  Created by Jack Elia on 8/6/22.
//

import SwiftUI

struct BlockGridView: View {
    
    let gridWidth = 9
    let gridHeight = 9
    
    @State var grid: [[Int]]
    
    init() {
        // Creates the grid at the specified size
        grid = [[Int]](repeating: [Int](repeating: 0, count: gridHeight), count: gridWidth)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            drawGrid()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(10)
        .background(.blue)
    }
    
    /// Draws the grid each time it needs to be updated
    @ViewBuilder func drawGrid() -> some View {
        ForEach(0..<grid.count, id: \.self) { row in
            HStack(spacing: 0) {
                ForEach(0..<grid[row].count, id: \.self) { col in
                    let cell = grid[row][col]
                    if cell == 0 {
                        Image("redsquare")
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image("greensquare")
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
        }
    }
    
}

struct BlockGridView_Previews: PreviewProvider {
    static var previews: some View {
        BlockGridView()
    }
}
