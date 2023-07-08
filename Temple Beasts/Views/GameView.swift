//
//  GameView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/10/23.
//

import SwiftUI

struct GameView: View {
    @StateObject private var board: Board
    @EnvironmentObject var gameCenterController: GameCenterManager
    init(gameType: GameType) {
        _gameType = State(initialValue: gameType)
        _board = StateObject(wrappedValue: Board(size: (8, 5), gameType: gameType))
        _showPauseMenu = State(initialValue: false)
        _showWinMenu = State(initialValue: false)
        _remainingTime = State(initialValue: 15)
        _selectedCell = State(initialValue: nil)
        _isCountDownVisible = State(initialValue: true)
    }
    
    
    @State private var isCountDownVisible: Bool
    @State private var showPauseMenu: Bool
    @State private var showWinMenu: Bool
    @State private var remainingTime: Int
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
                        VStack {
                            HStack {
                                Image(gameCenterController.currentPlayer == .player1 ? "Red Eye Open" : "Red Eye Closed")
                                    .frame(width: 55)
                                    .padding(.leading, 20)
                                
                                PieceCountView(pieceCount: player1PieceCount)
                                
                                
                            }
                            
                            Text("\(gameCenterController.localPlayer.displayName)")
                                .foregroundColor(.white)
                            
                        }
                        
                        Spacer()
                        VStack {
                            Button(action:  {
                                configurePauseMenu()
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
                            Text("\(gameCenterController.currentPlayer.rawValue) is playin? \(gameCenterController.currentlyPlaying.description)")
                                .foregroundColor(.white)
                        }
                       
                        Spacer()
                        VStack {
                            HStack {
                                PieceCountView(pieceCount: player2PieceCount)
                                Image(gameCenterController.currentPlayer == .player2 ? "Blue Eye Open" : "Blue Eye Closed")
                                    .frame(width: 55)
                                    .padding(.trailing, 20)
                            }
                            
                            Text(gameCenterController.otherPlayer?.displayName ?? "")
                                .foregroundColor(.white)
                        }
                        
                    }
                    HStack {
                        TimeBarView(remainingTime: remainingTime, totalTime: 15, currentPlayer: gameCenterController.currentPlayer)
                            .padding([.horizontal, .trailing], 5)
                            .animation(.linear(duration: 1.0), value: remainingTime)
                    }
                    BoardView(selectedCell: $selectedCell, currentPlayer: $gameCenterController.currentPlayer, onMoveCompleted: {move in onMoveCompleted(move)}, gameType: gameType)
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
                    PauseMenuView(showPauseMenu: $showPauseMenu, isPaused: $gameCenterController.isPaused, remainingTime: $remainingTime, gameType: gameType, currentPlayer: $gameCenterController.currentPlayer)
                        .animation(Animation.easeInOut, value: showPauseMenu)
                }
                
                if gameCenterController.isGameOver {
                    WinView(showWinMenu: $gameCenterController.isGameOver, isPaused: $gameCenterController.isPaused, remainingTime: $remainingTime, winner: winner, currentPlayer: $gameCenterController.currentPlayer)
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
                gameCenterController.isGameOver = true
                self.gameCenterController.isPaused.toggle()
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
                    print("after ai performs, current player: ", gameCenterController.currentPlayer)
                    DispatchQueue.main.async {
                        self.gameCenterController.currentPlayer = .player1
                        self.remainingTime = 15
                    }
                }
                self.remainingTime = 15
            }
        })
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if !gameCenterController.isPaused && remainingTime > 0 && !isCountDownVisible {
                    remainingTime -= 1
                }
            }

        }
        .onAppear{
            gameCenterController.board = self.board
        }
        .environmentObject(board)
        .onDisappear{
            self.gameCenterController.isPaused = false
            self.gameCenterController.isGameOver = false
            self.gameCenterController.currentPlayer = .player1
        }
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
    func onMoveCompleted(_ move: Move) {
        if board.isGameOver() {
                self.gameCenterController.isGameOver = true
                return
            }
            
        if gameType == .multiplayer {
//            let codableMove = CodableMove.fromMove(move)
//            let moveMessage = GameMessage(messageType: .move, move: codableMove, gameState: nil)
//
//            if let moveData = gameCenterController.encodeMessage(moveMessage) {
//                do {
//                    try gameCenterController.match!.sendData(toAllPlayers: moveData, with: .reliable)
//                } catch {
//                    print("Error sending data: \(error.localizedDescription)")
//                }
//            }
////            let newPlayerState: CellState = (gameCenterController.currentPlayer == .player1) ? .player2 : .player1
//            if gameCenterController.currentPlayer == (gameCenterController.localPlayer == gameCenterController.otherPlayer ? .player1 : .player2) {
//                gameCenterController.currentlyPlaying = false
//            }
//            let gameState = GameState(isPaused: gameCenterController.isPaused,
//                                      isGameOver: gameCenterController.isGameOver,
//                                      currentlyDrawing: gameCenterController.currentlyPlaying)
//            let gameStateMessage = GameMessage(messageType: .gameState, move: nil, gameState: gameState)
//            if let gameStateData = gameCenterController.encodeMessage(gameStateMessage) {
//                do {
//                    try gameCenterController.match!.sendData(toAllPlayers: gameStateData, with: .reliable)
//                } catch {
//                    print("Error sending data: \(error.localizedDescription)")
//                }
//            }
//            gameCenterController.currentPlayer = (  gameCenterController.currentPlayer == .player1) ? .player2 : .player1
//
////            // Only switch player after game state message has been sent.
////            if gameCenterController.currentPlayer == (gameCenterController.localPlayer == gameCenterController.otherPlayer ? .player1 : .player2) {
////                gameCenterController.currentlyPlaying = true
////            }
            ///
//            let codableMove = CodableMove.fromMove(move)
//            let moveMessage = GameMessage(messageType: .move, move: codableMove, gameState: nil)
//
//            if let moveData = gameCenterController.encodeMessage(moveMessage) {
//                do {
//                    try gameCenterController.match!.sendData(toAllPlayers: moveData, with: .reliable)
//                } catch {
//                    print("Error sending data: \(error.localizedDescription)")
//                }
//            }
//
//            let newPlayerState: CellState = (gameCenterController.currentPlayer == .player1) ? .player2 : .player1
//            gameCenterController.currentPlayer = newPlayerState
//
//            let gameState = GameState(isPaused: gameCenterController.isPaused,
//                                      isGameOver: gameCenterController.isGameOver,
//                                      currentPlayer: newPlayerState)
//            let gameStateMessage = GameMessage(messageType: .gameState, move: nil, gameState: gameState)
//            if let gameStateData = gameCenterController.encodeMessage(gameStateMessage) {
//                do {
//                    try gameCenterController.match!.sendData(toAllPlayers: gameStateData, with: .reliable)
//                } catch {
//                    print("Error sending data: \(error.localizedDescription)")
//                }
//            }
//
//            // Check if the game is over
//            if !board.hasLegalMoves(player: .player1) || !board.hasLegalMoves(player: .player2) {
//                self.gameCenterController.isGameOver = true
//                self.gameCenterController.isPaused.toggle()
//            }
//
//            SoundManager.shared.playMoveSound()
            let codableMove = CodableMove.fromMove(move)
            let gameState = GameState(isPaused: self.gameCenterController.isPaused, isGameOver: self.gameCenterController.isGameOver, currentPlayer: gameCenterController.currentPlayer)
            let message = GameMessage(messageType: .move, move: codableMove, gameState: gameState)
            if let data = gameCenterController.encodeMessage(message) {
                do {
                    try gameCenterController.match?.sendData(toAllPlayers: data, with: .reliable)
                } catch {
                    print("Error sending data: \(error.localizedDescription)")
                }
            }
            gameCenterController.currentlyPlaying = !gameCenterController.currentlyPlaying
            gameCenterController.currentPlayer = gameCenterController.currentPlayer == .player1 ? .player2 : .player1
            remainingTime = 15
        }
        else {
            gameCenterController.currentPlayer = gameCenterController.currentPlayer == .player1 ? .player2 : .player1
                remainingTime = 15
                if !board.hasLegalMoves(player: .player1) || !board.hasLegalMoves(player: .player2) {
                    self.gameCenterController.isGameOver = true
                    self.gameCenterController.isPaused.toggle()
                } else if gameType == .ai && gameCenterController.currentPlayer == .player2 {
                    DispatchQueue.global().async {
                        self.board.performMTSCMove()
                        print("after ai performs, current player: ", gameCenterController.currentPlayer)
                        DispatchQueue.main.async {
                            self.gameCenterController.currentPlayer = .player1
                            self.remainingTime = 15
                            SoundManager.shared.playMoveSound()
                        }
                    }
                    self.remainingTime = 15
                } else {
                    SoundManager.shared.playMoveSound()
                }
            }
    }
    func switchPlayer() {
        gameCenterController.currentPlayer = (gameCenterController.currentPlayer == .player1) ? .player2 : .player1
    }
    
    func configurePauseMenu() {
        gameCenterController.isPaused.toggle()
        showPauseMenu.toggle()
        if gameType == .multiplayer {
            let gameState = GameState(isPaused: gameCenterController.isPaused,
                                      isGameOver: gameCenterController.isGameOver,
                                      currentPlayer: gameCenterController.currentPlayer)
            let gameStateMessage = GameMessage(messageType: .gameState, move: nil, gameState: gameState)
            
            if let gameStateData = gameCenterController.encodeMessage(gameStateMessage) {
                do {
                    try gameCenterController.match!.sendData(toAllPlayers: gameStateData, with: .reliable)
                } catch {
                    print("Error sending data: \(error.localizedDescription)")
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





