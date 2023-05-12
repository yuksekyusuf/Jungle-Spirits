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
    let size = 7
    @Published private(set) var grid: [[CellState]]
    
    var getPieceCount: (player1: Int, player2: Int) {
        return countPieces()
    }
    
    init(size: Int) {
        grid = Array(repeating: Array(repeating: .empty, count: size), count: size)
        grid[0][0] = .player1
        grid[size-1][0] = .player2
        grid[size-1][size-1] = .player1
        grid[0][size - 1] = .player2
    }
    private func setupInitialBoard() {
        grid[0][0] = .player1
        grid[size - 1][size - 1] = .player1
        grid[0][size - 1] = .player2
        grid[size - 1][0] = .player2
    }
    func cellState(at position: (row: Int, col: Int)) -> CellState {
        return grid[position.row][position.col]
    }
    
    func isLegalMove(from source: (row: Int, col: Int), to destination: (row: Int, col: Int), player: CellState) -> Bool {
        guard isValidCoordinate(source.row) && isValidCoordinate(source.col) && isValidCoordinate(destination.row) && isValidCoordinate(destination.col) else {
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
    private func isValidCoordinate(_ coordinate: Int) -> Bool {
        return coordinate >= 0 && coordinate < size
    }
    
    func performMove(from source: (row: Int, col: Int), to destination: (row: Int, col: Int), player: CellState) {
        guard isLegalMove(from: source, to: destination, player: player) else {
            return
        }
        let rowDifference = abs(destination.row - source.row)
        let colDifference = abs(destination.col - source.row)
        if rowDifference == 2 || colDifference == 2 {
            grid[source.row][source.col] = .empty
        }
        
        grid[destination.row][destination.col] = player
        
        convertOpponentPieces(at: destination, player: player)
    }
    
    func convertOpponentPieces(at destination: (row: Int, col: Int), player: CellState) {
        let opponent = player == .player1 ? CellState.player2 : CellState.player1
        let directions: [(Int, Int)] = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
        
        for (dRow, dCol) in directions {
            let newRow = destination.row + dRow
            let newCol = destination.col + dCol
            
            if isValidCoordinate(newRow) && isValidCoordinate(newCol) && cellState(at: (newRow, newCol)) == opponent {
                grid[newRow][newCol] = player
            }
        }
        
    }
    
    func isGameOver() -> Bool {
        for row in 0..<size {
            for col in 0..<size {
                let coordinate = (row: row, col: col)
                if grid[row][col] == .player1 || grid[row][col] == .player2 {
                    let player = grid[row][col]
                    if hasLegalMoves(from: coordinate, player: player) {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    private func hasLegalMoves(from source: (row: Int, col: Int), player: CellState) -> Bool{
        for row in max(source.row - 2, 0)..<min(source.row + 3, size) {
            for col in max(source.col - 2, 0)..<min(source.col + 3, size) {
                let destination = (row: row, col: col)
                if isLegalMove(from: source, to: destination, player: player) {
                    return true
                }
            }
        }
        return false
    }
    
    func countPieces() -> (player1: Int, player2: Int) {
        var player1Count = 0
        var player2Count = 0
        
        for row in 0..<size {
            for col in 0..<size {
                let cellState = grid[row][col]
                if cellState == .player1 {
                    player1Count += 1
                } else if cellState == .player2 {
                    player2Count += 1
                }
            }
            
        }
        return (player1Count, player2Count)
    }
   
}

