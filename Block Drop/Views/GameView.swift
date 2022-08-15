//
//  GameView.swift
//  Block Drop
//
//  Created by Jack Elia on 8/7/22.
//

import SwiftUI

struct GameView: View {
    
    @State var secondsLeft = 15
    @State var score = 0
    @State var gridTiles: [[GridTile]]
    @State var blocks = [Block]()
    @StateObject var block1 = Block(shape: blockShapes.randomElement()!, image: Image("block-example"))
    @StateObject var block2 = Block(shape: blockShapes.randomElement()!, image: Image("block-example"))
    @StateObject var block3 = Block(shape: blockShapes.randomElement()!, image: Image("block-example"))
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    let gridWidth = 9
    let gridHeight = 9
    let gridSubsectionSize = 3
    let maxBlocks = 3
    
    init() {
        gridTiles = [[GridTile]](repeating: [GridTile](repeating: GridTile(tileNumber: 0, tileFrame: .zero), count: gridHeight + 1), count: gridWidth + 1)
    }

    var body: some View {
        VStack(spacing: 0) {
            drawScoreView()
            drawGrid()
            makeBlockHolding()
        }
        .coordinateSpace(name: "gameViewCoordinateSpace")
        .onAppear {
            // Creates the 3 game blocks
            blocks = [block1, block2, block3]
            
            // Creates the invisible tiles on the border of the grid
            for row in 0..<gridTiles.count {
                gridTiles[row][0].tileNumber = -1
            }
            
            for col in 0..<gridTiles[0].count {
                gridTiles[0][col].tileNumber = -1
            }
        }
    }
    
    // MARK: The Score View
    /// Draws the score view each time it needs to be updated
    @ViewBuilder func drawScoreView() -> some View {
        HStack {
            Text("Time left: \(secondsLeft)")
                .onReceive(timer) { _ in
                    if secondsLeft > 0 {
                        secondsLeft -= 1
                    } else {
                        secondsLeft = 15
                    }
                }
            Spacer()
            Text("Score: \(score)")
        }
        .padding(20)
        .background(.purple)
    }
    
    // MARK: The Grid View
    /// Draws the grid each time it needs to be updated
    @ViewBuilder func drawGrid() -> some View {
        VStack(spacing: 0) {
            ForEach(0..<gridTiles.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<gridTiles[row].count, id: \.self) { col in
                        getCellImage(tileNumber: gridTiles[row][col].tileNumber)
                            .resizable()
                            .scaledToFit()
                            .overlay(GeometryReader { geometry in
                                getCellOverlayColor(row, col)
                                    .opacity(0.6)
                                    .onAppear {
                                        // Sets the value of the actual cell, not the copy of it
                                        gridTiles[row][col].tileFrame = geometry.frame(in: .named("gameViewCoordinateSpace"))
                                    }
                            }
                        )
                    }
                    // Adds in last column of tiles that do nothing except add more space
                    getCellImage(tileNumber: -1)
                        .resizable()
                        .scaledToFit()
                }
            }
            // Adds in the bottom row of blank tiles that do nothing except add more space
            HStack(spacing: 0) {
                ForEach(0..<gridTiles[0].count, id: \.self) { col in
                    getCellImage(tileNumber: -1)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
    }
    
    func getCellImage(tileNumber: Int) -> Image {
        switch tileNumber {
        case 0:
            return Image("redsquare")
        case 1:
            return Image("greensquare")
        case -1:
            // Returns an image that doesn't exist so it is blank
            return Image("nosquare")
        default:
            // This should not be called
            return Image("")
        }
    }
    
    func getCellOverlayColor(_ row: Int, _ col: Int) -> Color {
        var overlayColor = Color.clear
        if gridTiles[row][col].isBeingHovered {
            overlayColor = .white
            for block in blocks {
                // Makes the hover effect red if it cannot be placed
                if !block.fitsOnGrid && block.isPickedUp {
                    overlayColor = .red
                }
            }
        } else if gridTiles[row][col].tileNumber == 0 {
            // Makes the sub sections of the grid different colors
            if Int(floor(Double((row - 1) / gridSubsectionSize)) + Double(gridSubsectionSize) * floor(Double((col - 1) / gridSubsectionSize))) % 2 == 0 {
                overlayColor = .green
            }
        }
        return overlayColor
    }
    
    // MARK: The Block Hold View
    /// Makes the block holding area
    @ViewBuilder func makeBlockHolding() -> some View {
        HStack {
            // Makes the block images
            ForEach(0..<blocks.count, id: \.self) { i in
                let block = blocks[i]
                VStack(spacing: 0) {
                    ForEach(0..<block.shape.count, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<block.shape[row].count, id: \.self) { col in
                                // Draws each of the blocks from their shape
                                if block.shape[row][col] == 1{
                                    Image("greensquare")
                                        .resizable()
                                        .scaledToFit()
                                } else {
                                    Image("nosquare")
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                        }
                    }
                }
                .frame(width: 96, height: 96, alignment: .center)
                // Moves the block while it is being dragged
                .offset(block.offset)
                // Rotates the block when tapped
                .onTapGesture {
                    print("tap")
                    rotateBlock(block)
                }
                // Handles the logic behind block dragging and dropping
                .gesture(
                    DragGesture(minimumDistance: .zero, coordinateSpace: .named("gameViewCoordinateSpace"))
                        .onChanged { gesture in
                            block.offset = CGSize(width: gesture.translation.width - 40, height: gesture.translation.height - 40)
                            block.position = CGPoint(x: gesture.location.x - 120, y: gesture.location.y + 15)
                            block.isPickedUp = true
                            resetGridHover()
                            block.fitsOnGrid = checkIfBlockFitsOnGrid(block)
                        }
                        .onEnded { _ in
                            // Do stuff for dropping the block
                            block.offset = .zero
                            block.isPickedUp = false
                            if block.fitsOnGrid {
                                dropBlockOnGrid(block)
                                checkIfPlayerScored()
                                block.shape = blockShapes.randomElement()!
                            }
                            resetGridHover()
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

    func resetGridHover() {
        for row in 0..<gridTiles.count {
            for col in 0..<gridTiles[row].count {
                gridTiles[row][col].isBeingHovered = false
            }
        }
    }
    
    func clearGridTiles(tilesToClear: [(row: Int, col: Int)]) {
        for tile in tilesToClear {
            gridTiles[tile.row][tile.col].tileNumber = 0
        }
    }
    
    func checkIfBlockFitsOnGrid(_ block: Block) -> Bool {
        var blockFitsOnGrid = true
        // Loops through each tile on the grid
        for gridRow in 0..<gridTiles.count {
            for gridCol in 0..<gridTiles[gridRow].count {
                // Checks if the block is being dragged over the tile
                if gridTiles[gridRow][gridCol].tileFrame.contains(CGPoint(x: block.position.x + 48, y: block.position.y + 48)) {
                    let blockShape = block.shape
                    // Loops through each tile on the block
                    for blockRow in 0..<blockShape.count {
                        for blockCol in 0..<blockShape[blockRow].count {
                            let blockTile = blockShape[blockRow][blockCol]
                            // Only does checks if there is a filled tile
                            if blockTile != 0 {
                                // Checks to make sure the block tile is within the grid
                                if gridRow + blockRow < gridTiles.count && gridCol + blockCol < gridTiles[gridRow].count {
                                    // This is the grid tile it is currently checking
                                    if gridTiles[gridRow + blockRow][gridCol + blockCol].tileNumber != 0 {
                                        // Is false because something in the grid is in the way
                                        blockFitsOnGrid = false
                                    } else {
                                        gridTiles[gridRow + blockRow][gridCol + blockCol].isBeingHovered = true
                                    }
                                } else {
                                    // Is false because block doesn't fit within grid
                                    blockFitsOnGrid = false
                                }
                                
                            }
                        }
                    }
                    return blockFitsOnGrid
                }
            }
        }
        // Returns false because the block isn't even over the grid
        return false
    }
    
    // Hard coded to only work for a 3x3 block
    func rotateBlock(_ block: Block) {
        let blockShape = block.shape
        var rotatedBlockShape = block.shape
        rotatedBlockShape[0][0] = blockShape[2][0]
        rotatedBlockShape[0][1] = blockShape[1][0]
        rotatedBlockShape[0][2] = blockShape[0][0]
        rotatedBlockShape[1][2] = blockShape[0][1]
        rotatedBlockShape[2][2] = blockShape[0][2]
        rotatedBlockShape[2][1] = blockShape[1][2]
        rotatedBlockShape[2][0] = blockShape[2][2]
        rotatedBlockShape[1][0] = blockShape[2][1]
        block.shape = rotatedBlockShape
    }
    
    func dropBlockOnGrid(_ block: Block) {
        for row in 0..<gridTiles.count {
            for col in 0..<gridTiles[row].count {
                if gridTiles[row][col].isBeingHovered {
                    gridTiles[row][col].tileNumber = 1
                }
            }
        }
    }
    
    func checkIfPlayerScored() {
        /// The amount of points that will be added to the player's score
        var pointsScored = 0
        /// (row, col)  tuples that represent each of the grid tiles that should be cleared
        var tilesToClear = [(Int, Int)]()
        
        // Checks grid subsections
        for subsection in 0..<gridWidth * gridHeight / Int(pow(Double(gridSubsectionSize), 2)) {
            var subsectionTiles = [(Int, Int)]()
            // Starts assuming that the subsection is completely filled
            var subsectionFilled = true
            // Goes through tiles of subsection to check if they are filled
        outerLoop: for row in Int(floor(Double(subsection / (gridWidth / gridSubsectionSize)))) * gridSubsectionSize + 1...Int(floor(Double(subsection / (gridWidth / gridSubsectionSize)))) * gridSubsectionSize + gridSubsectionSize {
            for col in (subsection % (gridWidth / gridSubsectionSize)) * gridSubsectionSize + 1...(subsection % (gridWidth / gridSubsectionSize)) * gridSubsectionSize + gridSubsectionSize {
                    subsectionTiles.append((row: row, col: col))
                    // Checks if one of the tiles in the subsection is empty
                    if gridTiles[row][col].tileNumber == 0 {
                        subsectionFilled = false
                        // Stops checking if the subsection is filled because one of the tiles was empty
                        break outerLoop
                    }
                }
            }
            // Clears the tiles and gives the user points if the subsection is full
            if subsectionFilled {
                tilesToClear += subsectionTiles
                pointsScored *= 2
                pointsScored += 100
            }
        }
        
        // Checks grid rows
        for row in 1...gridHeight {
            var rowTiles = [(Int, Int)]()
            // Starts assuming the entire row is filled
            var rowFilled = true
            for col in 1...gridWidth {
                rowTiles.append((row: row, col: col))
                // Checks if one of the tiles in the row is empty
                if gridTiles[row][col].tileNumber == 0 {
                    rowFilled = false
                    // Stops checking if the row is filled because one of the tiles was empty
                    break
                }
            }
            // Clears the tiles and gives the user points if the row is full
            if rowFilled {
                tilesToClear += rowTiles
                pointsScored *= 2
                pointsScored += 100
            }
        }
        
        // Checks grid columns
        for col in 1...gridWidth {
            var colTiles = [(Int, Int)]()
            // Starts assuming the entire column is filled
            var colFilled = true
            for row in 1...gridHeight {
                colTiles.append((row: row, col: col))
                // Checks if one of the tiles in the column is empty
                if gridTiles[row][col].tileNumber == 0 {
                    colFilled = false
                    // Stops checking if the column is filled because one of the tiles was empty
                    break
                }
            }
            // Clears the tiles and gives the user points if the column is full
            if colFilled {
                tilesToClear += colTiles
                pointsScored *= 2
                pointsScored += 100
            }
        }
        
        score += pointsScored
        clearGridTiles(tilesToClear: tilesToClear)
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
