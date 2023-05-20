//
//  BoardView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/10/23.
//

import SwiftUI

struct BoardView: View {
    @ObservedObject var board: Board
    @State private var selectedCell: (row: Int, col: Int)?
    @State var currentPlayer: CellState
    var onMoveCompleted: (()->Void)?
    
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
                                handleTap(row: row, col: col)
                            }
                        }
                    }
                    
                }
            }
            //            .frame(width: geo.size.width, height: geo.size.height)
            //            .frame(width: cellSize * CGFloat(board.size.columns), height: cellSize * CGFloat(board.size.rows))
            
            
//        }
    }
    
    private func handleTap(row: Int, col: Int) {
        if let selected = selectedCell {
            if board.isLegalMove(from: selected, to: (row: row, col: col), player: currentPlayer) {
                board.performMove(from: selected, to: (row: row, col: col), player: currentPlayer)
                onMoveCompleted?()
                currentPlayer = currentPlayer == .player1 ? .player2 : .player1
                selectedCell = nil
            } else {
                selectedCell = board.cellState(at: (row: row, col: col)) == currentPlayer ? (row: row, col: col) : nil
            }
        } else {
            if board.cellState(at: (row: row, col: col)) == currentPlayer {
                selectedCell = (row: row, col: col)
            }
        }
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



struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(board: Board(size: (rows: 8, columns: 5)), currentPlayer: .player1)
    }
}
