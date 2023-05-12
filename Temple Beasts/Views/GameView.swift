//
//  GameView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/10/23.
//

import SwiftUI

struct GameView: View {
    @StateObject private var board = Board(size: 7)
    private let cellSize: CGFloat = 40
    var body: some View {
        BoardView(board: board, cellSize: cellSize)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
