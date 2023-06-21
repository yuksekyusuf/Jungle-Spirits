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
}


class Board: ObservableObject {
    @Published private(set) var cells: [[CellState]]
    let size: (rows: Int, columns: Int)
    
    var gameType: GameType
    
    
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
        notifyChange()
    }
    
    func cellState(at position: (row: Int, col: Int)) -> CellState {
        return cells[position.row][position.col]
    }
    
    private func isValidCoordinate(_ coordinate: (row: Int, col: Int)) -> Bool {
        return coordinate.row >= 0 && coordinate.row < size.rows && coordinate.col >= 0 && coordinate.col < size.columns
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
        if (rowDifference == 1 && colDifference == 2) || (rowDifference == 2 && colDifference == 1) {
                return true
            }
        return false
    }
    
    func performMove(from source: (row: Int, col: Int), to destination: (row: Int, col: Int), player: CellState) {
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
        
        convertOpponentPieces(at: destination, player: player)


    }


    func convertOpponentPieces(at destination: (row: Int, col: Int), player: CellState) {
        let opponent: CellState = player == .player1 ? .player2 : .player1
        
        for drow in -1...1 {
            for dcol in -1...1 {
                if drow == 0 && dcol == 0 {
                    continue
                }
                
                let newRow = destination.row + drow
                let newCol = destination.col + dcol
                
                if isValidCoordinate((row: newRow, col: newCol)) && cells[newRow][newCol] == opponent {
                    cells[newRow][newCol] = player
                }
            }
        }
        
    }
    
    func isGameOver() -> Bool {
        
        let (player1Count, player2Count, _) = countPieces()
        if player1Count == 0 || player2Count == 0 {
            return true
        }
        return !(hasLegalMoves(player: .player1) || hasLegalMoves(player: .player2))
    }
    
    
    func hasLegalMoves(player: CellState) -> Bool {
        for row in 0..<size.rows {
            for col in 0..<size.columns {
                if cells[row][col] == player {
                    let source = (row: row, col: col)
                    if hasAnyLegalMove(from: source) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func hasAnyLegalMove(from source: (row: Int, col: Int)) -> Bool {
        for drow in [-2, -1, 0, 1, 2] {
            for dcol in [-2, -1, 0, 1, 2] {
                let newRow = source.row + drow
                let newCol = source.col + dcol
                if isValidCoordinate((row: newRow, col: newCol)) && cells[newRow][newCol] == .empty {
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


extension Board {
    
    
    func performAIMove() -> Move? {
        let aiPlayer: CellState = .player2
            guard let move = getBestMove(for: aiPlayer) else {
                print("No valid move found for AI player.")
                // No move found, return nil
                return nil
            }
            
            // Perform the move and return the move
            performMove(from: move.source, to: move.destination, player: aiPlayer)

            print("AI moved from \(move.source) to \(move.destination)")
            print("Current game board state: \(cells)") // If 'cells' is the game board

            return move
    }
    
    func getBestMove(for player: CellState) -> Move? {
        var bestMove: Move? = nil
        var maxCapture: Int = -1

        for row in 0..<size.rows {
            for col in 0..<size.columns {
                let source = (row: row, col: col)
                if cellState(at: source) == player {
                    for dx in -2...2 {
                        for dy in -2...2 {
                            let destination = (row: row + dx, col: col + dy)
                            if isLegalMove(from: source, to: destination, player: player) {
                                let captured = cellsToCapture(from: source, to: destination, player: player)
                                if captured.count > maxCapture {
                                    bestMove = Move(source: source, destination: destination)
                                    maxCapture = captured.count
                                }
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
    
    private func generateAIMoves() -> [Move] {
        var moves: [Move] = []

        for row in 0..<size.rows {
            for col in 0..<size.columns {
                let source = (row: row, col: col)

                if cellState(at: source) == .player2 {
                    for dr in -2...2 {
                        for dc in -2...2 {
                            let destination = (row: row + dr, col: col + dc)
                            if isValidCoordinate(destination) && (cells[destination.row][destination.col] == .empty || cells[destination.row][destination.col] == .player1) && isLegalMove(from: source, to: destination, player: .player2){
                                moves.append(Move(source: source, destination: destination))
                            }
                        }
                    }
                }
            }
        }
        return moves
    }
    
    private func chooseAIMove(from moves: [Move]) -> Move {
        var bestMove: Move? = nil
        var bestScore = Int.min

        for move in moves {
            var tempBoard = Board(cells: self.cells.map { $0 }, gameType: .ai)
                tempBoard.performMove(from: move.source, to: move.destination, player: .player2)

                let scoreBeforeMove = minimax(board: tempBoard, depth: 3, alpha: Int.min, beta: Int.max, maximizingPlayer: false)

                // Determine score after move
                tempBoard.convertOpponentPieces(at: move.destination, player: .player2)
                let scoreAfterMove = minimax(board: tempBoard, depth: 3, alpha: Int.min, beta: Int.max, maximizingPlayer: false)

                // Use the change in score as the actual score for this move
                let score = scoreAfterMove - scoreBeforeMove

                if score > bestScore {
                    bestScore = score
                    bestMove = move
                }
            }
        return bestMove ?? moves.randomElement()!
    }


    private func couldBeCaptured(next: (row: Int, col: Int), player: CellState) -> Bool{
        for dr in -1...1 {
            for dc in -1...1 {
                let opponentPos = (row: next.row + dr, col: next.col + dc)
                if isValidCoordinate(opponentPos) && cells[opponentPos.row][opponentPos.col] == (player == .player1 ? .player2 : .player1) {
                    return true
                }
            }
        }
        return false
    }

    
    private func minimax(board: Board, depth: Int, alpha: Int, beta: Int, maximizingPlayer: Bool) -> Int {
        if depth == 0 || board.isGameOver() {
            let (player1Count, player2Count, _) = board.countPieces()
            return maximizingPlayer ? player2Count - player1Count : player1Count - player2Count
        }

        if maximizingPlayer {
            var maxEval = Int.min
            var alpha = alpha
            let possibleMoves = board.generateAIMoves()

            for move in possibleMoves {
                let newBoard = board.copy()
                newBoard.performMove(from: move.source, to: move.destination, player: .player2)
                let eval = minimax(board: newBoard, depth: depth - 1, alpha: alpha, beta: beta, maximizingPlayer: false)
                maxEval = max(maxEval, eval)
                alpha = max(alpha, eval)
                if beta <= alpha {
                    break
                }
            }
            return maxEval
        } else {
            var minEval = Int.max
            var beta = beta
            let possibleMoves = board.generateAIMoves()

            for move in possibleMoves {
                let newBoard = board.copy()
                newBoard.performMove(from: move.source, to: move.destination, player: .player1)
                let eval = minimax(board: newBoard, depth: depth - 1, alpha: alpha, beta: beta, maximizingPlayer: true)
                minEval = min(minEval, eval)
                beta = min(beta, eval)
                if beta <= alpha {
                    break
                }
            }
            return minEval
        }
    }
    
    
//    private func getBestMove() -> (row: Int, col: Int)? {
//        let aiPlayer: CellState = .player2
//        var bestCell: [(row: Int, col: Int)] = []
//        var bestScore = -9999
//
//        // Iterate through all the cells.
//        for row in 0..<size.rows {
//            for col in 0..<size.columns {
//                let cell = (row: row, col: col)
//                if board.cellState(at: cell) != .empty && cellState(at: cell) != aiPlayer {
//                    continue
//                }
//
//                var cellsToCapture = cellsToCapture(from: cell, player: aiPlayer)
//
//                // Calculate score based on the cells to be captured.
//                var score = cellsToCapture.count * 10
//
//                // Add a penalty if the cell is adjacent to an opponent's cell.
//                for drow in -1...1 {
//                    for dcol in -1...1 {
//                        let adjacentCell = (row: row + drow, col: col + dcol)
//                        if cellState(at: adjacentCell) == .player1 {
//                            score -= 5
//                        }
//                    }
//                }
//
//                // Update the best cell if the score is higher than the current best score.
//                if score > bestScore {
//                    bestScore = score
//                    bestCell = [cell]
//                } else if score == bestScore {
//                    bestCell.append(cell)
//                }
//            }
//        }
//
//        if bestCell.isEmpty {
//            return nil
//        }
//
//        // Select a cell from the best cells.
//        return bestCell.randomElement()
//    }

}

