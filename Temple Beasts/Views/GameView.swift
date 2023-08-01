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
        _selectedCell = State(initialValue: nil)
        _isCountDownVisible = State(initialValue: true)
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var isCountDownVisible: Bool
    @State private var showPauseMenu: Bool
    @State private var showWinMenu: Bool
    @State var selectedCell: (row: Int, col: Int)?
    @State var gameType: GameType
//    @EnvironmentObject var menuViewModel: MenuViewModel
    let cellSize: CGFloat = 40

    private var player1PieceCount: Int {
        board.countPieces().player1
    }

    private var player2PieceCount: Int {
        board.countPieces().player2
    }
    
    var localPlayerName: String {
        String(gameCenterController.localPlayer.displayName.prefix(8))
    }
    var otherPlayerName: String {
        String(gameCenterController.otherPlayer?.displayName.prefix(8) ?? "")
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
                                if gameCenterController.otherPlayerPlaying {
                                    Image(gameCenterController.currentPlayer == .player2 ? "Red Eye Open" : "Red Eye Closed")
                                        .frame(width: 55)
                                        .padding(.leading, 20)
                                } else {
                                    Image(gameCenterController.currentPlayer == .player1 ? "Red Eye Open" : "Red Eye Closed")
                                        .frame(width: 55)
                                        .padding(.leading, 20)
                                }
                                if gameType == .multiplayer {
                                    VStack(alignment: .leading) {
                                        PieceCountView(pieceCount: player1PieceCount, size: 25)
                                            if gameCenterController.priority > gameCenterController.otherPriority {
                                                Text(localPlayerName)
                                                    .foregroundColor(.white)
                                                    .truncationMode(.tail)
                                                    .font(Font.custom("Watermelon-Regular", size: 14))
                                                    .fixedSize(horizontal: true, vertical: false)
                                            } else {
                                                Text(otherPlayerName)
                                                    .foregroundColor(.white)
                                                    .truncationMode(.tail)
                                                    .font(Font.custom("Watermelon-Regular", size: 14))
                                                    .fixedSize(horizontal: true, vertical: false)

                                            }
                                        
                                    }
                                } else {
                                    PieceCountView(pieceCount: player1PieceCount, size: 30)
                                }
                            }
                        }

                        Spacer()
                        VStack {
                            Button(action: {
                                configurePauseMenu()
                            }) {
                                HStack {
                                    Image("Pause button")
                                        .frame(width: 69, height: 40)
                                }
                                .padding()
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                        }

                        Spacer()
                        VStack {
                            HStack {
                                if gameType == .multiplayer {
                                    VStack(alignment: .trailing){
                                        PieceCountView(pieceCount: player2PieceCount, size: 25)
                                            if gameCenterController.priority < gameCenterController.otherPriority{
                                                Text(localPlayerName)
                                                    .foregroundColor(.white)
                                                    .truncationMode(.tail)
                                                    .font(Font.custom("Watermelon-Regular", size: 14))
                                                    .fixedSize(horizontal: true, vertical: false)
                                            } else {
                                                Text(otherPlayerName)
                                                    .foregroundColor(.white)
                                                    .font(Font.custom("Watermelon-Regular", size: 14))
                                                    .truncationMode(.tail)
                                                    .fixedSize(horizontal: true, vertical: false)
                                            }
                                        
                                        
                                    }
                                } else {
                                    PieceCountView(pieceCount: player2PieceCount, size: 30)
                                }

                                if gameCenterController.otherPlayerPlaying {
                                    Image(gameCenterController.currentPlayer == .player1 ? "Blue Eye Open" : "Blue Eye Closed")
                                        .frame(width: 55)
//                                        .padding(.trailing, 20)
                                } else {
                                    Image(gameCenterController.currentPlayer == .player2 ? "Blue Eye Open" : "Blue Eye Closed")
                                        .frame(width: 55)
//                                        .padding(.trailing, 20)
                                }
                            }
                           
                        }
                    }
                    HStack {
                        if gameType == .multiplayer {
                            TimeBarView(remainingTime: gameCenterController.remainingTime, totalTime: 15, currentPlayer: gameCenterController.currentPlayer, curretlyPlaying: gameCenterController.currentlyPlaying, gameType: .multiplayer)
                                .padding([.horizontal, .trailing], 5)
                                .animation(.linear(duration: 1.0), value: gameCenterController.remainingTime)
                        } else {
                            TimeBarView(remainingTime: gameCenterController.remainingTime, totalTime: 15, currentPlayer: gameCenterController.currentPlayer, curretlyPlaying: gameCenterController.currentlyPlaying, gameType: .ai)
                                .padding([.horizontal, .trailing], 5)
                                .animation(.linear(duration: 1.0), value: gameCenterController.remainingTime)
                        }
                        
                    }
                    BoardView(selectedCell: $selectedCell, currentPlayer: $gameCenterController.currentPlayer, onMoveCompleted: { move in onMoveCompleted(move) }, gameType: gameType)
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
                    PauseMenuView(showPauseMenu: $showPauseMenu, isPaused: $gameCenterController.isPaused, remainingTime: $gameCenterController.remainingTime, gameType: gameType, currentPlayer: $gameCenterController.currentPlayer)
                        .animation(Animation.easeInOut, value: showPauseMenu)
                }

                if gameCenterController.isGameOver {
                    WinView(showWinMenu: $gameCenterController.isGameOver, isPaused: $gameCenterController.isPaused, remainingTime: $gameCenterController.remainingTime, winner: winner, currentPlayer: $gameCenterController.currentPlayer)
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
        .onChange(of: board.cells) { _ in
            if board.isGameOver() {
                gameCenterController.isGameOver = true
                self.gameCenterController.isPaused = true
            }
        }
        .onChange(of: gameCenterController.remainingTime, perform: { newValue in
            if newValue == 0 && gameType == .oneVone {
                switchPlayer()
                gameCenterController.remainingTime = 15
            } else if newValue == 0 && gameType == .ai {
//                gameCenterController.remainingTime = 15
//                switchPlayer()
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    self.board.performAIMove()
                    print("after ai performs, current player: ", gameCenterController.currentPlayer)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.gameCenterController.currentPlayer = .player1
                        self.gameCenterController.remainingTime = 15
                    }
                }
                self.gameCenterController.remainingTime = 15
            }
        })
        .onReceive(timer) { _ in
            if !gameCenterController.isPaused && gameCenterController.remainingTime > 0 && !isCountDownVisible && !gameCenterController.isQuitGame {
                gameCenterController.remainingTime -= 1
            }
        }
        .onAppear {
            gameCenterController.remainingTime = 15
            gameCenterController.board = self.board
            gameCenterController.isQuitGame = false
            
        }
        .environmentObject(board)
        .onDisappear {
            self.gameCenterController.isPaused = false
            self.gameCenterController.isGameOver = false
            self.gameCenterController.currentPlayer = .player1
            self.gameCenterController.remainingTime = 15
            self.gameCenterController.isQuitGame = true
            self.timer.upstream.connect().cancel()
        }
    }
    var winner: CellState {
        let (player1Count, player2Count, _) = board.countPieces()
        if player1Count > player2Count {
            return .player1
        } else if player2Count > player1Count {
            return .player2
        } else {
            return .draw
        }
    }
    func onMoveCompleted(_ move: Move) {
        if board.isGameOver() {
            self.gameCenterController.isGameOver = true
            self.gameCenterController.isPaused = true
            // Prepare the game over status
            let gameState = GameState(isPaused: self.gameCenterController.isPaused, isGameOver: self.gameCenterController.isGameOver, currentPlayer: self.gameCenterController.currentPlayer, currentlyPlaying: gameCenterController.currentlyPlaying, priority: self.gameCenterController.priority)
//            let codableMove = CodableMove.fromMove(move)
            
            let message = GameMessage(messageType: .gameState, move: nil, gameState: gameState)
            // Send the game over status to the other player
                    if let data = gameCenterController.encodeMessage(message) {
                        do {
                            try gameCenterController.match?.sendData(toAllPlayers: data, with: .reliable)
                        } catch {
                            print("Failed to send game over status: ", error)
                        }
                    }
            gameCenterController.match?.disconnect()
            
                return
            }
       
        if gameType == .multiplayer {
            gameCenterController.otherPlayerPlaying.toggle()
            gameCenterController.currentlyPlaying.toggle()
            let codableMove = CodableMove.fromMove(move)
            let gameState = GameState(isPaused: gameCenterController.isPaused, isGameOver: gameCenterController.isGameOver, currentPlayer: gameCenterController.currentPlayer, currentlyPlaying: gameCenterController.currentlyPlaying, priority: gameCenterController.priority)
            let message = GameMessage(messageType: .move, move: codableMove, gameState: gameState)
            if let data = gameCenterController.encodeMessage(message) {
                do {
                    try gameCenterController.match?.sendData(toAllPlayers: data, with: .reliable)
                } catch {
                    print("Failed to send move: ", error)

                }

            }
            gameCenterController.remainingTime = 15
        }
        else {
            gameCenterController.currentPlayer = gameCenterController.currentPlayer == .player1 ? .player2 : .player1
            gameCenterController.remainingTime = 15
            SoundManager.shared.playMoveSound()
            if !board.hasLegalMoves(player: .player1) || !board.hasLegalMoves(player: .player2) {
                self.gameCenterController.isGameOver = true
                self.gameCenterController.isPaused.toggle()
            } else if gameType == .ai && gameCenterController.currentPlayer == .player2 {
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    self.board.performAIMove()
                    print("after ai performs, current player: ", gameCenterController.currentPlayer)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if board.isGameOver() {
                            self.gameCenterController.isGameOver = true
                            self.gameCenterController.isPaused = true
                            
                            return
                        }
                        self.gameCenterController.currentPlayer = .player1
                        self.gameCenterController.remainingTime = 15
                        SoundManager.shared.playMoveSound()
                        if let convertedPieces = board.countConvertiblePieces(at: move.destination, player: gameCenterController.currentPlayer) {
                            if convertedPieces > 0 {
                                SoundManager.shared.playConvertSound()
                            }
                        }
                    }
                }
                self.gameCenterController.remainingTime = 15
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
                                      currentPlayer: gameCenterController.currentPlayer, currentlyPlaying: gameCenterController.currentlyPlaying, priority: gameCenterController.priority)
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
