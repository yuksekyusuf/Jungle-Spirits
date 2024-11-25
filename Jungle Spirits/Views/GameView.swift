//
//  GameView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/10/23.
//

import SwiftUI
import Pow

struct GameView: View {
    @StateObject private var board: Board
    @EnvironmentObject var gameCenterManager: GameCenterManager
    @EnvironmentObject var heartManager: HeartManager
    @EnvironmentObject var userViewModel: UserViewModel
    
    init(gameType: GameType, gameSize: (row: Int, col: Int), obstacles: [(Int, Int)]) {
        _gameType = State(initialValue: gameType)
        _board = StateObject(wrappedValue: Board(size: (gameSize.row, gameSize.col), gameType: gameType, obstacles: obstacles))
        _showPauseMenu = State(initialValue: false)
        _showWinMenu = State(initialValue: false)
        _selectedCell = State(initialValue: nil)
        _showAlert = State(initialValue: false)
    }
    @State private var showPauseMenu: Bool
    @State private var showWinMenu: Bool
    @State var selectedCell: (row: Int, col: Int)?
    @State var gameType: GameType
    @State private var showAlert: Bool = false
    @State private var showOverLay: Bool = false
    
    private var player1PieceCount: Int {
        board.countPieces().player1
    }
    
    private var player2PieceCount: Int {
        board.countPieces().player2
    }
    
    var localPlayerName: String {
        String(gameCenterManager.localPlayer.displayName.prefix(8))
    }
    var otherPlayerName: String {
        String(gameCenterManager.otherPlayer?.displayName.prefix(8) ?? "")
    }
    
    var body: some View {
        GeometryReader { geometry in
            let cellSize = self.calculateCellSize(geometry: geometry)
            let boardWidth = cellSize * CGFloat(self.board.size.columns)
            ZStack {
                Image("backgroundImage")
                    .resizable()
                    .scaledToFill()
                    .frame(height: geometry.size.height)
                
                if showWinMenu {
                    PopUpWinView(gameType: gameType, winner: winner, showWinView: $showWinMenu)
                        .zIndex(1)
                }
                ZStack {
                    VStack {
                        if UIScreen.main.bounds.height <= 667 {
                            VStack {
                                HStack {
                                    VStack {
                                        HStack(alignment: .top) {
                                            if gameCenterManager.otherPlayerPlaying {
                                                Image(gameCenterManager.currentPlayer == .player2 ? "Red Eye Open" : "Red Eye Closed")
                                                    .frame(width: 55)
                                                    .padding(.leading, 20)
                                            } else {
                                                Image(gameCenterManager.currentPlayer == .player1 ? "Red Eye Open" : "Red Eye Closed")
                                                    .frame(width: 55)
                                                    .padding(.leading, 20)
                                            }
                                            if gameType == .multiplayer {
                                                VStack(alignment: .leading) {
                                                    PieceCountView(pieceCount: player1PieceCount, size: 25)
                                                        .padding(.top, 5)
                                                    if gameCenterManager.priority > gameCenterManager.otherPriority {
                                                        Text(localPlayerName)
                                                            .foregroundColor(.white)
                                                            .truncationMode(.tail)
                                                            .font(Font.custom("TempleGemsRegular", size: 14))
                                                            .fixedSize(horizontal: true, vertical: false)
                                                    } else {
                                                        Text(otherPlayerName)
                                                            .foregroundColor(.white)
                                                            .truncationMode(.tail)
                                                            .font(Font.custom("TempleGemsRegular", size: 14))
                                                            .fixedSize(horizontal: true, vertical: false)
                                                        
                                                    }
                                                    
                                                }
                                            } else {
                                                PieceCountView(pieceCount: player1PieceCount, size: 30)
                                                    .padding(.top, 5)
                                            }
                                        }
                                    }
                                    Spacer()
                                    VStack {
                                        Button(action: {
                                            if gameType == .multiplayer {
                                                showPauseMenu.toggle()
                                            } else {
                                                gameCenterManager.isPaused.toggle()
                                                if showPauseMenu {
                                                    withAnimation {
                                                        showPauseMenu.toggle()
                                                    }
                                                }
                                                showPauseMenu.toggle()
                                            }
                                        }) {
                                            if !showWinMenu {
                                                Image("Pause button")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 74, height: 50)
                                            }
                                            
                                        }
                                    }
                                    
                                    Spacer()
                                    VStack {
                                        HStack(alignment: .top) {
                                            if gameType == .multiplayer {
                                                VStack(alignment: .trailing){
                                                    PieceCountView(pieceCount: player2PieceCount, size: 25)
                                                        .padding(.top, 5)
                                                    if gameCenterManager.priority < gameCenterManager.otherPriority{
                                                        Text(localPlayerName)
                                                            .foregroundColor(.white)
                                                            .truncationMode(.tail)
                                                            .font(Font.custom("TempleGemsRegular", size: 14))
                                                            .fixedSize(horizontal: true, vertical: false)
                                                    } else {
                                                        Text(otherPlayerName)
                                                            .foregroundColor(.white)
                                                            .font(Font.custom("TempleGemsRegular", size: 14))
                                                            .truncationMode(.tail)
                                                            .fixedSize(horizontal: true, vertical: false)
                                                    }
                                                    
                                                    
                                                }
                                            } else {
                                                PieceCountView(pieceCount: player2PieceCount, size: 30)
                                                    .padding(.top, 5)
                                            }
                                            
                                            if gameCenterManager.otherPlayerPlaying {
                                                Image(gameCenterManager.currentPlayer == .player1 ? "Blue Eye Open" : "Blue Eye Closed")
                                                    .frame(width: 55)
                                                    .padding(.trailing, 20)
                                            } else {
                                                Image(gameCenterManager.currentPlayer == .player2 ? "Blue Eye Open" : "Blue Eye Closed")
                                                    .frame(width: 55)
                                                    .padding(.trailing, 20)
                                            }
                                        }
                                        
                                    }
                                }
                                .opacity(showWinMenu ? 0 : 1)
                                .opacity(showPauseMenu ? 0 : 1)
                                
                                HStack {
                                    if gameType == .multiplayer {
                                        TimeBarView(remainingTime: gameCenterManager.remainingTime, totalTime: 15, currentPlayer: gameCenterManager.currentPlayer, curretlyPlaying: gameCenterManager.currentlyPlaying, gameType: .multiplayer)
                                            .padding([.horizontal, .trailing], 5)
                                            .animation(.linear(duration: 1.0), value: gameCenterManager.remainingTime)
                                    } else {
                                        TimeBarView(remainingTime: gameCenterManager.remainingTime, totalTime: 15, currentPlayer: gameCenterManager.currentPlayer, curretlyPlaying: gameCenterManager.currentlyPlaying, gameType: .ai)
                                            .padding([.horizontal, .trailing], 5)
                                            .animation(.linear(duration: 1.0), value: gameCenterManager.remainingTime)
                                    }
                                    
                                }
                            }
                            .padding(.top ,20)
                        }
                        else {
                            VStack {
                                HStack {
                                    VStack {
                                        HStack(alignment: .top) {
                                            if gameCenterManager.otherPlayerPlaying {
                                                Image(gameCenterManager.currentPlayer == .player2 ? "Red Eye Open" : "Red Eye Closed")
                                                    .frame(width: 55)
                                                    .padding(.leading, 20)
                                            } else {
                                                Image(gameCenterManager.currentPlayer == .player1 ? "Red Eye Open" : "Red Eye Closed")
                                                    .frame(width: 55)
                                                    .padding(.leading, 20)
                                            }
                                            if gameType == .multiplayer {
                                                VStack(alignment: .leading) {
                                                    PieceCountView(pieceCount: player1PieceCount, size: 25)
                                                        .padding(.top, 5)
                                                    
                                                    if gameCenterManager.priority > gameCenterManager.otherPriority {
                                                        Text(localPlayerName)
                                                            .foregroundColor(.white)
                                                            .truncationMode(.tail)
                                                            .font(Font.custom("TempleGemsRegular", size: 14))
                                                            .fixedSize(horizontal: true, vertical: false)
                                                    } else {
                                                        Text(otherPlayerName)
                                                            .foregroundColor(.white)
                                                            .truncationMode(.tail)
                                                            .font(Font.custom("TempleGemsRegular", size: 14))
                                                            .fixedSize(horizontal: true, vertical: false)
                                                        
                                                    }
                                                    
                                                }
                                            } else {
                                                PieceCountView(pieceCount: player1PieceCount, size: 30)
                                                    .padding(.top, 5)
                                            }
                                        }
                                    }
                                    Spacer()
                                    VStack {
                                        Button(action: {
                                            if gameType == .multiplayer {
                                                showPauseMenu.toggle()
                                            } else {
                                                gameCenterManager.isPaused.toggle()
                                                if showPauseMenu {
                                                    withAnimation {
                                                        showPauseMenu.toggle()
                                                    }
                                                }

                                                showPauseMenu.toggle()
                                                
                                            }
                                        }) {
                                            if !showWinMenu {
                                                Image("Pause button")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 74, height: 50)
                                            }
                                            
                                        }
                                    }
                                    
                                    Spacer()
                                    VStack {
                                        HStack(alignment: .top) {
                                            if gameType == .multiplayer {
                                                VStack(alignment: .trailing){
                                                    PieceCountView(pieceCount: player2PieceCount, size: 25)
                                                        .padding(.top, 5)
                                                    if gameCenterManager.priority < gameCenterManager.otherPriority{
                                                        Text(localPlayerName)
                                                            .foregroundColor(.white)
                                                            .truncationMode(.tail)
                                                            .font(Font.custom("TempleGemsRegular", size: 14))
                                                            .fixedSize(horizontal: true, vertical: false)
                                                    } else {
                                                        Text(otherPlayerName)
                                                            .foregroundColor(.white)
                                                            .font(Font.custom("TempleGemsRegular", size: 14))
                                                            .truncationMode(.tail)
                                                            .fixedSize(horizontal: true, vertical: false)
                                                    }
                                                    
                                                    
                                                }
                                            } else {
                                                PieceCountView(pieceCount: player2PieceCount, size: 30)
                                                    .padding(.top, 5)
                                            }
                                            
                                            if gameCenterManager.otherPlayerPlaying {
                                                Image(gameCenterManager.currentPlayer == .player1 ? "Blue Eye Open" : "Blue Eye Closed")
                                                    .frame(width: 55)
                                                    .padding(.trailing, 20)
                                            } else {
                                                Image(gameCenterManager.currentPlayer == .player2 ? "Blue Eye Open" : "Blue Eye Closed")
                                                    .frame(width: 55)
                                                    .padding(.trailing, 20)
                                            }
                                        }
                                        
                                    }
                                }
                                .opacity(showWinMenu ? 0 : 1)
                                .opacity(showPauseMenu ? 0 : 1)
                                
                                HStack {
                                    if gameType == .multiplayer {
                                        TimeBarView(remainingTime: gameCenterManager.remainingTime, totalTime: 15, currentPlayer: gameCenterManager.currentPlayer, curretlyPlaying: gameCenterManager.currentlyPlaying, gameType: .multiplayer)
                                            .padding([.horizontal, .trailing], 5)
                                            .animation(.linear(duration: 1.0), value: gameCenterManager.remainingTime)
                                    } else {
                                        TimeBarView(remainingTime: gameCenterManager.remainingTime, totalTime: 15, currentPlayer: gameCenterManager.currentPlayer, curretlyPlaying: gameCenterManager.currentlyPlaying, gameType: .ai)
                                            .padding([.horizontal, .trailing], 5)
                                            .animation(.linear(duration: 1.0), value: gameCenterManager.remainingTime)
                                    }
                                    
                                }
                            }
                            .padding(.top, 70)
                        }
                        Spacer()
                        HStack{
                            Spacer()
                            BoardView(selectedCell: $selectedCell, currentPlayer: $gameCenterManager.currentPlayer, rows: board.size.rows, cols: board.size.columns, cellSize: cellSize, onMoveCompleted: { move in onMoveCompleted(move)}, gameType: gameType)
                                .frame(maxWidth: boardWidth, minHeight: boardWidth, maxHeight: geometry.size.height * 0.7)
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
                                .frame(maxWidth: boardWidth, minHeight: boardWidth, maxHeight: geometry.size.height * 0.7)
                            Spacer()
                        }
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                    
                    if showPauseMenu {
                        Color.black.opacity(0.65)
                            .ignoresSafeArea()
                            .onTapGesture {
                                if showPauseMenu {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0)) {
                                        showPauseMenu.toggle()
                                        gameCenterManager.isPaused.toggle()
                                        
                                    }
                                }
                            }
                    }
                    
                    if showWinMenu {
                        ZStack {
                            if showOverLay {
                                Color.black.opacity(0.65)
                                    .ignoresSafeArea()
                            }
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation {
                                    showOverLay = true
                                    SoundManager.shared.stopBackgroundMusic()
                                }
                            }
                        }
                        .onDisappear {
                            showOverLay = false
                            if !gameCenterManager.isAdShown {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    SoundManager.shared.playLowerBackground()
                                    
                                }
                            }

                        }
                    }
                    
                    
                    
                    
                    if showWinMenu || showPauseMenu {
                        ZStack {
                            VStack {
                                if UIScreen.main.bounds.height <= 667 {
                                    HStack(alignment: .top) {
                                        Image("Red Eye Open")
                                            .frame(width: 55)
                                            .padding(.leading, 20)
                                            .padding(.top, 17)
                                        PieceCountView(pieceCount: player1PieceCount, size: 30)
                                            .padding(.top, 25)
                                        Spacer()
                                        HeartView()
                                            .padding(.top, 15)
                                        Spacer()
                                        PieceCountView(pieceCount: player2PieceCount, size: 30)
                                            .padding(.top, 25)
                                        Image("Blue Eye Open")
                                            .frame(width: 55)
                                            .padding(.trailing, 20)
                                            .padding(.top, 17)
                                    }
                                } else {
                                    HStack(alignment: .top) {
                                        Image("Red Eye Open")
                                            .frame(width: 55)
                                            .padding(.leading, 20)
                                            .padding(.top, 70)
                                        PieceCountView(pieceCount: player1PieceCount, size: 30)
                                            .padding(.top, 73)
                                        Spacer()
                                        HeartView()
                                            .padding(.top, 70)
                                        Spacer()
                                        PieceCountView(pieceCount: player2PieceCount, size: 30)
                                            .padding(.top, 73)
                                        Image("Blue Eye Open")
                                            .frame(width: 55)
                                            .padding(.trailing, 20)
                                            .padding(.top, 70)
                                        
                                    }
                                    
                                }
                                Spacer()
                            }
                        }
                    }
                    
                    PauseMenuView(showPauseMenu: $showPauseMenu, isPaused: $gameCenterManager.isPaused, remainingTime: $gameCenterManager.remainingTime, selectedCell: $selectedCell, gameType: gameType, currentPlayer: $gameCenterManager.currentPlayer)
                        .scaleEffect(showPauseMenu ? 1 : 0)
                        .allowsHitTesting(showPauseMenu)
                        .animation(showPauseMenu ? .spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0) : .linear(duration: 0.001), value: showPauseMenu)
                    
                    if gameCenterManager.isCountDownVisible {
                        CountDownView(isVisible: $gameCenterManager.isCountDownVisible)
                            .onAppear(perform: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    SoundManager.shared.playCountDown()
                                }
                            })
                    }
                    LottieView(animationName: "particles", ifActive: false, contentMode: true, isLoop: true)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .allowsHitTesting(false)
                        .edgesIgnoringSafeArea(.all)
                }
                //BOTTOM Image
                VStack {
                    Spacer()
                    if UIScreen.main.bounds.height <= 667 {
                        Image("Bottom")
                            .resizable()
                            .scaledToFit()
                        //                            .edgesIgnoringSafeArea(.bottom)
                            .allowsHitTesting(false)
                            .offset(y: 65)
                    } else {
                        Image("Bottom")
                            .resizable()
                            .scaledToFit()
                            .allowsHitTesting(false)
                            .offset(y: 45)
                        //                            .edgesIgnoringSafeArea(.bottom)
                    }
                }
                
            }

        }
        .edgesIgnoringSafeArea(.all)
        .onChange(of: gameCenterManager.connectionLost, perform: { newValue in
            if newValue && gameType == .multiplayer {
                showAlert = true
            }
        })
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Player disconnected"),
                message: Text("The other player disconnected from the match!"),
                dismissButton: .default(Text("OK"), action: {
                    // Handle what should happen when the user dismisses the alert
                    gameCenterManager.resetGame()
                })
            )
        }
        
        .navigationBarHidden(true)
        .onChange(of: board.gameOver, perform: { newValue in
                if newValue == true {
                    //                gameCenterController.isGameOver = true
                    //                self.gameCenterController.isPaused = true
                    if gameType == .ai && winner == .player2 {
                        if userViewModel.isSubscriptionActive == false {
                            heartManager.loseHeart()
                        }
                    } else if gameType == .ai && winner == .player1 {
                        guard let nextLevel = gameCenterManager.currentLevel else { return }
                        let nextLevelId = nextLevel.id + 1
                        if gameCenterManager.currentLevel == gameCenterManager.achievedLevel {
                            if nextLevelId <= 7 {
                                gameCenterManager.achievedLevel = GameLevel(rawValue: nextLevelId) ?? gameCenterManager.achievedLevel
                                UserDefaults.standard.setValue(nextLevelId, forKey: "achievedLevel")
                            } else if (nextLevelId > 7) && (nextLevelId < 15) {
                                gameCenterManager.achievedLevel = GameLevel(rawValue: nextLevelId) ?? gameCenterManager.achievedLevel
                                UserDefaults.standard.setValue(nextLevelId, forKey: "achievedLevel")
                                gameCenterManager.currentBundle = .bundle2
                                UserDefaults.standard.setValue(2, forKey: "currentBundle")
                            } else {
                                gameCenterManager.achievedLevel = GameLevel(rawValue: nextLevelId) ?? gameCenterManager.achievedLevel
                                UserDefaults.standard.setValue(nextLevelId, forKey: "achievedLevel")
                                gameCenterManager.currentBundle = .bundle3
                                UserDefaults.standard.setValue(3, forKey: "currentBundle")
                            }
                            
                        }
                        
                        gameCenterManager.currentLevel = GameLevel(rawValue: nextLevelId)

                    }
                    gameCenterManager.isGameOver = true
                    self.gameCenterManager.isPaused = true
                    self.showWinMenu = true
                }
            
            
        })
        .onChange(of: gameCenterManager.remainingTime, perform: { newValue in
            if newValue == 0 && gameType == .oneVone {
                switchPlayer()
                gameCenterManager.remainingTime = 15
                selectedCell = nil
                //                gameCenterController.isSelected = false
                selectedCell = nil
            } else if newValue == 0 && gameType == .ai {
                gameCenterManager.remainingTime = 15
                //                gameCenterController.isSelected = false
                selectedCell = nil
                switchPlayer()
                performAIMoveAfterDelay()
            } else if newValue == 0 && gameType == .multiplayer {
                gameCenterManager.remainingTime = 15
                gameCenterManager.otherPlayerPlaying.toggle()
                gameCenterManager.currentlyPlaying.toggle()
                let gameState = GameState(isPaused: gameCenterManager.isPaused, isGameOver: gameCenterManager.isGameOver, currentPlayer: gameCenterManager.currentPlayer, currentlyPlaying: gameCenterManager.currentlyPlaying, priority: gameCenterManager.priority)
                let message = GameMessage(messageType: .move, move: nil, gameState: gameState)
                if let data = gameCenterManager.encodeMessage(message) {
                    do {
                        try gameCenterManager.match?.sendData(toAllPlayers: data, with: .reliable)
                    } catch {
                        print("Failed to send move: ", error)
                        
                    }
                }
            }
        })
        .onAppear {
            gameCenterManager.startTimer(gameType: gameType)
            gameCenterManager.remainingTime = 15
            gameCenterManager.board = self.board
            gameCenterManager.isQuitGame = false
            SoundManager.shared.turnDownMusic()
            gameCenterManager.isPaused = false
            
            if gameCenterManager.isPaused == false {
                NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { _ in
                    gameCenterManager.isPaused = true
                    showPauseMenu = true
                }
            }
            if gameCenterManager.isCountDownVisible == false {
                gameCenterManager.isCountDownVisible = true
            }
        }
        .environmentObject(board)
        .onDisappear {
            self.gameCenterManager.isPaused = false
            self.gameCenterManager.isGameOver = false
            self.gameCenterManager.currentPlayer = .player1
            self.gameCenterManager.remainingTime = 15
            self.gameCenterManager.isQuitGame = true
//            self.gameCenterManager.stopTimer()
            SoundManager.shared.turnUpMusic()
            NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        }
        
    }
    var winner: CellState {
        let (player1Count, player2Count, _) = board.countPieces()
        if player1Count > player2Count {
            return .player1
        } else if player2Count > player1Count {
            return .player2
        } else if player2Count == player1Count{
            return .draw
        } else {
            return .initial
        }
    }
    
    func calculateCellSize(geometry: GeometryProxy) -> CGFloat {
        let maxCellWidth = geometry.size.width * 0.175
        let availableWidth = geometry.size.width * 0.90
        let maxWidthBasedCellSize = min(maxCellWidth, availableWidth / CGFloat(board.size.columns))
        
        let maxBoardHeight = geometry.size.height * 0.75
        let maxHeightBasedCellSize = maxBoardHeight / CGFloat(board.size.rows)
        
        var cellWidth = max(maxWidthBasedCellSize, maxHeightBasedCellSize)
        
        if cellWidth * CGFloat(board.size.columns) > availableWidth {
            cellWidth = availableWidth / CGFloat(board.size.columns)
        } else if cellWidth * CGFloat(board.size.rows) > maxBoardHeight {
            cellWidth = maxBoardHeight / CGFloat(board.size.rows)
        }
        
        return cellWidth
    }
    
    func onMoveCompleted(_ move: Move) {
        if board.isGameOver() {
            if gameType == .ai {
                gameOverSounds()
            }
            // Prepare the game over status
            let gameState = GameState(isPaused: true, isGameOver: true, currentPlayer: self.gameCenterManager.currentPlayer, currentlyPlaying: gameCenterManager.currentlyPlaying, priority: self.gameCenterManager.priority)
            let codableMove = CodableMove.fromMove(move)
            let message = GameMessage(messageType: .gameState, move: codableMove, gameState: gameState)
            // Send the game over status to the other player
            if let data = gameCenterManager.encodeMessage(message) {
                do {
                    try gameCenterManager.match?.sendData(toAllPlayers: data, with: .reliable)
                } catch {
                    print("Failed to send game over status: ", error)
                }
            }
            self.gameCenterManager.isGameOver = true
            self.gameCenterManager.isPaused = true
            return
        }
        
        if gameType == .multiplayer {
            gameCenterManager.otherPlayerPlaying.toggle()
            gameCenterManager.currentlyPlaying.toggle()
            let codableMove = CodableMove.fromMove(move)
            let gameState = GameState(isPaused: gameCenterManager.isPaused, isGameOver: gameCenterManager.isGameOver, currentPlayer: gameCenterManager.currentPlayer, currentlyPlaying: gameCenterManager.currentlyPlaying, priority: gameCenterManager.priority)
            let message = GameMessage(messageType: .move, move: codableMove, gameState: gameState)
            if let data = gameCenterManager.encodeMessage(message) {
                do {
                    try gameCenterManager.match?.sendData(toAllPlayers: data, with: .reliable)
                } catch {
                    print("Failed to send move: ", error)
                    
                }
            }
            gameCenterManager.remainingTime = 15
        }
        else {
            gameCenterManager.currentPlayer = gameCenterManager.currentPlayer == .player1 ? .player2 : .player1
            gameCenterManager.remainingTime = 15
            SoundManager.shared.playMoveSound()
            if !board.hasLegalMoves(player: .player1) || !board.hasLegalMoves(player: .player2) {
                self.gameCenterManager.isGameOver = true
                self.gameCenterManager.isPaused.toggle()
            }
            else if gameType == .ai && gameCenterManager.currentPlayer == .player2 {
                // Use a single main thread delay, instead of nested or global ones.
                
                performAIMoveAfterDelay()
                // This is outside the async block. If you want this reset to always occur immediately after the AI makes a move, then it's correctly placed.
            }
        }
    }
    func switchPlayer() {
        gameCenterManager.currentPlayer = (gameCenterManager.currentPlayer == .player1) ? .player2 : .player1
    }
    
    func performAIMoveAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            // Let the AI perform its move and get the converted pieces.
            if let convertedPieces = self.board.performAIMove() {
                
                // Update convertedCells and previouslyConvertedCells on the main thread.
                for piece in convertedPieces {
                    gameCenterManager.convertedCells.append((row: piece.row, col: piece.col, byPlayer: gameCenterManager.currentPlayer))
                    gameCenterManager.previouslyConvertedCells.append((row: piece.row, col: piece.col, byPlayer: gameCenterManager.currentPlayer))
                }
                
                // Play the conversion sound if any pieces were converted.
                if !convertedPieces.isEmpty {
                    SoundManager.shared.playConvertSound()
                }
                
                // Check if the game is over.
                if board.isGameOver() {
                    gameOverSounds()
                    self.gameCenterManager.isGameOver = true
                    self.gameCenterManager.isPaused = true
                    return
                }
                
                // Switch the current player and reset the timer.
                self.gameCenterManager.currentPlayer = .player1
                self.gameCenterManager.remainingTime = 15
                
                // Play move sound.
                SoundManager.shared.playMoveSound()
            }
        }
    }
    
    func configurePauseMenu() {
        gameCenterManager.isPaused.toggle()
        showPauseMenu.toggle()
    }
    private func gameOverSounds() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if board.countPieces().player1 > player2PieceCount {
                SoundManager.shared.playOverSound()
            } else if player1PieceCount < player2PieceCount {
                SoundManager.shared.playLoseSound()
            } else {
                SoundManager.shared.playLoseSound()
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameType: .ai, gameSize: (4, 4), obstacles: [])
            .environmentObject(GameCenterManager(currentPlayer: .player1))        
    }
}
