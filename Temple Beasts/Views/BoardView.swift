//
//  BoardView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/10/23.
//

import SwiftUI

struct BoardView: View {
    @EnvironmentObject var board: Board
    @EnvironmentObject var gameCenterController: GameCenterManager
//    @Binding var selectedCell: (row: Int, col: Int)?
    @Binding var currentPlayer: CellState
    @State private var currentlyPressedCell: (row: Int, col: Int)? = nil
    @State private var moveMade: Bool = false

    let onMoveCompleted: (Move) -> Void
    let gameType: GameType
    
    func isCellPressed(row: Int, col: Int) -> Bool {
        if let pressedCell = currentlyPressedCell, pressedCell == (row, col) {
            return true
        }
        return false
    }
    
        var body: some View {
        VStack(spacing: 1) {
            ForEach(0..<board.size.rows, id: \.self) { row in
                HStack(spacing: 1) {
                    ForEach(0..<board.size.columns, id: \.self) { col in
                        CellView(
                            state: board.cellState(at: (row: row, col: col)),
                            isSelected: gameCenterController.isSelected && gameCenterController.selectedCell != nil && gameCenterController.selectedCell! == (row: row, col: col),
                            highlighted: gameCenterController.selectedCell != nil && isAdjacentToSelectedCell(row: row, col: col),
                            outerHighlighted: gameCenterController.selectedCell != nil && isOuterToSelectedCell(row: row, col: col),
                            isPressed: isCellPressed(row: row, col: col),
                            convertedCells: $gameCenterController.convertedCells,
                            previouslyConvertedCells: $gameCenterController.previouslyConvertedCells,
                            cellPosition: (row: row, col: col), moveMade: $moveMade
                        )
                        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                            if pressing {
                                self.currentlyPressedCell = (row, col)
                            } else {
                                self.handleTap(from: gameCenterController.selectedCell, to: (row: row, col: col))
                                HapticManager.shared.impact(style: .soft)
                                self.currentlyPressedCell = nil
                            }
                        }, perform: { })

                    }
                }
            }
        }
    }

    private func handleTap(from source: (row: Int, col: Int)?, to destination: (row: Int, col: Int)) {
        if currentPlayer == .player2 && gameType == .ai {
            return
        }
        // Ignore tap if it's not the local player's turn
        if !gameCenterController.currentlyPlaying && gameType == .multiplayer {
            return
        }
        
        // If the destination cell is the currently selected cell, unselect it.
        if let source = gameCenterController.selectedCell, source == destination {
            gameCenterController.isSelected = false
            gameCenterController.selectedCell = nil
            return
        }
        
        guard let source = gameCenterController.selectedCell else {
            if board.cellState(at: destination) == currentPlayer {
                gameCenterController.isSelected = true
                gameCenterController.selectedCell = destination
            }
            return
        }
        
        if board.isLegalMove(from: source, to: destination, player: currentPlayer) {
            self.moveMade.toggle()
            
            let convertedPieces = board.performMove(from: source, to: destination, player: currentPlayer)
            if !convertedPieces.isEmpty {
                SoundManager.shared.playConvertSound()
                HapticManager.shared.notification(type: .success)
                for piece in convertedPieces {
                    self.gameCenterController.convertedCells.append((row: piece.row, col: piece.col, byPlayer: currentPlayer))
                    self.gameCenterController.previouslyConvertedCells.append((row: piece.row, col: piece.col, byPlayer: currentPlayer))
                }
            }
            gameCenterController.isSelected = false
            gameCenterController.selectedCell = nil
            let move = Move(source: source, destination: destination)
            onMoveCompleted(move)
        } else if board.cellState(at: destination) == currentPlayer {
            gameCenterController.selectedCell = destination
        }
    }
    private func isAdjacentToSelectedCell(row: Int, col: Int) -> Bool {
        guard let selected = gameCenterController.selectedCell else { return false }
        let deltaRow = abs(selected.row - row)
        let deltaCol = abs(selected.col - col)
        return (deltaRow <= 1 && deltaCol <= 1) && !(deltaRow == 0 && deltaCol == 0)
    }
    private func isOuterToSelectedCell(row: Int, col: Int) -> Bool {
        guard let selected = gameCenterController.selectedCell else { return false }
        let deltaRow = abs(selected.row - row)
        let deltaCol = abs(selected.col - col)

        if (deltaRow == 2 && deltaCol == 0) || (deltaRow == 0 && deltaCol == 2) {
            return true
        }
        if (deltaRow == 1 && deltaCol == 2) || (deltaRow == 2 && deltaCol == 1) {
             return true
        }
        return false
    }
}

// struct BoardView_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var selectedCell: (row: Int, col: Int)? = (row: 5, col: 5)
//        BoardView(board: Board(size: (rows: 8, columns: 5)), selectedCell: $selectedCell, currentPlayer: .player1) {
//
//        }
//    }
// }


