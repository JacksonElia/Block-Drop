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
    
    private var grid: [[Int]]
    
    init() {
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
    
    @ViewBuilder func drawGrid() -> some View {
        ForEach(grid, id: \.self) { row in
            HStack(spacing: 0) {
                ForEach(row, id: \.self) { column in
                    Image("redsquare")
                        .resizable()
                        .scaledToFit()
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
