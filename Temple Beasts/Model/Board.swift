//
//  Game.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/5/23.
//

import Foundation

enum CellState: Int {
    case empty
    case player1
    case player2
    case draw
    func opposite() -> CellState {
        switch self {
        case .player1:
            return .player2
        case .player2:
            return .player1
        default:
            return .empty
        }
    }
}

struct Move {
    let source: (row: Int, col: Int)
    let destination: (row: Int, col: Int)
    static func == (lhs: Move, rhs: Move) -> Bool {
        return lhs.source == rhs.source && lhs.destination == rhs.destination
    }
}


class Board: ObservableObject {
    @Published private(set) var cells: [[CellState]]
    let size: (rows: Int, columns: Int)
    var gameType: GameType
    var turn = 0
    init(size: (rows: Int, columns: Int), gameType: GameType) {
        self.gameType = gameType
        self.size = size
        cells = Array(repeating: Array(repeating: .empty, count: size.columns), count: size.rows)
        
        let topLeft = (row: 0, col: 0)
        let bottomRight = (row: size.rows - 1, col: size.columns - 1)
        let topRight = (row: 0, col: size.columns - 1)
        let bottomLeft = (row: size.rows - 1, col: 0)
        
        cells[topLeft.row][topLeft.col] = .player1
        cells[bottomRight.row][bottomRight.col] = .player1
        cells[topRight.row][topRight.col] = .player2
        cells[bottomLeft.row][bottomLeft.col] = .player2
    }
    init(cells: [[CellState]], gameType: GameType) {
        self.gameType = gameType
        self.cells = cells
        self.size = (rows: cells.count, columns: cells.first?.count ?? 0)
    }
    func copy() -> Board {
        let newCells = self.cells.map { $0 }
        let copiedBoard = Board(cells: newCells, gameType: gameType)
        return copiedBoard
    }
    func reset() {
        for row in 0..<size.rows {
            for col in 0..<size.columns {
                cells[row][col] = .empty
            }
        }
        
        cells[0][0] = .player1
        cells[0][size.columns - 1] = .player2
        cells[size.rows - 1][0] = .player2
        cells[size.rows - 1][size.columns - 1] = .player1
        
        turn = 0
        notifyChange()
    }
    func cellState(at position: (row: Int, col: Int)) -> CellState {
        return cells[position.row][position.col]
    }
    private func isValidCoordinate(_ coordinate: (row: Int, col: Int)) -> Bool {
        return coordinate.row >= 0 && coordinate.row < size.rows && coordinate.col >= 0 && coordinate.col < size.columns
    }
    var eitherPlayerNoLegalMoves: Bool {
        return !(hasLegalMoves(player: .player1) || hasLegalMoves(player: .player2))
    }
    func isLegalMove(from source: (row: Int, col: Int), to destination: (row: Int, col: Int), player: CellState) -> Bool {
        let isCorner = (destination.row == 0 && destination.col == 0) ||
        (destination.row == 0 && destination.col == size.columns - 1) ||
        (destination.row == size.rows - 1 && destination.col == 0) ||
        (destination.row == size.rows - 1 && destination.col == size.columns - 1)
        if !isValidCoordinate(source) || !isValidCoordinate(destination) {
            return false
        }
        guard cellState(at: source) == player else {
            return false
        }
        guard cellState(at: destination) == .empty else {
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
        //Check for a L jump
        if (rowDifference == 1 && colDifference == 2) || (rowDifference == 2 && colDifference == 1) {
            return true
        }
        return false
    }
    
    var currentPlayer: CellState {
        return turn % 2 == 0 ? .player1 : .player2
    }
    func getMoves() -> [Move] {
        var moves: [Move] = []
        
        // Iterate over the board.
        for row in 0..<size.rows {
            for col in 0..<size.columns {
                let cell = (row: row, col: col)
                // If the cell has a piece of the current player and it can make a legal move,
                // add it to the array of moves.
                if cellState(at: cell) == currentPlayer {
                    let possibleMoves = getLegalMoves(for: cell)
                    moves.append(contentsOf: possibleMoves)
                }
            }
        }
        
        return moves
    }
    func performMove(from source: (row: Int, col: Int), to destination: (row: Int, col: Int), player: CellState) -> Int? {
        let rowDifference = abs(destination.row - source.row)
        let colDifference = abs(destination.col - source.col)
        
        // Copying the piece if moving to an adjacent cell
        if rowDifference <= 1 && colDifference <= 1 {
            cells[destination.row][destination.col] = player
        }
        
        else {
            cells[source.row][source.col] = .empty
            cells[destination.row][destination.col] = player
        }
        
        let convertedPieces = convertOpponentPieces(at: destination, player: player)
        
        turn += 1
        
        return convertedPieces
    }
    func convertOpponentPieces(at destination: (row: Int, col: Int), player: CellState) -> Int? {
        let opponent: CellState = player == .player1 ? .player2 : .player1
        
        var convertedPieceCount = 0

        
        for drow in -1...1 {
            for dcol in -1...1 {
                if drow == 0 && dcol == 0 {
                    continue
                }
                
                let newRow = destination.row + drow
                let newCol = destination.col + dcol
                
                if isValidCoordinate((row: newRow, col: newCol)) && cells[newRow][newCol] == opponent {
                    cells[newRow][newCol] = player
                    convertedPieceCount += 1

                }
            }
        }

        return convertedPieceCount
        
    }

    /// Determines whether the game is over.
    /// The game is considered to be over if either player has no pieces remaining or if neither player has any legal moves left.
    func isGameOver() -> Bool {
        // Get the number of pieces for each player
           let (player1Count, player2Count, _) = countPieces()
           
           // The game is over if a player has no more pieces
           if player1Count == 0 || player2Count == 0 {
               SoundManager.shared.playOverSound()
               HapticManager.shared.impact(style: .heavy)
               return true
           }

           // The game is over if there are no more legal moves for either player
           if !hasLegalMoves(player: .player1) && !hasLegalMoves(player: .player2) {
               SoundManager.shared.playOverSound()
               HapticManager.shared.impact(style: .heavy)
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
    
    func getLegalMoves(for cell: (row: Int, col: Int)) -> [Move] {
        var moves: [Move] = []
        
        // The directions a cell can move to for duplication (orthogonal and diagonal)
        let directions = [(1,0), (-1,0), (0,1), (0,-1), (1,1), (-1,-1), (1,-1), (-1,1)]
        
        // The directions a cell can jump to (horizontal, vertical, and L-shaped)
        let jumpDirections = [(2,0), (-2,0), (0,2), (0,-2), (2,1), (-2,-1), (1,2), (-1,-2),
                              (-2,1), (2,-1), (-1,2), (1,-2)]
        
        // Check each direction for duplication.
        for direction in directions {
            let adjacentCell = (row: cell.row + direction.0, col: cell.col + direction.1)
            if isValidCoordinate(adjacentCell) && cellState(at: adjacentCell) == .empty {
                moves.append(Move(source: cell, destination: adjacentCell))
            }
        }
        
        // Check each direction for jumping.
        for direction in jumpDirections {
            let jumpCell = (row: cell.row + direction.0, col: cell.col + direction.1)
            if isValidCoordinate(jumpCell) && cellState(at: jumpCell) == .empty {
                moves.append(Move(source: cell, destination: jumpCell))
            }
        }
        
        return moves
    }
    
    private func getLegalMoves(for player: CellState) -> [Move] {
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
            
            if isValidCoordinate(newDestination) && cellState(at: newDestination) == .empty {
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













//MARK: Simple AI algorithm
extension Board {
    
    func performAIMove() -> Move? {
        let aiPlayer: CellState = .player2
        guard let move = getBestMove(for: aiPlayer) else {
            print("No valid move found for AI player.")
            // No move found, return nil
            return nil
        }
                
        // Perform the move and return the move
        DispatchQueue.main.async {
            self.performMove(from: move.source, to: move.destination, player: aiPlayer)
        }
        
        
        return move
    }
    
    func getBestMove(for player: CellState) -> Move? {
        var bestMove: Move?
        var bestScore = -9999
        
        // Iterate through all the cells.
        for row in 0..<size.rows {
            for col in 0..<size.columns {
                let sourceCell = (row: row, col: col)
                if cellState(at: sourceCell) != player {
                    continue
                }
                
                for drow in -1...1 {
                    for dcol in -1...1 {
                        let destinationCell = (row: row + drow, col: col + dcol)
                        if isValidCoordinate(destinationCell) && isLegalMove(from: sourceCell, to: destinationCell, player: player) {
                            // Get cells to capture after this move
                            let cellsToCapture = self.cellsToCapture(from: sourceCell, to: destinationCell, player: player)
                            
                            // Calculate score based on the cells to be captured.
                            var score = cellsToCapture.count * 10
                            
                            // Add a penalty if the destination cell is adjacent to an opponent's cell.
                            for ddrow in -1...1 {
                                for ddcol in -1...1 {
                                    let adjacentCell = (row: row + drow + ddrow, col: col + dcol + ddcol)
                                    if isValidCoordinate(adjacentCell) && cellState(at: adjacentCell) == player.opposite() {
                                        score -= 5
                                    }
                                }
                            }
                            // Update the best move if the score is higher than the current best score.
                            if score > bestScore {
                                bestScore = score
                                bestMove = Move(source: sourceCell, destination: destinationCell)
                            }
                        }
                    }
                }
            }
        }
        
        return bestMove
    }
    private func cellsToCapture(from source: (row: Int, col: Int), to destination: (row: Int, col: Int), player: CellState) -> [(row: Int, col: Int)] {
        var cells: [(row: Int, col: Int)] = []
        
        for dx in -1...1 {
            for dy in -1...1 {
                let cell = (row: destination.row + dx, col: destination.col + dy)
                if isValidCoordinate(cell) && cellState(at: cell) == player.opposite() {
                    cells.append(cell)
                }
            }
        }
        
        return cells
    }
    
    
}

//MARK: MCTS algorithm

extension Board {
    
    //Selection
    func selectPromisingNode(rootNode: Node) -> Node {
        var node = rootNode
        while !node.untriedMoves.isEmpty && !node.children.isEmpty {
            if let nextNode = node.UCTSelectChild() {
                node = nextNode
            } else {
                break
            }
        }
        return node
    }
    //Expansion
    func expandNode(node: Node, board: Board) {
        guard !node.untriedMoves.isEmpty else {
            return
        }
        let move = node.untriedMoves.removeLast()
        let newState = board.copy()
        newState.performMove(from: move.source, to: move.destination, player: currentPlayer)
        _ = node.addChild(move: move, state: newState)
    }
    
    //Simulation
    func simulateRandomPlayout(node: Node, board: Board) -> Int {
        let currentState = board.copy()
        var currentPlayer: CellState = node.player
        
        while !currentState.isGameOver() {
            //            let currentPlayerCells = getPlayerCells(player: currentPlayer, board: currentState)
            let moves = currentState.getLegalMoves(for: currentPlayer)
            guard !moves.isEmpty else {
                break
            }
            let randomMove = moves.randomElement()!
            currentState.performMove(from: randomMove.source, to: randomMove.destination, player: currentPlayer)
            currentPlayer = currentPlayer.opposite()
            
        }
        let (player1Count, player2Count, _) = currentState.countPieces()
        let result = player2Count - player1Count
        node.update(result: result)
        return result
        
        
    }
    
    
    
    //Propagation
    private func propagation(node: Node, result: Int) {
        var currentNode: Node? = node
        while let node = currentNode {
            node.update(result: result)
            currentNode = node.parent
        }
    }
    
    
    
    // Function to perform AI move using MCTS
    func performAIMoveForMCTS() {
        let currentPlayerCells = getPlayerCells(player: .player2, board: self)
        let rootNode = Node(move: Move(source: (-1, -1), destination: (-1, -1)), parent: nil, untriedMoves: getLegalMoves(for: currentPlayerCells.first!), player: .player2)
        let MCTSIterations = 550
        
        for _ in 0..<MCTSIterations {
            let promisingNode = selectPromisingNode(rootNode: rootNode)
            self.expandNode(node: promisingNode, board: self)
            let playoutResult = simulateRandomPlayout(node: promisingNode, board: self)
            self.propagation(node: promisingNode, result: playoutResult)
        }
        
        let bestChild = rootNode.children.max { $0.simulations < $1.simulations }
        DispatchQueue.main.async {
            if let move = bestChild?.move {
                self.performMove(from: move.source, to: move.destination, player: .player2)
                
            }
        }
    }
    
    func getRandomAdjacentCell(cell: (Int, Int)) -> (Int, Int)? {
        let directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
        var adjacentCells: [(Int, Int)] = []
        
        for direction in directions {
            let adjacentCell = (row: cell.0 + direction.0, col: cell.1 + direction.1)
            if isValidCoordinate(adjacentCell) && cellState(at: adjacentCell) == .empty {
                adjacentCells.append(adjacentCell)
            }
        }
        
        return adjacentCells.randomElement()
    }
    
    func getRandomCell() -> (Int, Int) {
        var emptyCells: [(Int, Int)] = []
        
        for row in 0..<size.rows {
            for col in 0..<size.columns {
                if cellState(at: (row, col)) == .empty {
                    emptyCells.append((row, col))
                }
            }
        }
        
        if let randomCell = emptyCells.randomElement() {
            return randomCell
        }
        
        // If no empty cells are found, return a default cell
        return (0, 0)
    }
    
    
    private func updateTurn() {
        turn += 1
    }
    
    func getPlayerCells(player: CellState) -> [(row: Int, col: Int)] {
        var cells: [(row: Int, col: Int)] = []
        for row in 0..<size.rows {
            for col in 0..<size.columns {
                if cellState(at: (row, col)) == player {
                    cells.append((row, col))
                }
            }
        }
        return cells
    }
    
    func getPlayerCells(player: CellState, board: Board) -> [(row: Int, col: Int)] {
        var cells: [(row: Int, col: Int)] = []
        for row in 0..<board.size.rows {
            for col in 0..<board.size.columns {
                if board.cellState(at: (row, col)) == player {
                    cells.append((row, col))
                }
            }
        }
        return cells
    }
    
    func getLegalMoves(for cells: [(row: Int, col: Int)], board: Board) -> [Move] {
        var moves: [Move] = []
        
        // The directions a cell can move to for duplication (orthogonal and diagonal)
        let directions = [(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1), (1, -1), (-1, 1)]
        
        // The directions a cell can jump to (horizontal, vertical, and L-shaped)
        let jumpDirections = [(2, 0), (-2, 0), (0, 2), (0, -2), (2, 1), (-2, -1), (1, 2), (-1, -2),
                              (-2, 1), (2, -1), (-1, 2), (1, -2)]
        
        for cell in cells {
            // Check each direction for duplication.
            for direction in directions {
                let adjacentCell = (row: cell.row + direction.0, col: cell.col + direction.1)
                if board.isValidCoordinate(adjacentCell) && board.cellState(at: adjacentCell) == .empty {
                    moves.append(Move(source: cell, destination: adjacentCell))
                }
            }
            
            // Check each direction for jumping.
            for direction in jumpDirections {
                let jumpCell = (row: cell.row + direction.0, col: cell.col + direction.1)
                if board.isValidCoordinate(jumpCell) && board.cellState(at: jumpCell) == .empty {
                    moves.append(Move(source: cell, destination: jumpCell))
                }
            }
        }
        
        return moves
    }
}



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
