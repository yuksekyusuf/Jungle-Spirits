//
//  GameView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/10/23.
//

import SwiftUI

struct GameView: View {
    @StateObject private var board = Board(size: 7)
    @State private var isPaused = false
    @State private var remainingTime = 100
    
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
                
                HStack {
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 20)
                        .padding(.leading, 50)
                    
                    Text("\(player1PieceCount)")
                        .font(.headline)
                }
                Spacer()
                
                Button(action:  {
                    isPaused.toggle()
                }) {
                    HStack {
                        Image(systemName: isPaused ? "play" : "pause")
//                        Text(isPaused ? "Play" : "Pause")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                Spacer()
                
                HStack {
                    Text("\(player2PieceCount)")
                        .font(.headline)
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20)
                        .padding(.trailing, 50)
                }
            }
            .padding(.top)
            TimeBar(remainingTime: remainingTime, totalTime: 100)
                .padding(.horizontal)
                .padding()
            BoardView(board: board, cellSize: cellSize)
            
            
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if !isPaused && remainingTime > 0 {
                    remainingTime -= 1
                } else if remainingTime == 0 {
                    timer.invalidate()
                }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct TimeBar: View {
    var remainingTime: Int
    var totalTime: Int
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width * CGFloat(remainingTime) / CGFloat (totalTime)
            RoundedRectangle(cornerRadius: 3)
                .frame(width: width, height: 13)
                .foregroundColor(.blue)
        }
        .frame(height: 10)
    }
}
