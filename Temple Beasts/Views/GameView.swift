//
//  GameView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/10/23.
//

import SwiftUI

struct GameView: View {
    @StateObject private var board: Board
    init(gameType: GameType) {
        _gameType = State(initialValue: gameType)
        _board = StateObject(wrappedValue: Board(size: (8, 5), gameType: gameType))
        _showPauseMenu = State(initialValue: false)
        _showWinMenu = State(initialValue: false)
        _isPaused = State(initialValue: false)
        _remainingTime = State(initialValue: 15)
        _currentPlayer = State(initialValue: .player1)
        _isGameOver = State(initialValue: false)
        _selectedCell = State(initialValue: nil)
        _isCountDownVisible = State(initialValue: true)
        
    }
    
    
    @State private var isCountDownVisible: Bool
    @State private var showPauseMenu: Bool
    @State private var showWinMenu: Bool
    @State private var isPaused: Bool
    @State private var remainingTime: Int
    @State var currentPlayer: CellState
    @State private var isGameOver: Bool
    @State var selectedCell: (row: Int, col: Int)?
    @State var gameType: GameType
    @EnvironmentObject var menuViewModel: MenuViewModel
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
                Image("backgroundImage").resizable()
                    .ignoresSafeArea()
                VStack(spacing: 0) {
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
                        Spacer()
                        HStack {
                            PieceCountView(pieceCount: player2PieceCount)
                            Image(currentPlayer == .player2 ? "Blue Eye Open" : "Blue Eye Closed")
                                .frame(width: 55)
                                .padding(.trailing, 20)
                        }
                    }
                    HStack {
                        TimeBarView(remainingTime: remainingTime, totalTime: 15, currentPlayer: currentPlayer)
                            .padding([.horizontal, .trailing], 5)
                            .animation(.linear(duration: 1.0), value: remainingTime)
                    }
                    BoardView(board: board, selectedCell: $selectedCell, currentPlayer: $currentPlayer, onMoveCompleted: onMoveCompleted, gameType: gameType)
                        .allowsHitTesting(!showPauseMenu)
                        .overlay {
                            Image("Lights")
                                .blendMode(.overlay)
                                .allowsHitTesting(false)
                            Image("Shadow")
                                .opacity(0.80)
                                .blendMode(.overlay)
                                .allowsHitTesting(false)
                        }
                }
                Image("randomLights")
                    .resizable()
                    .scaledToFit()
                    .allowsHitTesting(false)
                if showPauseMenu {
                    PauseMenuView(showPauseMenu: $showPauseMenu, isPaused: $isPaused, remainingTime: $remainingTime, currentPlayer: $currentPlayer)
                        .animation(Animation.easeInOut, value: showPauseMenu)
                }
                
                if isGameOver {
                    WinView(showWinMenu: $isGameOver, isPaused: $isPaused, remainingTime: $remainingTime, winner: winner, currentPlayer: $currentPlayer)
                }
                if isCountDownVisible {
                    CountDownView(isVisible: $isCountDownVisible)
                }
                
            }
            VStack {
                Spacer()
                if UIScreen.main.bounds.height <= 667 {
                    Image("Bottom")
                        .resizable()
                        .scaledToFit()
                        .edgesIgnoringSafeArea(.bottom)
                        .allowsHitTesting(false)
                        .offset(y: 65)
                } else {
                    Image("Bottom")
                        .resizable()
                        .scaledToFit()
                        .allowsHitTesting(false)
                        .edgesIgnoringSafeArea(.bottom)
                }
            }
            .frame(height: UIScreen.main.bounds.height * 1)
        }
        .navigationBarHidden(true)
        .onChange(of: board.cells) { newValue in
            if board.isGameOver() {
                isGameOver = true
                self.isPaused.toggle()
            }
        }
        .onChange(of: remainingTime, perform: { newValue in
            if newValue == 0 && gameType == .oneVone{
                switchPlayer()
                remainingTime = 15
            }
            else if newValue == 0 && gameType == .ai {
                remainingTime = 15
                switchPlayer()
                DispatchQueue.global().async {
                    self.board.performMTSCMove()
                    print("after ai performs, current player: ", currentPlayer)
                    DispatchQueue.main.async {
                        self.currentPlayer = .player1
                        self.remainingTime = 15
                    }
                }
                self.remainingTime = 15
            }
        })
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if !isPaused && remainingTime > 0 && !isCountDownVisible {
                    remainingTime -= 1
                }
            }
        }
        .environmentObject(board)
    }
    var winner: CellState {
        let (player1Count, player2Count, _) = board.countPieces()
        if player1Count > player2Count {
            return .player1
        } else if player2Count > player1Count {
            return .player2
        }
        else {
            return .draw
        }
    }
    func onMoveCompleted() {
        if self.board.isGameOver() {
            self.isGameOver = true
            return
        }
        currentPlayer = currentPlayer == .player1 ? .player2 : .player1
        remainingTime = 15
        if !board.hasLegalMoves(player: .player1) || !board.hasLegalMoves(player: .player2) {
            self.isGameOver = true
            self.isPaused.toggle()
        } else if gameType == .ai && currentPlayer == .player2 {
            DispatchQueue.global().async {
                self.board.performMTSCMove()
                print("after ai performs, current player: ", currentPlayer)
                DispatchQueue.main.async {
                    self.currentPlayer = .player1
                    self.remainingTime = 15
                    SoundManager.shared.playMoveSound()
                }
            }
            self.remainingTime = 15
        } else {
            SoundManager.shared.playMoveSound()
        }
    }
    func switchPlayer() {
        currentPlayer = (currentPlayer == .player1) ? .player2 : .player1
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameType: .oneVone)
    }
}





