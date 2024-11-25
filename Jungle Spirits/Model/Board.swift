//
//  Game.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/5/23.
//

import Foundation
import SwiftUI


class Board: ObservableObject {
    
    @Published private(set) var cells: [[CellState]]
    @Published var gameOver: Bool = false
    @Published var convertedCells: [(row: Int, col: Int)] = []
    
    
    
    let size: (rows: Int, columns: Int)
    var obstacles: [(Int, Int)]
    var gameType: GameType
    var tutorialStep: TutorialStep?


    var turn = 0
    init(size: (rows: Int, columns: Int), gameType: GameType ,obstacles: [(Int, Int)]) {
        self.gameType = gameType
        self.size = size
        cells = Array(repeating: Array(repeating: .empty, count: size.columns), count: size.rows)
     
        let topLeft = (row: 0, col: 0)
        let bottomRight = (row: size.rows - 1, col: size.columns - 1)
        let topRight = (row: 0, col: size.columns - 1)
        let bottomLeft = (row: size.rows - 1, col: 0)
        self.obstacles = obstacles
        cells[topLeft.row][topLeft.col] = .player1
        cells[bottomRight.row][bottomRight.col] = .player1
        cells[topRight.row][topRight.col] = .player2
        cells[bottomLeft.row][bottomLeft.col] = .player2
        for (row, col) in obstacles {
            cells[row][col] = .obstacle
        }
    }
    init(cells: [[CellState]], gameType: GameType) {
        self.gameType = gameType
        self.cells = cells
        self.size = (rows: cells.count, columns: cells.first?.count ?? 0)
        var reconstructedObstacles = [(Int, Int)]()
        for (rowIndex, row) in cells.enumerated() {
            for (colIndex, cell) in row.enumerated() {
                if cell == .obstacle {
                    reconstructedObstacles.append((rowIndex, colIndex))
                }
            }
        }
        self.obstacles = reconstructedObstacles
    }
    
    //MARK: - Initialization for the Tutorial
//    init(size: (rows: Int, columns: Int)) {
//        self.size = size
//        self.gameType = .tutorial
//        self.obstacles = []
//        cells = Array(repeating: Array(repeating: .empty, count: size.columns), count: size.rows)
//    }
    
    
    
    func copy() -> Board {
        let newCells = self.cells.map { $0 }
        let copiedBoard = Board(cells: newCells, gameType: gameType)
        return copiedBoard
    }
    func reset() {
        for row in 0..<size.rows {
            for col in 0..<size.columns {
                //MARK: ALSO DEFINE THE OBSTACLES
                cells[row][col] = .empty
            }
        }
        cells[0][0] = .player1
        cells[0][size.columns - 1] = .player2
        cells[size.rows - 1][0] = .player2
        cells[size.rows - 1][size.columns - 1] = .player1
        for (row, col) in obstacles {
            cells[row][col] = .obstacle
        }
        turn = 0
        notifyChange()
    }
    func cellState(at position: (row: Int, col: Int)) -> CellState {
        return cells[position.row][position.col]
    }
    private func isValidCoordinate(_ coordinate: (row: Int, col: Int)) -> Bool {
        return coordinate.row >= 0 && coordinate.row < size.rows && coordinate.col >= 0 && coordinate.col < size.columns
    }
    func isLegalMove(from source: (row: Int, col: Int), to destination: (row: Int, col: Int), player: CellState) -> Bool {
        _ = (destination.row == 0 && destination.col == 0) ||
        (destination.row == 0 && destination.col == size.columns - 1) ||
        (destination.row == size.rows - 1 && destination.col == 0) ||
        (destination.row == size.rows - 1 && destination.col == size.columns - 1)
        if !isValidCoordinate(source) || !isValidCoordinate(destination) {
            return false
        }
        guard cellState(at: source) == player else {
            return false
        }
        guard cellState(at: destination) == .empty, cellState(at: destination) != .obstacle else {
            return false
        }
        let rowDifference = abs(destination.row - source.row)
        let colDifference = abs(destination.col - source.col)
        
        if rowDifference <= 1 && colDifference <= 1 {
            return true
        }
        // Check for a jump move of 2 steps, horizontal or vertical (not diagonal)
        if (rowDifference == 2 && colDifference == 0) || (rowDifference == 0 && colDifference == 2) {
            return true
        }
        // Check for a L jump
        if (rowDifference == 1 && colDifference == 2) || (rowDifference == 2 && colDifference == 1) {
            return true
        }
        return false
    }
    
    var currentPlayerForAi: CellState {
        return turn % 2 == 0 ? .player1 : .player2
    }
    
    func performMove(from source: (row: Int, col: Int), to destination: (row: Int, col: Int), player: CellState) -> [(row: Int, col: Int)] {
        let rowDifference = abs(destination.row - source.row)
        let colDifference = abs(destination.col - source.col)
        
        // Copying the piece if moving to an adjacent cell
        withAnimation(.easeInOut(duration: 0.5)) {
            if rowDifference <= 1 && colDifference <= 1 {
                cells[destination.row][destination.col] = player
            } else {
                cells[source.row][source.col] = .empty
                cells[destination.row][destination.col] = player
                
            }
        }
        let convertedCells = convertOpponentPieces(at: destination, player: player)
        turn += 1
        
            self.gameOver = self.isGameOver()
        return convertedCells
    }
    func convertOpponentPieces(at destination: (row: Int, col: Int), player: CellState) -> [(row: Int, col: Int)] {
        let opponent: CellState = player == .player1 ? .player2 : .player1
        
        var convertedCells: [(row: Int, col: Int)] = []
        for drow in -1...1 {
            for dcol in -1...1 {
                if drow == 0 && dcol == 0 {
                    continue
                }
                
                let newRow = destination.row + drow
                let newCol = destination.col + dcol
                
                if isValidCoordinate((row: newRow, col: newCol)) && cells[newRow][newCol] == opponent {
                    cells[newRow][newCol] = player
                    convertedCells.append((newRow, newCol))
                }
            }
        }
        return convertedCells
    }
    
    func countConvertiblePieces(at destination: (row: Int, col: Int), player: CellState) -> Int? {
        let opponent: CellState = player == .player1 ? .player2 : .player1
        
        var convertiblePieceCount = 0
        
        for drow in -1...1 {
            for dcol in -1...1 {
                if drow == 0 && dcol == 0 {
                    continue
                }
                
                let newRow = destination.row + drow
                let newCol = destination.col + dcol
                
                if isValidCoordinate((row: newRow, col: newCol)) && cells[newRow][newCol] == opponent {
                    convertiblePieceCount += 1
                }
            }
        }
        
        return convertiblePieceCount
    }
    
    /// Determines whether the game is over.
    /// The game is considered to be over if either player has no pieces remaining or if neither player has any legal moves left.
    func isGameOver() -> Bool {
        // Get the number of pieces for each player
        let (player1Count, player2Count, _) = countPieces()
        
        // The game is over if a player has no more pieces
        if player1Count == 0 || player2Count == 0 {
//            if gameType == .ai && (player1Count > player2Count) {
//                SoundManager.shared.playOverSound()
//            } else if gameType == .ai && (player2Count > player1Count) {
//                SoundManager.shared.playLoseSound()
//            } else {
//                SoundManager.shared.playLoseSound()
//            }
//            HapticManager.shared.impact(style: .heavy)
            return true
        }
        
        // The game is over if there are no more legal moves for either player
        if !hasLegalMoves(player: .player1) || !hasLegalMoves(player: .player2) {
//            if gameType == .ai && currentPlayerForAi == .player2 {
//                SoundManager.shared.playOverSound()
//            } else if gameType == .ai && currentPlayerForAi == .player1 {
//                SoundManager.shared.playLoseSound()
//            } else {
//                SoundManager.shared.playOverSound()
//            }
//            HapticManager.shared.impact(style: .heavy)
            return true
        }
        
        // If none of the above conditions are met, the game is not over
        return false
    }
    
    func hasLegalMoves(player: CellState) -> Bool {
        for row in 0..<size.rows {
            for col in 0..<size.columns {
                if cells[row][col] == player {
                    let source = (row: row, col: col)
                    if hasAnyLegalMoves(from: source, player: player) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func hasAnyLegalMoves(from source: (row: Int, col: Int), player: CellState) -> Bool {
        // Check for a neighboring cell, two-cell jumps, or an L-shaped jump
        let deltas = [(0, 1), (1, 0), (-1, 0), (0, -1),
                      (0, 2), (2, 0), (-2, 0), (0, -2),
                      (1, 2), (-1, 2), (1, -2), (-1, -2),
                      (2, 1), (-2, 1), (2, -1), (-2, -1)]
        
        for delta in deltas {
            let newRow = source.row + delta.0
            let newCol = source.col + delta.1
            let newDestination = (row: newRow, col: newCol)
            
            if isValidCoordinate(newDestination) && cellState(at: newDestination) == .empty && cellState(at: newDestination) != .obstacle {
                if isLegalMove(from: source, to: newDestination, player: player) {
                    return true
                }
            }
        }
        return false
    }
    
    func notifyChange() {
        self.objectWillChange.send()
    }
    
    func countPieces() -> (player1: Int, player2: Int, empty: Int) {
        var player1Count = 0
        var player2Count = 0
        var emptyCount = 0
        
        for row in 0..<size.rows {
            for col in 0..<size.columns {
                let cellState = cells[row][col]
                if cellState == .player1 {
                    player1Count += 1
                } else if cellState == .player2 {
                    player2Count += 1
                } else {
                    emptyCount += 1
                }
            }
        }
        return (player1: player1Count, player2: player2Count, empty: emptyCount)
    }
}

// MARK: Simple AI algorithm
extension Board {
    func performAIMove() -> [(row: Int, col: Int)]? {
        let aiPlayer: CellState = .player2
        guard let move = chooseMove(for: aiPlayer)  else {
            print("No valid move found for AI player.")
            return nil
        }
        
        var convertedCells: [(row: Int, col: Int)] = []
        // Perform the move and return the move
        convertedCells = self.performMove(from: move.source, to: move.destination, player: aiPlayer)
        gameOver = isGameOver()
        return convertedCells
        
    }
    
    func scoreMove(_ move: Move, for player: CellState) -> Int {
        // Make a copy of the board
        let boardCopy = self.copy()
        
        // Execute the move on the copy
        _ = boardCopy.performMove(from: move.source, to: move.destination, player: player)
        
        // Count the number of player's pieces on the copy
        let playerPiecesCopy = (player == .player1) ? boardCopy.countPieces().player1 : boardCopy.countPieces().player2
        
        // Count the number of player's pieces on the original board
        let playerPiecesOriginal = (player == .player1) ? self.countPieces().player1 : self.countPieces().player2
        
        // The score for the move is the difference in the number of pieces
        let score = playerPiecesCopy - playerPiecesOriginal
        
        return score
    }
    func chooseMove(for player: CellState) -> Move? {
        // Get all legal moves for the player
        let legalMoves = getLegalMoves(for: player)
        
        // Score each move
        let scores = legalMoves.map { scoreMove($0, for: player) }
        
        // Find the highest score
        let maxScore = scores.max()
        
        // Find all moves that have this score
        let bestMoves = legalMoves.filter { scoreMove($0, for: player) == maxScore }
        
        // Choose a move randomly from the best moves
        let move = bestMoves.randomElement()
        
        return move
    }
    func getLegalMoves(for player: CellState) -> [Move] {
        var moves: [Move] = []
        
        for row in 0..<size.rows {
            for col in 0..<size.columns {
                let cell = (row: row, col: col)
                
                if cellState(at: cell) == player {
                    let cellMoves = getLegalMoves(for: cell)
                    moves.append(contentsOf: cellMoves)
                }
            }
        }
        
        return moves
    }
    
    func getLegalMoves(for cell: (row: Int, col: Int)) -> [Move] {
        var moves: [Move] = []
        
        // The directions a cell can move to for duplication (orthogonal and diagonal)
        let directions = [(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1), (1, -1), (-1, 1)]
        
        // The directions a cell can jump to (horizontal, vertical, and L-shaped)
        let jumpDirections = [(2, 0), (-2, 0), (0, 2), (0, -2), (2, 1), (-2, -1), (1, 2), (-1, -2),
                              (-2, 1), (2, -1), (-1, 2), (1, -2)]
        
        // Check each direction for duplication.
        for direction in directions {
            let adjacentCell = (row: cell.row + direction.0, col: cell.col + direction.1)
            if isValidCoordinate(adjacentCell) && cellState(at: adjacentCell) == .empty && cellState(at: adjacentCell) != .obstacle {
                moves.append(Move(source: cell, destination: adjacentCell))
            }
        }
        
        // Check each direction for jumping.
        for direction in jumpDirections {
            let jumpCell = (row: cell.row + direction.0, col: cell.col + direction.1)
            if isValidCoordinate(jumpCell) && cellState(at: jumpCell) == .empty && cellState(at: jumpCell) != .obstacle {
                moves.append(Move(source: cell, destination: jumpCell))
            }
        }
        return moves
    }
}


//MARK: - TUTORIAL CONFIGURATION
extension Board {
    
    convenience init(tutorialSize: (rows: Int, columns: Int), tutorialStep: TutorialStep) {
        self.init(size: tutorialSize, gameType: .tutorial, obstacles: [])
        setupTutorialBoard(for: tutorialStep)
    }
    func setupTutorialBoard(for step: TutorialStep) {
        self.objectWillChange.send()
        cells = Array(repeating: Array(repeating: .empty, count: size.columns), count: size.rows)
        
        switch step {
        case .clonePiece, .teleportPiece:
            let center = (row: size.rows / 2, col: size.columns / 2)
            cells[center.row][center.col] = .player1
        case .convertPiece:
            let middle = (row: size.rows / 2, col: size.columns / 2)
            cells[middle.row][middle.col] = .player1
            cells[middle.row + 2][middle.col] = .player2
        case .complextConvert:
            let middle = (row: size.rows / 2, col: size.columns / 2)
            cells[middle.row][middle.col - 1] = .player1
            cells[middle.row - 1][middle.col + 1] = .player2
            cells[middle.row - 2][middle.col + 1] = .player2
            cells[middle.row - 3][middle.col + 1] = .player2
            cells[middle.row - 3][middle.col] = .player2
            cells[middle.row - 3][middle.col - 1] = .player2
            cells[middle.row - 2][middle.col - 1] = .player2
            obstacles = [(middle.row, middle.col), (0, 0), (1, 0), (5, 0), (6, 0), (0, 4), (1, 4), (5, 4), (6, 4)]
            for obstacle in obstacles {
                cells[obstacle.0][obstacle.1] = .obstacle
            }
        }
        tutorialStep = step
    }
    func performTutorialMove(from source: (row: Int, col: Int), to destination: (row: Int, col: Int)) -> Bool {
        guard let step = tutorialStep else { return false }
        switch step {
        case .clonePiece:
            return performCloneMove(from: source, to: destination)
        case .teleportPiece:
            return performTeleportMove(from: source, to: destination)
        case .convertPiece:
            return performConversionMove(from: source, to: destination)
        case .complextConvert:
            return performConversionMove(from: source, to: destination)
        }
    }
    private func performCloneMove(from source: (row: Int, col: Int), to destination: (row: Int, col: Int)) -> Bool {
        if isCloneMove(from: source, to: destination) && isEmptyCell(at: destination) {
            _ = performMove(from: source, to: destination, player: .player1)
            return true
        }
        return false
    }
    
    private func isEmptyCell(at position: (row: Int, col: Int)) -> Bool {
        return cells[position.row][position.col] == .empty
    }
    
    private func performTeleportMove(from source: (row: Int, col: Int), to destination: (row: Int, col: Int)) -> Bool {
        if isTeleportMove(from: source, to: destination) && isEmptyCell(at: destination) {
            _ = performMove(from: source, to: destination, player: .player1)
            return true
        }
        return false
    }
    
    private func performConversionMove(from source: (row: Int, col: Int), to destination: (row: Int, col: Int)) -> Bool {
        if isEmptyCell(at: destination) {
            convertedCells += performMove(from: source, to: destination, player: .player1)
            if tutorialStep == .convertPiece {
                return !convertedCells.isEmpty
            } else {
                return convertedCells.count >= 6
            }
        }
        return false
        
    }
    
    
    //Helper functions
    private func isCloneMove(from source: (row: Int, col: Int), to destination: (row: Int, col: Int)) -> Bool {
        let rowDifference = abs(destination.row - source.row)
        let colDifference = abs(destination.col - source.col)
        return rowDifference <= 1 && colDifference <= 1
    }
    
    private func isTeleportMove(from source: (row: Int, col: Int), to destination: (row: Int, col: Int)) -> Bool {
        let rowDifference = abs(destination.row - source.row)
        let colDifference = abs(destination.col - source.col)
        
        return (rowDifference > 1 || colDifference > 1) && isLegalMove(from: source, to: destination, player: .player1)

        
    }
    
    func updateCell(row: Int, col: Int, newState: CellState) {
        var updatedCells = cells
        updatedCells[row][col] = newState
        self.cells = updatedCells // Reassigning triggers @Published
    }


}

///##### MAYBE FOR LATER USE ######
//// MARK: MCTS algorithm
//
//extension Board {
//    // Selection
//    func selectPromisingNode(rootNode: Node) -> Node {
//        var node = rootNode
//        while !node.untriedMoves.isEmpty && !node.children.isEmpty {
//            if let nextNode = node.UCTSelectChild() {
//                node = nextNode
//            } else {
//                break
//            }
//        }
//        return node
//    }
//    // Expansion
//    func expandNode(node: Node, board: Board) {
//        guard !node.untriedMoves.isEmpty else {
//            return
//        }
//        let move = node.untriedMoves.removeLast()
//        let newState = board.copy()
//        newState.performMove(from: move.source, to: move.destination, player: currentPlayerForAi)
//        _ = node.addChild(move: move, state: newState)
//    }
//
//    // Simulation
//    func simulateRandomPlayout(node: Node, board: Board) -> Int {
//        let currentState = board.copy()
//        var currentPlayer: CellState = node.player
//
//        while !currentState.isGameOver() {
//            //            let currentPlayerCells = getPlayerCells(player: currentPlayer, board: currentState)
//            let moves = currentState.getLegalMoves(for: currentPlayer)
//            guard !moves.isEmpty else {
//                break
//            }
//            let randomMove = moves.randomElement()!
//            currentState.performMove(from: randomMove.source, to: randomMove.destination, player: currentPlayer)
//            currentPlayer = currentPlayer.opposite()
//        }
//        let (player1Count, player2Count, _) = currentState.countPieces()
//        let result = player2Count - player1Count
//        node.update(result: result)
//        return result
//    }
//
//    // Propagation
//    private func propagation(node: Node, result: Int) {
//        var currentNode: Node? = node
//        while let node = currentNode {
//            node.update(result: result)
//            currentNode = node.parent
//        }
//    }
//
//    // Function to perform AI move using MCTS
//    func performMTSCMove() {
//        let currentPlayerCells = getPlayerCells(player: .player2, board: self)
//        let rootNode = Node(move: Move(source: (-1, -1), destination: (-1, -1)), parent: nil, untriedMoves: getLegalMoves(for: currentPlayerCells.first!), player: .player2)
//        let MCTSIterations = 100
//
//        for _ in 0..<MCTSIterations {
//            let promisingNode = selectPromisingNode(rootNode: rootNode)
//            self.expandNode(node: promisingNode, board: self)
//            let playoutResult = simulateRandomPlayout(node: promisingNode, board: self)
//            self.propagation(node: promisingNode, result: playoutResult)
//        }
//
//        let bestChild = rootNode.children.max { $0.simulations < $1.simulations }
//        DispatchQueue.main.async {
//            if let move = bestChild?.move {
//                self.performMove(from: move.source, to: move.destination, player: .player2)
//            }
//        }
//    }
//
//    func getRandomAdjacentCell(cell: (Int, Int)) -> (Int, Int)? {
//        let directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
//        var adjacentCells: [(Int, Int)] = []
//
//        for direction in directions {
//            let adjacentCell = (row: cell.0 + direction.0, col: cell.1 + direction.1)
//            if isValidCoordinate(adjacentCell) && cellState(at: adjacentCell) == .empty {
//                adjacentCells.append(adjacentCell)
//            }
//        }
//
//        return adjacentCells.randomElement()
//    }
//
//    func getRandomCell() -> (Int, Int) {
//        var emptyCells: [(Int, Int)] = []
//
//        for row in 0..<size.rows {
//            for col in 0..<size.columns {
//                if cellState(at: (row, col)) == .empty {
//                    emptyCells.append((row, col))
//                }
//            }
//        }
//
//        if let randomCell = emptyCells.randomElement() {
//            return randomCell
//        }
//
//        // If no empty cells are found, return a default cell
//        return (0, 0)
//    }
//
////    private func updateTurn() {
////        turn += 1
////    }
//
//    func getPlayerCells(player: CellState) -> [(row: Int, col: Int)] {
//        var cells: [(row: Int, col: Int)] = []
//        for row in 0..<size.rows {
//            for col in 0..<size.columns {
//                if cellState(at: (row, col)) == player {
//                    cells.append((row, col))
//                }
//            }
//        }
//        return cells
//    }
//
//    func getPlayerCells(player: CellState, board: Board) -> [(row: Int, col: Int)] {
//        var cells: [(row: Int, col: Int)] = []
//        for row in 0..<board.size.rows {
//            for col in 0..<board.size.columns {
//                if board.cellState(at: (row, col)) == player {
//                    cells.append((row, col))
//                }
//            }
//        }
//        return cells
//    }
//
//    func getLegalMoves(for cells: [(row: Int, col: Int)], board: Board) -> [Move] {
//        var moves: [Move] = []
//
//        // The directions a cell can move to for duplication (orthogonal and diagonal)
//        let directions = [(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1), (1, -1), (-1, 1)]
//
//        // The directions a cell can jump to (horizontal, vertical, and L-shaped)
//        let jumpDirections = [(2, 0), (-2, 0), (0, 2), (0, -2), (2, 1), (-2, -1), (1, 2), (-1, -2),
//                              (-2, 1), (2, -1), (-1, 2), (1, -2)]
//
//        for cell in cells {
//            // Check each direction for duplication.
//            for direction in directions {
//                let adjacentCell = (row: cell.row + direction.0, col: cell.col + direction.1)
//                if board.isValidCoordinate(adjacentCell) && board.cellState(at: adjacentCell) == .empty {
//                    moves.append(Move(source: cell, destination: adjacentCell))
//                }
//            }
//
//            // Check each direction for jumping.
//            for direction in jumpDirections {
//                let jumpCell = (row: cell.row + direction.0, col: cell.col + direction.1)
//                if board.isValidCoordinate(jumpCell) && board.cellState(at: jumpCell) == .empty {
//                    moves.append(Move(source: cell, destination: jumpCell))
//                }
//            }
//        }
//
//        return moves
//    }
//
//    func gameOutcome(for player: CellState) -> Double {
//        // Count the pieces on the board for each player
//        let (player1Count, player2Count, _) = countPieces()
//
//        // If the board is full or if a player cannot make a legal move,
//        // the player with the most pieces is the winner.
//        if isGameOver() {
//            switch player {
//            case .player1:
//                return player1Count > player2Count ? 1.0 : 0.0
//            case .player2:
//                return player2Count > player1Count ? 1.0 : 0.0
//            default:
//                return 0.0
//            }
//        }
//
//        // If the game is not over, return a score proportional to the player's piece count.
//        // This is a heuristic to prioritize states where the player has more pieces.
//        let totalPieces = player1Count + player2Count
//        switch player {
//        case .player1:
//            return Double(player1Count) / Double(totalPieces)
//        case .player2:
//            return Double(player2Count) / Double(totalPieces)
//        default:
//            return 0.5
//        }
//    }
//
//    func getLegalMoves(for cell: (row: Int, col: Int)) -> [Move] {
//        var moves: [Move] = []
//
//        // The directions a cell can move to for duplication (orthogonal and diagonal)
//        let directions = [(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1), (1, -1), (-1, 1)]
//
//        // The directions a cell can jump to (horizontal, vertical, and L-shaped)
//        let jumpDirections = [(2, 0), (-2, 0), (0, 2), (0, -2), (2, 1), (-2, -1), (1, 2), (-1, -2),
//                              (-2, 1), (2, -1), (-1, 2), (1, -2)]
//
//        // Check each direction for duplication.
//        for direction in directions {
//            let adjacentCell = (row: cell.row + direction.0, col: cell.col + direction.1)
//            if isValidCoordinate(adjacentCell) && cellState(at: adjacentCell) == .empty {
//                moves.append(Move(source: cell, destination: adjacentCell))
//            }
//        }
//
//        // Check each direction for jumping.
//        for direction in jumpDirections {
//            let jumpCell = (row: cell.row + direction.0, col: cell.col + direction.1)
//            if isValidCoordinate(jumpCell) && cellState(at: jumpCell) == .empty {
//                moves.append(Move(source: cell, destination: jumpCell))
//            }
//        }
//
//        return moves
//    }
//

//    func getMoves() -> [Move] {
//        var moves: [Move] = []
//
//        // Iterate over the board.
//        for row in 0..<size.rows {
//            for col in 0..<size.columns {
//                let cell = (row: row, col: col)
//                // If the cell has a piece of the current player and it can make a legal move,
//                // add it to the array of moves.
//                if cellState(at: cell) == currentPlayerForAi {
//                    let possibleMoves = getLegalMoves(for: cell)
//                    moves.append(contentsOf: possibleMoves)
//                }
//            }
//        }
//
//        return moves
//    }
//}

//    func convertOpponentPieces(currentPlayer: CellState) -> Int {
//        var conversionCount = 0
//
//        let opponentPlayer = currentPlayer.opposite()
//
//        for row in 0..<size.rows {
//            for col in 0..<size.columns {
//                if cellState(at: (row, col)) == opponentPlayer {
//                    cells[row][col] = currentPlayer
//                    conversionCount += 1
//                }
//            }
//        }
//
//        return conversionCount
//    }

//    private func hasAnyLegalMove(from source: (row: Int, col: Int)) -> Bool {
//        for drow in [-2, -1, 0, 1, 2] {
//            for dcol in [-2, -1, 0, 1, 2] {
//                let newRow = source.row + drow
//                let newCol = source.col + dcol
//                if isValidCoordinate((row: newRow, col: newCol)) && cells[newRow][newCol] == .empty {
//                    return true
//                }
//
//            }
//        }
//        return false
//    }

// class MonteCarloTreeSearch {
//    let explorationParam: Double
//    let rootNode: Node
//    init(rootBoard: Board, explorationParam: Double = sqrt(2)) {
//           self.explorationParam = explorationParam
//           self.rootNode = Node(board: rootBoard, playerJustMoved: rootBoard.currentPlayer.opposite())
//       }
//    func selection(node: Node) -> Node {
//            var node = node
//            while !node.children.isEmpty {
//                node = node.children.max(by: { explorationValue(node: $0) < explorationValue(node: $1) })!
//            }
//            return node
//        }
//
//
//    func expansion(node: Node) {
//            let possibleMoves = node.board.getMoves()
//            for move in possibleMoves {
//                let newBoard = node.board.copy()
//                newBoard.performMove(from: move.source, to: move.destination, player: newBoard.currentPlayer)
//                let newNode = Node(move: move, parent: node, board: newBoard, playerJustMoved: newBoard.currentPlayer)
//                node.children.append(newNode)
//            }
//        }
//
//    func simulation(node: Node) -> Double {
//        var currentBoard = node.board.copy()
//        while !currentBoard.isGameOver() {
//            if let randomMove = currentBoard.getMoves().randomElement() {
//                currentBoard.performMove(from: randomMove.source, to: randomMove.destination, player: currentBoard.currentPlayer)
//            }
////            let randomMove = currentBoard.getMoves().randomElement()!
//
//        }
//        return currentBoard.gameOutcome(for: rootNode.board.currentPlayer)
//    }
//
//    func backpropagation(node: Node, result: Double) {
//        var currentNode: Node? = node
//        while let node = currentNode {
//            node.update(result: node.playerJustMoved == rootNode.board.currentPlayer ? result : 1 - result)
//            currentNode = node.parent
//        }
//    }
//
//    func explorationValue(node: Node) -> Double {
//        if node.visits == 0 {
//            return Double.infinity
//        }
//        let exploitationValue = node.wins / node.visits
//        let explorationValue = explorationParam * sqrt(log(node.parent!.visits) / node.visits)
//        return exploitationValue + explorationValue
//    }
//
//    func bestChild(node: Node) -> Node {
//        return node.children.max(by: { explorationValue(node: $0) < explorationValue(node: $1) })!
//    }
//
//    func search(iterations: Int) -> Move? {
//            if rootNode.board.isGameOver() {
//                return nil
//            }
//            for _ in 0..<iterations {
//                let nodeToExplore = selection(node: rootNode)
//                if nodeToExplore.board.isGameOver() {
//                    let simulationResult = simulation(node: nodeToExplore)
//                    backpropagation(node: nodeToExplore, result: simulationResult)
//                } else {
//                    expansion(node: nodeToExplore)
//                    let exploredNode = nodeToExplore.children.last!
//                    let simulationResult = simulation(node: exploredNode)
//                    backpropagation(node: exploredNode, result: simulationResult)
//                }
//            }
//            return bestChild(node: rootNode).move
//        }
//
// }
