//
//  GameView.swift
//  Block Drop
//
//  Created by Jack Elia on 8/7/22.
//

import SwiftUI

struct GameView: View {
    
    @State var gridTiles: [[GridTile]]
    @State var blocks = [Block]()
    @StateObject var block1 = Block(shape: [], image: Image("block-example"))
    @StateObject var block2 = Block(shape: [], image: Image("block-example"))
    @StateObject var block3 = Block(shape: [], image: Image("block-example"))
    
    let gridWidth = 9
    let gridHeight = 9
    let maxBlocks = 3
        
    init() {
        // Creates the grid at the specified size
        gridTiles = [[GridTile]](repeating: [GridTile](repeating: GridTile(tileNumber: 0, tileFrame: .zero), count: gridHeight), count: gridWidth)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            drawGrid()
            makeBlockHolding()
        }
        .onAppear {
            blocks = [block1, block2, block3]
        }
    }
    
    // MARK: The Grid View
    /// Draws the grid each time it needs to be updated
    @ViewBuilder func drawGrid() -> some View {
        VStack(spacing: 0) {
            ForEach(0..<gridTiles.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<gridTiles[row].count, id: \.self) { col in
                        var cell = gridTiles[row][col]
                        getCellImage(cell: cell.tileNumber)
                            .resizable()
                            .scaledToFit()
                            .overlay(GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        cell.tileFrame = geometry.frame(in: .global)
                                        gridTiles[row][col] = cell
                                    }
                            }
                        )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(10)
        .background(.blue)
    }
    
    func getCellImage(cell: Int) -> Image {
        switch cell {
        case 0:
            return Image("redsquare")
        case 1:
            return Image("greensquare")
            
        default:
            // This should not be called
            return Image("")
        }
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
                // Moves the block while it is being dragged
                    .offset(block.offset)
                // Sets the offset to where the user drags the block
                    .gesture(
                        DragGesture(minimumDistance: .zero, coordinateSpace: .global)
                            .onChanged { gesture in
                                block.offset = CGSize(width: gesture.translation.width, height: gesture.translation.height - 70)
                                block.position = CGPoint(x: gesture.location.x, y: gesture.location.y)
                                block.isPickedUp = true
                                print(block.position)
                                for row in 0..<gridTiles.count {
                                    for col in 0..<gridTiles[row].count {
                                        var cell = gridTiles[row][col]
                                        if cell.tileFrame.contains(block.position) {
                                            cell.tileNumber = 1
                                        } else {
                                            cell.tileNumber = 0
                                        }
                                        gridTiles[row][col] = cell
                                    }
                                }
                            }
                            .onEnded { _ in
                                // Do stuff for dropping the block
                                block.offset = .zero
                                block.isPickedUp = false
                            }
                    )
                if i < blocks.count - 1 { // Makes spacers after every block but the last
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
