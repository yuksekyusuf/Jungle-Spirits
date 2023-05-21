//
//  Game.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/5/23.
//

import Foundation

enum CellState: Int {
    case empty = 0
    case player1 = 1
    case player2 = 2
}


class Board: ObservableObject {
    @Published private(set) var cells: [[CellState]]
    let size: (rows: Int, columns: Int)

    
    init(size: (rows: Int, columns: Int)) {
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
        return (rowDifference <= 1 && colDifference <= 1) || (rowDifference <= 2 && colDifference <= 2)
    }
    
    
    func performMove(from source: (row: Int, col: Int), to destination: (row: Int, col: Int), player: CellState) {
        guard isLegalMove(from: source, to: destination, player: player) else {
            return
        }
        let rowDifference = abs(destination.row - source.row)
        let colDifference = abs(destination.col - source.row)
        if rowDifference == 2 || colDifference == 2 {
            cells[source.row][source.col] = .empty
        }
        
        cells[destination.row][destination.col] = player
        
        convertOpponentPieces(at: destination, player: player)
        notifyChange()
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
    
    
    
//    func isGameOver() -> Bool {
//        for row in 0..<size {
//            for col in 0..<size {
//                let coordinate = (row: row, col: col)
//                if grid[row][col] == .player1 || grid[row][col] == .player2 {
//                    let player = grid[row][col]
//                    if hasLegalMoves(from: coordinate, player: player) {
//                        return false
//                    }
//                }
//            }
//        }
//        return true
//    }
    
//    private func hasLegalMoves(from source: (row: Int, col: Int), player: CellState) -> Bool{
//        for row in max(source.row - 2, 0)..<min(source.row + 3, size) {
//            for col in max(source.col - 2, 0)..<min(source.col + 3, size) {
//                let destination = (row: row, col: col)
//                if isLegalMove(from: source, to: destination, player: player) {
//                    return true
//                }
//            }
//        }
//        return false
//    }
    
    private func hasLegalMoves(player: CellState) -> Bool {
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

