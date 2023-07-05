////
////  NewBoard.swift
////  Temple Beasts
////
////  Created by Ahmet Yusuf Yuksek on 5.07.2023.
////
//
//import SwiftUI
//import Combine
//
//class NewBoard: ObservableObject {
//    @Published var cells: [[CellState]]
//
//    let size: (rows: Int, columns: Int)
//
//    init(size: (rows: Int, columns: Int)) {
//        self.size = size
//        cells = Array(repeating: Array(repeating: .empty, count: size.columns), count: size.rows)
//    }
//
//
//
//
//
//
//    func cellState(at position: (row: Int, col: Int)) -> CellState {
//        return cells[position.row][position.col]
//    }
//
//    func setCellState(to state: CellState, at position: (row: Int, col: Int)) {
//        cells[position.row][position.col] = state
//    }
//    func isValidMove(to position: (row: Int, col: Int)) -> Bool {
//        return cells[position.row][position.col] == .empty
//    }
//
//    func performMove(to position: (row: Int, col: Int), forPlayer player: CellState) -> Bool {
//        if isValidMove(to: position) {
//            setCellState(to: player, at: position)
//            return true
//        }
//        return false
//    }
//
//
//    func isLegalMove(from source: (row: Int, col: Int), to destination: (row: Int, col: Int), player: CellState) -> Bool {
//            let isCorner = (destination.row == 0 && destination.col == 0) ||
//                           (destination.row == 0 && destination.col == size.columns - 1) ||
//                           (destination.row == size.rows - 1 && destination.col == 0) ||
//                           (destination.row == size.rows - 1 && destination.col == size.columns - 1)
//            if !isValidCoordinate(source) || !isValidCoordinate(destination) {
//                return false
//            }
//            guard cellState(at: source) == player else {
//                return false
//            }
//            guard cellState(at: destination) == .empty else {
//                return false
//            }
//            let rowDifference = abs(destination.row - source.row)
//            let colDifference = abs(destination.col - source.col)
//
//            if rowDifference <= 1 && colDifference <= 1 {
//                return true
//            }
//            // Check for a jump move of 2 steps, horizontal or vertical (not diagonal)
//            if (rowDifference == 2 && colDifference == 0) || (rowDifference == 0 && colDifference == 2) {
//                return true
//            }
//            // Check for an L-shaped jump
//            if (rowDifference == 1 && colDifference == 2) || (rowDifference == 2 && colDifference == 1) {
//                return true
//            }
//            return false
//        }
//
//
//    func convertOpponentPieces(at destination: (row: Int, col: Int), player: CellState) -> Int? {
//           let opponent: CellState = player == .player1 ? .player2 : .player1
//
//           var convertedPieceCount = 0
//
//           for drow in -1...1 {
//               for dcol in -1...1 {
//                   if drow == 0 && dcol == 0 {
//                       continue
//                   }
//
//                   let newRow = destination.row + drow
//                   let newCol = destination.col + dcol
//
//                   if isValidCoordinate((row: newRow, col: newCol)) && cells[newRow][newCol] == opponent {
//                       cells[newRow][newCol] = player
//                       convertedPieceCount += 1
//                   }
//               }
//           }
//
//           return convertedPieceCount
//       }
//
//}
//
//
//
//class NewPlayer {
//    let cellState: CellState
//    let isAI: Bool
//
//    init(cellState: CellState, isAI: Bool = false) {
//        self.cellState = cellState
//        self.isAI = isAI
//    }
//}
//
////class GameEngine {
////    private var players: [NewPlayer]
////    @Published private(set) var board: NewBoard
////    var currentPlayerIndex = 0
////    var gameType: GameType
////    var isGameOver: Bool {
////        return NewBoard.isGameOver()
////    }
////}
