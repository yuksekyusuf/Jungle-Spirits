//
//  BoardView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/10/23.
//

import SwiftUI

struct BoardView: View {
    @ObservedObject var board: Board
    @Binding var selectedCell: (row: Int, col: Int)?
    @Binding var currentPlayer: CellState
    let onMoveCompleted: () -> Void
    
    //    let cellSize: CGFloat
    var body: some View {
//        GeometryReader { geo in
//            let screenHeight = geo.size.height
//            let cellSize = screenHeight * 0.8 / 8
            VStack(spacing: -7) {
                ForEach(0..<board.size.rows, id: \.self) { row in
                    HStack(spacing: 1) {
                        ForEach(0..<board.size.columns, id:\.self) { col in
                            CellView(
                                state: board.cellState(at: (row: row, col: col)),
                                size: 72,
                                isSelected: selectedCell != nil && selectedCell! == (row: row, col: col),
                                highlighted: selectedCell != nil && isAdjacentToSelectedCell(row: row, col: col),
                                outerHighlighted: selectedCell != nil && isOuterToSelectedCell(row: row, col: col)
                            )
                            .onTapGesture {
                                self.handleTap(from: selectedCell, to: (row: row, col: col))
//                                self.handleTap(row: row, col: col)
                            }
                        }
                    }
                    
                }
            }
            //            .frame(width: geo.size.width, height: geo.size.height)
            //            .frame(width: cellSize * CGFloat(board.size.columns), height: cellSize * CGFloat(board.size.rows))
            
            
//        }
    }
    
    private func handleTap(from source: (row: Int, col: Int)?, to destination: (row: Int, col: Int)) {
        guard let source = source else {
            selectedCell = destination
            return
        }
        
        if let selected = selectedCell {
            if board.isLegalMove(from: source, to: destination, player: currentPlayer) {
                board.performMove(from: source, to: destination, player: currentPlayer)
//                currentPlayer = .player2
                currentPlayer = .player2
                selectedCell = nil
                onMoveCompleted()

            } else {
                selectedCell = destination
            }
        }
//        else {
//            if board.cellState(at: (row: row, col: col)) == currentPlayer {
//                selectedCell = (row: row, col: col)
//            }
//        }
    }
    private func isAdjacentToSelectedCell(row: Int, col: Int) -> Bool {
        guard let selected = selectedCell else { return false }
        let deltaRow = abs(selected.row - row)
        let deltaCol = abs(selected.col - col)
        return (deltaRow <= 1 && deltaCol <= 1) && !(deltaRow == 0 && deltaCol == 0)
        
    }
    private func isOuterToSelectedCell(row: Int, col: Int) -> Bool {
        guard let selected = selectedCell else { return false }
        
        let deltaRow = abs(selected.row - row)
        let deltaCol = abs(selected.col - col)
        
        return (deltaRow <= 2 && deltaCol <= 2) && !(deltaRow <= 1 && deltaCol <= 1)
    }
    
}


//
//struct BoardView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardView(board: Board(size: (rows: 8, columns: 5)), currentPlayer: .player1)
//    }
//}
