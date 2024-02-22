//
//  TutorialVIew.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 21.02.2024.
//

import SwiftUI

struct TutorialView: View {
    @ObservedObject var board = Board(size: (5, 5), gameType: .tutorial, obstacles: [])
    @ObservedObject var gameCenterManager = GameCenterManager(currentPlayer: .player1)
    @State var selectedCell: (row: Int, col: Int)? = nil
    var body: some View {
        ZStack {
            
//            Text("Hello World")
            BoardView(selectedCell: $selectedCell, currentPlayer: $gameCenterManager.currentPlayer, rows: board.size.rows, cols: board.size.columns, cellSize: 20, onMoveCompleted: {move in onMoveCompleted(move: move)}, gameType: .tutorial)
            .frame(width: 500, height: 500)
        }
    }
    private func onMoveCompleted(move: Move) {
        print("Do sth")
    }
}

#Preview {
    TutorialView()
}
