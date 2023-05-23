//
//  GameView.swift
//  Block Drop
//
//  Created by Jack Elia on 8/7/22.
//

import SwiftUI

struct GameView: View {
    
    @Binding var isOnTitleScreen: Bool
    @Binding var gamemode: Gamemode
    @State var secondsLeft = 10
    @State var isDead = false
    @State var isPaused = false
    @State var score = 0
    @State var gridTiles: [[GridTile]]
    @State var blocks = [Block]()
    @State var blockPixelSize = CGSize.zero
    @StateObject var block1 = Block(shape: blockShapes.randomElement()!, image: Image("block-example"))
    @StateObject var block2 = Block(shape: blockShapes.randomElement()!, image: Image("block-example"))
    @StateObject var block3 = Block(shape: blockShapes.randomElement()!, image: Image("block-example"))
    
    @Environment(\.sizeCategory) var sizeCategory
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let gridWidth = 9
    let gridHeight = 9
    let gridSubsectionSize = 3
    let maxBlocks = 3
    
    init(isOnTitleScreen: Binding<Bool>, gamemode: Binding<Gamemode>) {
        _isOnTitleScreen = isOnTitleScreen
        _gamemode = gamemode
        _gridTiles = State(initialValue: [[GridTile]](repeating: [GridTile](repeating: GridTile(tileNumber: 0, tileFrame: .zero), count: gridHeight + 1), count: gridWidth + 1))
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                drawScoreView()
                drawGrid()
                makeBlockHolding()
            }
            // Block images are on a different z index as to not affect the layout of the app
            makeBlockDragImages()
        }
        .font(.custom(K.UIConstants.mainFont, size: 22))
        .onAppear {
            // Creates the 3 game blocks, it doesn't save the blocks because who would ever know
            blocks = [block1, block2, block3]
            
            let userDefaults = UserDefaults.standard
            if gamemode == .normal {
                if let gridTilesData = userDefaults.data(forKey: K.UserDefaultsKeys.gridNormal) {
                    do {
                        let decoder = JSONDecoder()
                        // Loads the saved grid data, assumes that if grid was successfully decoded, other data has been saved
                        gridTiles = try decoder.decode([[GridTile]].self, from: gridTilesData)
                        score = userDefaults.value(forKey: K.UserDefaultsKeys.scoreNormal) as! Int
                        secondsLeft = userDefaults.value(forKey: K.UserDefaultsKeys.secondsLeftNormal) as! Int
                    } catch {
                        print(error)
                    }
                }
            } else if gamemode == .increment {
                if let gridTilesData = userDefaults.data(forKey: K.UserDefaultsKeys.gridIncrement) {
                    do {
                        let decoder = JSONDecoder()
                        // Loads the saved grid data
                        gridTiles = try decoder.decode([[GridTile]].self, from: gridTilesData)
                        score = userDefaults.value(forKey: K.UserDefaultsKeys.scoreIncrement) as! Int
                        secondsLeft = userDefaults.value(forKey: K.UserDefaultsKeys.secondsLeftIncrement) as! Int
                    } catch {
                        print(error)
                    }
                }
            } else if gamemode == .match {
                if let gridTilesData = userDefaults.data(forKey: K.UserDefaultsKeys.gridMatch) {
                    do {
                        let decoder = JSONDecoder()
                        // Loads the saved grid data
                        gridTiles = try decoder.decode([[GridTile]].self, from: gridTilesData)
                        score = userDefaults.value(forKey: K.UserDefaultsKeys.scoreMatch) as! Int
                        secondsLeft = userDefaults.value(forKey: K.UserDefaultsKeys.secondsLeftMatch) as! Int
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .coordinateSpace(name: K.UIConstants.gameViewCoordinateSpaceName)
        // This is for the pause screen
        .popover(isPresented: $isPaused) {
            VStack(alignment: .center, spacing: 30) {
                Spacer()
                Text("Paused").font(.custom(K.UIConstants.mainFont, fixedSize: 90))
                Text("Score: \(score)").foregroundColor(Color(UIColor.lightGray))
                Spacer()
                Text("Resume")
                    .onTapGesture {
                        isPaused = false
                    }
                Text("Quit")
                    .onTapGesture {
                        isPaused = false
                        resetGame()
                        saveGame()
                        // Kicks user back to title screen
                        isOnTitleScreen = true
                    }
                Spacer()
            }
            .font(.custom(K.UIConstants.mainFont, fixedSize: 60))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(30)
            .foregroundColor(.white)
            .background(Color(0x393939))
            .interactiveDismissDisabled()
        }
        // This is for the game over screen
        .popover(isPresented: $isDead) {
            VStack(alignment: .center, spacing: 30) {
                Spacer()
                Text("Game Over").font(.custom(K.UIConstants.mainFont, fixedSize: 90))
                Text("Score: \(score)").foregroundColor(Color(UIColor.lightGray))
                Spacer()
                Text("Try Again")
                    .onTapGesture {
                        secondsLeft = 10
                        score = 0
                        isDead = false
                        resetGame()
                        saveGame()
                    }
                Text("Quit")
                    .onTapGesture {
                        isDead = false
                        resetGame()
                        saveGame()
                        // Kicks user back to title screen
                        isOnTitleScreen = true
                    }
                Spacer()
            }
            .font(.custom(K.UIConstants.mainFont, fixedSize: 60))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(30)
            .foregroundColor(.white)
            .background(Color(0x393939))
            .interactiveDismissDisabled()
        }
    }
    
    // MARK: The Score View
    /// Draws the score view each time it needs to be updated
    @ViewBuilder func drawScoreView() -> some View {
        HStack(alignment: .center) {
            Image(systemName: "pause")
                .padding([.trailing], 15)
                .alignmentGuide(.firstTextBaseline) { context in
                    context[.bottom] - 0.14 * context.height
                }
                .onTapGesture {
                    isPaused = true
                }
            if sizeCategory > ContentSizeCategory.large {
                Text("\(secondsLeft)")
                    .onReceive(timer) { _ in
                        if secondsLeft > 0 {
                            if !isPaused {
                                secondsLeft -= 1
                            }
                        } else {
                            // Brings up Game Over screen
                            isDead = true
                        }
                    }
                Spacer()
                Image("block_drop_icon_transparent")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
                VStack(alignment: .leading) {
                    Text("S: \(score)")
                    Text("HS: \(getHighScore())")
                }
            } else {
                Text("Seconds\nleft: \(secondsLeft)")
                    .onReceive(timer) { _ in
                        if secondsLeft > 0 {
                            if !isPaused {
                                secondsLeft -= 1
                            }
                        } else {
                            // Brings up Game Over screen
                            isDead = true
                        }
                    }
                Spacer()
                Image("block_drop_icon_transparent")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding([.leading, .trailing], 10)
                Spacer()
                VStack(alignment: .leading) {
                    Text("Score: \(score)")
                    Text("High Score: \(getHighScore())")
                }
            }
        }
        .foregroundColor(.white)
        .padding(23)
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height / 7, alignment: .center)
        .background(Color(0x393939))
    }
    
    func getHighScore() -> Int {
        // The object used for saving data locally
        let userDefaults = UserDefaults.standard
        if gamemode == .normal {
            if let highScore = userDefaults.value(forKey: K.UserDefaultsKeys.highScoreNormal) { // Returns the integer value associated with the specified key.
                if score > highScore as! Int {
                    userDefaults.set(score, forKey: K.UserDefaultsKeys.highScoreNormal)
                }
                
                return highScore as! Int
            } else {
                // no Highscore exists
                userDefaults.set(0, forKey: K.UserDefaultsKeys.highScoreNormal)
            }
        } else if gamemode == .increment {
            if let highScore = userDefaults.value(forKey: K.UserDefaultsKeys.highScoreIncrement) {
                if score > highScore as! Int {
                    userDefaults.set(score, forKey: K.UserDefaultsKeys.highScoreIncrement)
                }
                
                return highScore as! Int
            } else {
                // no Highscore exists
                userDefaults.set(0, forKey: K.UserDefaultsKeys.highScoreIncrement)
            }
        } else if gamemode == .match {
            if let highScore = userDefaults.value(forKey: K.UserDefaultsKeys.highScoreMatch) {
                if score > highScore as! Int {
                    userDefaults.set(score, forKey: K.UserDefaultsKeys.highScoreMatch)
                }
                
                return highScore as! Int
            } else {
                // no Highscore exists
                userDefaults.set(0, forKey: K.UserDefaultsKeys.highScoreMatch)
            }
        }
        
        return 0
    }
    
    func saveGame() {
        let userDefaults = UserDefaults.standard
        do {
            let encoder = JSONEncoder()
            var gridTilesData: Data
            // Turns the custom objects into JSON
            gridTilesData = try encoder.encode(gridTiles)
            
            if gamemode == .normal {
                userDefaults.set(score, forKey: K.UserDefaultsKeys.scoreNormal)
                userDefaults.set(secondsLeft, forKey: K.UserDefaultsKeys.secondsLeftNormal)
                userDefaults.set(gridTilesData, forKey: K.UserDefaultsKeys.gridNormal)
            } else if gamemode == .increment {
                userDefaults.set(score, forKey: K.UserDefaultsKeys.scoreIncrement)
                userDefaults.set(secondsLeft, forKey: K.UserDefaultsKeys.secondsLeftIncrement)
                userDefaults.set(gridTilesData, forKey: K.UserDefaultsKeys.gridIncrement)
            } else if gamemode == .match {
                userDefaults.set(score, forKey: K.UserDefaultsKeys.scoreMatch)
                userDefaults.set(secondsLeft, forKey: K.UserDefaultsKeys.secondsLeftMatch)
                userDefaults.set(gridTilesData, forKey: K.UserDefaultsKeys.gridMatch)
            }
        } catch {
            print(error)
        }
    }
    
    func resetGame() {
        secondsLeft = 10
        score = 0
        resetWholeGrid()
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
                                        gridTiles[row][col].tileFrame = geometry.frame(in: .named(K.UIConstants.gameViewCoordinateSpaceName))
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
        .background(Color(0x1C1C1C))
    }
    
    func getCellImage(tileNumber: Int) -> Image {
        switch tileNumber {
        case 0:
            return Image("blockslot")
        case 1:
            return Image("block1")
        case 2:
            return Image("block2")
        case 3:
            return Image("block3")
        case 4:
            return Image("block4")
        case 5:
            return Image("block5")
        case 6:
            return Image("block6")
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
        } else if gridTiles[row][col].isExtraPoints {
            overlayColor = .cyan
        } else if gridTiles[row][col].tileNumber == 0 {
            // Makes the sub sections of the grid different colors
            if Int(floor(Double((row - 1) / gridSubsectionSize)) + Double(gridSubsectionSize) * floor(Double((col - 1) / gridSubsectionSize))) % 2 != 0 {
                overlayColor = Color(0x393939)
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
                                if block.shape[row][col] == 1 {
                                    getBlockImage(tileNumber: block.tileType)
                                        .resizable()
                                        .scaledToFit()
                                } else {
                                    getBlockImage(tileNumber: 0)
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                        }
                    }
                }
                .padding([.leading, .trailing], 5)
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height / 7, alignment: .center)
                .background {
                    // Gets the pixel size of the block
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                blockPixelSize = geometry.size
                            }
                    }
                }
                .opacity(block.isPickedUp ? 0 : 1)
                // Rotates the block when tapped
                .onTapGesture {
                    rotateBlock(block)
                }
                // Handles the logic behind block dragging and dropping
                .gesture(
                    DragGesture(minimumDistance: .zero, coordinateSpace: .named(K.UIConstants.gameViewCoordinateSpaceName))
                        .onChanged { gesture in
                            if !block.isSpent {
                                block.position = CGPoint(x: gesture.location.x + blockPixelSize.width / 2, y: gesture.location.y - blockPixelSize.height / 2)
                                block.isPickedUp = true
                                resetGridTilesHover()
                                block.fitsOnGrid = checkIfBlockFitsOnGrid(block)
                            }
                        }
                        .onEnded { _ in
                            if !block.isSpent {
                                // Do stuff for dropping the block
                                block.isPickedUp = false
                                if block.fitsOnGrid {
                                    block.isSpent = true
                                    dropBlockOnGrid(block)
                                    block.shape = emptyBlock
                                    if gamemode == .normal {
                                        checkIfPlayerScored(isMatchMode: false)
                                        block.tileType = Int.random(in: 1...6)
                                        secondsLeft = 8
                                    } else if gamemode == .increment {
                                        checkIfPlayerScored(isMatchMode: false)
                                        block.tileType = Int.random(in: 1...6)
                                        secondsLeft += 4
                                    } else if gamemode == .match {
                                        checkIfPlayerScored(isMatchMode: true)
                                        block.tileType = Int.random(in: 2...4)
                                        secondsLeft = 15
                                    }
                                }
                                resetBlocks()
                                resetGridTilesHover()
                                saveGame()
                            }
                        }
                )
                if i < blocks.count - 1 { // Makes spacers after every block but the last
                    Spacer()
                }
            }
        }
        .padding(20)
        .background(Color(0x393939))
    }
    
    @ViewBuilder func makeBlockDragImages() -> some View {
        ForEach(0..<blocks.count, id: \.self) { i in
            let block = blocks[i]
            VStack(spacing: 0) {
                ForEach(0..<block.shape.count, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<block.shape[row].count, id: \.self) { col in
                            // Draws each of the blocks from their shape
                            if block.shape[row][col] == 1 {
                                getBlockImage(tileNumber: block.tileType)
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                getBlockImage(tileNumber: 0)
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                    }
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height / 7, alignment: .center)
            .position(block.position)
            .opacity(block.isPickedUp ? 1 : 0)
        }
    }
    
    
    func getBlockImage(tileNumber: Int) -> Image {
        switch tileNumber {
        case 0:
            return Image("nosquare")
        case 1:
            return Image("block1")
        case 2:
            return Image("block2")
        case 3:
            return Image("block3")
        case 4:
            return Image("block4")
        case 5:
            return Image("block5")
        case 6:
            return Image("block6")
        default:
            // This should not be called
            return Image("")
        }
    }
    
    func resetBlocks() {
        if blocks[0].isSpent && blocks[1].isSpent && blocks[2].isSpent {
            for block in blocks {
                block.shape = blockShapes.randomElement()!
                block.isSpent = false
            }
        }
    }
    
    func resetGridTilesHover() {
        for row in 0..<gridTiles.count {
            for col in 0..<gridTiles[row].count {
                gridTiles[row][col].isBeingHovered = false
            }
        }
    }
    
    func resetGridTilesExtraPoints() {
        for row in 0..<gridTiles.count {
            for col in 0..<gridTiles[row].count {
                gridTiles[row][col].isExtraPoints = false
            }
        }
    }
    
    func resetWholeGrid() {
        resetGridTilesHover()
        resetGridTilesExtraPoints()
        // Creates the invisible tiles on the border of the grid
        for row in 0..<gridTiles.count {
            gridTiles[row][0].tileNumber = -1
        }
        
        for col in 0..<gridTiles[0].count {
            gridTiles[0][col].tileNumber = -1
        }
        
        // Makes all the other tiles empty
        for row in 1..<gridTiles.count {
            for col in 1..<gridTiles[row].count {
                gridTiles[row][col].tileNumber = 0
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
                if gridTiles[gridRow][gridCol].tileFrame.contains(CGPoint(x: block.position.x - blockPixelSize.width / 3, y: block.position.y + blockPixelSize.height / 4.5)) {
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
                                    gridTiles[gridRow + blockRow][gridCol + blockCol].isBeingHovered = true
                                    if gridTiles[gridRow + blockRow][gridCol + blockCol].tileNumber != 0 {
                                        // Is false because something in the grid is in the way
                                        blockFitsOnGrid = false
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
                    gridTiles[row][col].tileNumber = block.tileType
                }
            }
        }
    }
    
    func checkIfPlayerScored(isMatchMode: Bool) {
        /// The amount of points that will be added to the player's score
        var pointsScored = 0
        /// (row, col)  tuples that represent each of the grid tiles that should be cleared
        var tilesToClear = [(Int, Int)]()
        /// The tile type used for matching
        var tileType = -1
        
        var scored = false
        
        // Checks grid subsections
        for subsection in 0..<gridWidth * gridHeight / Int(pow(Double(gridSubsectionSize), 2)) {
            var subsectionTiles = [(Int, Int)]()
            var hasExtraPointsTile = false
            var subsectionFilled = true
            // Goes through tiles of subsection to check if they are filled
        outerLoop: for row in Int(floor(Double(subsection / (gridWidth / gridSubsectionSize)))) * gridSubsectionSize + 1...Int(floor(Double(subsection / (gridWidth / gridSubsectionSize)))) * gridSubsectionSize + gridSubsectionSize {
            for col in (subsection % (gridWidth / gridSubsectionSize)) * gridSubsectionSize + 1...(subsection % (gridWidth / gridSubsectionSize)) * gridSubsectionSize + gridSubsectionSize {
                subsectionTiles.append((row: row, col: col))
                if gridTiles[row][col].isExtraPoints {
                    hasExtraPointsTile = true
                }
                // Checks if one of the tiles in the subsection is empty
                if gridTiles[row][col].tileNumber == 0 {
                    subsectionFilled = false
                    // Stops checking if the subsection is filled because one of the tiles was empty
                    break outerLoop
                } else if isMatchMode {
                    if tileType != -1 {
                        if gridTiles[row][col].tileNumber != tileType {
                            subsectionFilled = false
                            // Stops checking if the subsection is filled because one of the tiles didn't match
                            break outerLoop
                        }
                    } else {
                        tileType = gridTiles[row][col].tileNumber
                    }
                }
            }
        }
            // Clears the tiles and gives the user points if the subsection is full
            if subsectionFilled {
                tilesToClear += subsectionTiles
                pointsScored *= 2
                pointsScored += 100
                pointsScored *= hasExtraPointsTile ? 2 : 1
                scored = true
            }
            
            tileType = -1
        }
        
        // Checks grid rows
        for row in 1...gridHeight {
            var rowTiles = [(Int, Int)]()
            var hasExtraPointsTile = false;
            var rowFilled = true
            for col in 1...gridWidth {
                rowTiles.append((row: row, col: col))
                if gridTiles[row][col].isExtraPoints {
                    hasExtraPointsTile = true
                }
                // Checks if one of the tiles in the row is empty
                if gridTiles[row][col].tileNumber == 0 {
                    rowFilled = false
                    // Stops checking if the row is filled because one of the tiles was empty
                    break
                } else if isMatchMode {
                    if tileType != -1 {
                        if gridTiles[row][col].tileNumber != tileType {
                            rowFilled = false
                            // Stops checking if the row is filled because one of the tiles didn't match
                            break
                        }
                    } else {
                        tileType = gridTiles[row][col].tileNumber
                    }
                }
            }
            // Clears the tiles and gives the user points if the row is full
            if rowFilled {
                tilesToClear += rowTiles
                pointsScored *= 2
                pointsScored += 100
                pointsScored *= hasExtraPointsTile ? 2 : 1
                scored = true
            }
            
            tileType = -1
        }
        
        // Checks grid columns
        for col in 1...gridWidth {
            var colTiles = [(Int, Int)]()
            var hasExtraPointsTile = false
            var colFilled = true
            for row in 1...gridHeight {
                colTiles.append((row: row, col: col))
                if gridTiles[row][col].isExtraPoints {
                    hasExtraPointsTile = true
                }
                // Checks if one of the tiles in the column is empty
                if gridTiles[row][col].tileNumber == 0 {
                    colFilled = false
                    // Stops checking if the column is filled because one of the tiles was empty
                    break
                } else if isMatchMode {
                    if tileType != -1 {
                        if gridTiles[row][col].tileNumber != tileType {
                            colFilled = false
                            // Stops checking if the column is filled because one of the tiles didn't match
                            break
                        }
                    } else {
                        tileType = gridTiles[row][col].tileNumber
                    }
                }
            }
            // Clears the tiles and gives the user points if the column is full
            if colFilled {
                tilesToClear += colTiles
                pointsScored *= 2
                pointsScored += 100
                pointsScored *= hasExtraPointsTile ? 2 : 1
                scored = true
            }
        }
        
        score += pointsScored
        
        if scored {
            clearGridTiles(tilesToClear: tilesToClear)
            resetGridTilesExtraPoints()
        }
        
        // Theres a small chance that a random tile will become worth more points
        if Int.random(in: 1...5) == 1 {
            gridTiles[Int.random(in: 1...gridHeight)][Int.random(in: 1...gridWidth)].isExtraPoints = true
        }
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(isOnTitleScreen: .constant(false), gamemode: .constant(.normal))
    }
}
