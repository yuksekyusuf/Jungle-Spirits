//
//  GameView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/10/23.
//

import SwiftUI
import PopupView




struct GameView: View {
    @StateObject private var board: Board
    init(gameType: GameType) {
        _gameType = State(initialValue: gameType)
        _board = StateObject(wrappedValue: Board(size: (8, 5), gameType: gameType))
        _showPauseMenu = State(initialValue: false)
        _isPaused = State(initialValue: false)
        _remainingTime = State(initialValue: 100)
        _currentPlayer = State(initialValue: .player1)
        _isGameOver = State(initialValue: false)
        _selectedCell = State(initialValue: nil)
    }
    
    @State private var showPauseMenu: Bool
    @State private var isPaused: Bool
    @State private var remainingTime: Int
    @State var currentPlayer: CellState
    @State private var isGameOver: Bool
    @State var selectedCell: (row: Int, col: Int)?
    @State var gameType: GameType
    
    
    let cellSize: CGFloat = 40
    
    
    private var player1PieceCount: Int {
        board.countPieces().player1
    }
    
    private var player2PieceCount: Int {
        board.countPieces().player2
    }
    
    var body: some View {
        ZStack {
            
            ZStack {
                
                
                VStack {
                    BoardView(board: board, selectedCell: $selectedCell, currentPlayer: $currentPlayer, onMoveCompleted: onMoveCompleted, gameType: gameType)
                        .offset(y: 28)
                        .allowsHitTesting(!showPauseMenu)
                    
                }
                .overlay {
                    Image("Lights")
                        .blendMode(.overlay)
                        .allowsHitTesting(false)
                    Image("Shadow")
                        .opacity(0.80)
                        .blendMode(.overlay)
                        .allowsHitTesting(false)
                }
                Image("backgroundImage")
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                
                
                
                VStack {
                    HStack {
                        HStack {
                            Image(currentPlayer == .player1 ? "Red Eye Open" : "Red Eye Closed")
                                .frame(width: 55)
                                .padding(.leading, 20)
                            
                            PieceCountView(pieceCount: player1PieceCount)
                            
                        }
                        Spacer()
                        Button(action:  {
                                isPaused.toggle()
                                showPauseMenu.toggle()
                        })
                        {
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
                            PieceCountView(pieceCount: player2PieceCount)
                            Image(currentPlayer == .player2 ? "Blue Eye Open" : "Blue Eye Closed")
                                .frame(width: 55)
                                .padding(.trailing, 20)
                        }
                    }
                    .padding(.top, 35)
                    TimeBarView(remainingTime: remainingTime, totalTime: 100)
                        .padding(.horizontal)
                        .padding(.trailing)
                }
                if showPauseMenu {
                    PauseMenuView(showPauseMenu: $showPauseMenu, isPaused: $isPaused)
                        .transition(.opacity.animation(.easeIn))
                    
                }
                
            }
        }
        .background {
            Color("background")
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
    
    
    func onMoveCompleted() {
        if self.board.isGameOver() {
            self.isGameOver = true
            return
        }

        if gameType == .ai && currentPlayer == .player2 && board.hasLegalMoves(player: .player2) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let _ = self.board.performAIMove() {
                    self.currentPlayer = .player1
                }
            }
        }
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameType: .oneVone)
    }
}






//                .popup(isPresented: $showPauseMenu) {
//                    PauseMenuView(showPauseMenu: $showPauseMenu
//    //                              , activeView: $activeView
//                    )
//    //                        .padding(.top, 100)
//                        .offset(y: UIScreen.main.bounds.height/2.5)
//                } customize: {
//                    $0.type(.floater())
//                        .position(.top)
//                        .animation(.spring())
//                        .closeOnTapOutside(true)
//                        .backgroundColor(.black.opacity(0.5))
//                }



//            }


//            .overlay {
//                Image("Shadow")
//                    .blendMode(.multiply)
//                    .allowsHitTesting(false)
//            }
