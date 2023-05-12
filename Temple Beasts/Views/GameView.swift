//
//  GameView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/10/23.
//

import SwiftUI

struct GameView: View {
    @StateObject private var board = Board(size: 7)
    
    private var player1PieceCount: Int {
        board.countPieces().player1
    }
    
    private var player2PieceCount: Int {
        board.countPieces().player2
    }
    private let cellSize: CGFloat = 40
    var body: some View {
        VStack {
            HStack {
                Text("Player 1")
                    .font(.headline)
                    .padding(.leading)
                Spacer()
                Text("\(player1PieceCount)")
            }
            .padding(.top)
            BoardView(board: board, cellSize: cellSize)
            
            HStack {
                Text("Player 2")
                    .font(.headline)
                    .padding(.leading)
                Spacer()
                Text("\(player2PieceCount)")
                    .font(.headline)
                    .padding(.trailing)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
