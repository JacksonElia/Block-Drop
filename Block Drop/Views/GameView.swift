//
//  GameView.swift
//  Block Drop
//
//  Created by Jack Elia on 8/7/22.
//

import SwiftUI

struct GameView: View {
    
    @State var grid: [[Int]]
    @State var blocks = [Block]()
    @StateObject var block1 = Block(shape: [], image: Image("block-example"))
    @StateObject var block2 = Block(shape: [], image: Image("block-example"))
    @StateObject var block3 = Block(shape: [], image: Image("block-example"))
    
    let gridWidth = 9
    let gridHeight = 9
    let maxBlocks = 3
    
    private let gameCoordinateSpaceName = "gameCoordinateSpace"
    
    init() {
        // Creates the grid at the specified size
        grid = [[Int]](repeating: [Int](repeating: 0, count: gridHeight), count: gridWidth)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            drawGrid()
            makeBlockHolding()
        }
        .coordinateSpace(name: gameCoordinateSpaceName)
        .onAppear {
            blocks = [block1, block2, block3]
        }
    }
    
    // MARK: The Grid View
    /// Draws the grid each time it needs to be updated
    @ViewBuilder func drawGrid() -> some View {
        VStack(spacing: 0) {
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(10)
        .background(.blue)
    }
    
    // MARK: The Block Hold View
    /// Makes the block holding area
    @ViewBuilder func makeBlockHolding() -> some View {
        HStack {
            ForEach(0..<blocks.count, id: \.self) { i in
                let block = blocks[i]
                block.image
                    .resizable()
                    .frame(width: 96, height: 96, alignment: .center)
                    .offset(block.offset)
                    // Sets the offset to where the user drags the block
                    .gesture(
                        DragGesture(minimumDistance: .zero, coordinateSpace: .named(gameCoordinateSpaceName))
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
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
