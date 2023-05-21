//
//  GameView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/10/23.
//

import SwiftUI

struct GameView: View {
    @StateObject private var board = Board(size: (8, 5))
    
    @State private var showPauseMenu = false
    @State private var isPaused = false
    @State private var remainingTime = 100
    @State var currentPlayer: CellState = .player1
    @State private var isGameOver: Bool = false
    let cellSize: CGFloat = 40
    
    
    private var player1PieceCount: Int {
        board.countPieces().player1
    }
    
    private var player2PieceCount: Int {
        board.countPieces().player2
    }
    var body: some View {
        
        
        
        ZStack {
            Image("backgroundImage")
                .ignoresSafeArea()
            VStack {
                
                HStack {
                    
                    HStack {
                        
                        Image(currentPlayer == .player1 ? "Red Eye Open" : "Red Eye Closed")
                            .frame(width: 55)
                            .padding(.leading, 20)
                        
                        Text("\(player1PieceCount)")
                            .font(.system(size: 30, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(#colorLiteral(red: 0.93, green: 0.93, blue: 1, alpha: 1)))
                            .tracking(0.9)
                            .multilineTextAlignment(.center)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius:0, x:0, y:2)
                        
                    }
                    Spacer()
                    
                    Button(action:  {
                        isPaused.toggle()
                        showPauseMenu.toggle()
                        
                    }) {
                        HStack {
                            Image("Pause button")
                                .frame(width: 69, height: 40)
                        }
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    Spacer()
                    
                    HStack {
                        Text("\(player2PieceCount)")
                            .font(.system(size: 30, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(#colorLiteral(red: 0.93, green: 0.93, blue: 1, alpha: 1)))
                            .tracking(0.9)
                            .multilineTextAlignment(.center)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius:0, x:0, y:2)
                        
                        
                        Image(currentPlayer == .player2 ? "Blue Eye Open" : "Blue Eye Closed")
                            .frame(width: 55)
                            .padding(.trailing, 20)
                    }
                }
                .padding(.top, 35)
                TimeBar(remainingTime: remainingTime, totalTime: 100)
                    .padding(.horizontal)
                    .padding(.trailing)
                BoardView(board: board, currentPlayer: currentPlayer, onMoveCompleted: {
                    self.currentPlayer = (self.currentPlayer == .player1) ? .player2 : .player1
                })
                .padding(.bottom, 102)
                
            }
            
            PauseMenuView(showPauseMenu: $showPauseMenu)
                .padding(.top, 100)
                .offset(y: showPauseMenu ? 0 : UIScreen.main.bounds.height)
                        
        }
        .navigationBarHidden(true)
        .alert(isPresented: $isGameOver) {
            Alert(title: Text("Game Over"),
                  message: Text(winnerMessage),
                  dismissButton: .default(Text("Restart")) {
                board.reset()
                currentPlayer = .player1
            }
            )
        }

        .onChange(of: board.cells) { newValue in
            if board.isGameOver() {
                isGameOver = true
            }
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
    
    
    var winnerMessage: String {
        let (player1Count, player2Count, _) = board.countPieces()
        if player1Count == player2Count {
            return "The game is a draw"
        } else if player1Count > player2Count {
            return "Player 1 wins!"
        } else {
            return "Player 2 wins!"
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
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.black)
                    .cornerRadius(24)
                    .frame(width: 360, height: 24)
                
                Capsule()
                    .fill(LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(#colorLiteral(red: 1, green: 0.45366665720939636, blue: 0.3791666626930237, alpha: 1)), location: 0),
                            .init(color: Color(#colorLiteral(red: 1, green: 0.2078431397676468, blue: 0.3490196168422699, alpha: 1)), location: 0.5104166865348816),
                            .init(color: Color(#colorLiteral(red: 0.5583333373069763, green: 0, blue: 0.1675001084804535, alpha: 1)), location: 1)]),
                        startPoint: UnitPoint(x: 1.001960580351438, y: 0.4999984904828132),
                        endPoint: UnitPoint(x: 0.001960653828999348, y: 0.4999989975336838)))
                    .frame(width: width, height: 20)
                    .innerShadow(5, opacity: 0.8, x: 2, y: 2)
                    .padding(.leading, 4)
                
            }
        }
        
    }
}
