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
    init(gameType: GameType, gameSize: (row: Int, col: Int)) {
        _gameType = State(initialValue: gameType)
        _board = StateObject(wrappedValue: Board(size: (gameSize.row, gameSize.col), gameType: gameType))
        
        _showPauseMenu = State(initialValue: false)
        _showWinMenu = State(initialValue: false)
        _selectedCell = State(initialValue: nil)

        _isCountDownVisible = State(initialValue: true)
        _showAlert = State(initialValue: false)
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var isCountDownVisible: Bool
    @State private var showPauseMenu: Bool
    @State private var showWinMenu: Bool
    @State var selectedCell: (row: Int, col: Int)?
    @State var gameType: GameType
    @State private var showAlert: Bool = false

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
        GeometryReader { geometry in
            let cellSize = self.calculateCellSize(geometry: geometry)
            let boardWidth = cellSize * CGFloat(self.board.size.columns)


            ZStack {
                Image("backgroundImage")
                    .resizable()
                    .scaledToFill()
                    .frame(height: geometry.size.height)
                ZStack {
                    VStack {
                        if UIScreen.main.bounds.height <= 667 {
                            VStack {
                                HStack {
                                    VStack {
                                        HStack(alignment: .top) {
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
                                            }
                                        }
                                    }
                                    Spacer()
                                    VStack {
                                        Button(action: {
                                            if gameType == .multiplayer {
                                                showPauseMenu.toggle()
                                            } else {
                                                gameCenterController.isPaused.toggle()
                                                if showPauseMenu {
                                                    withAnimation {
                                                        showPauseMenu.toggle()
                                                    }
                                                }

                                                showPauseMenu.toggle()

                                            }
                                        }) {
                                                Image("Pause button")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 74, height: 50)
                                        }
                                    }

                                    Spacer()
                                    VStack {
                                        HStack(alignment: .top) {
                                            if gameType == .multiplayer {
                                                VStack(alignment: .trailing){
                                                    PieceCountView(pieceCount: player2PieceCount, size: 25)
                                                        if gameCenterController.priority < gameCenterController.otherPriority{
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
                                            }

                                            if gameCenterController.otherPlayerPlaying {
                                                Image(gameCenterController.currentPlayer == .player1 ? "Blue Eye Open" : "Blue Eye Closed")
                                                    .frame(width: 55)
                                                    .padding(.trailing, 20)
                                            } else {
                                                Image(gameCenterController.currentPlayer == .player2 ? "Blue Eye Open" : "Blue Eye Closed")
                                                    .frame(width: 55)
                                                    .padding(.trailing, 20)
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
                            }
                            .padding(.top ,20)
                        } else {
                            VStack {
                                HStack {
                                    VStack {
                                        HStack(alignment: .top) {
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
                                            }
                                        }
                                    }
                                    Spacer()
                                    VStack {
                                        Button(action: {
                                            if gameType == .multiplayer {
                                                showPauseMenu.toggle()
                                            } else {
                                                gameCenterController.isPaused.toggle()
                                                if showPauseMenu {
                                                    withAnimation {
                                                        showPauseMenu.toggle()
                                                    }
                                                }
                                                
                                                showPauseMenu.toggle()
                                                
                                            }
                                        }) {
                                            Image("Pause button")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 74, height: 50)
                                        }
                                    }
                                    
                                    Spacer()
                                    VStack {
                                        HStack(alignment: .top) {
                                            if gameType == .multiplayer {
                                                VStack(alignment: .trailing){
                                                    PieceCountView(pieceCount: player2PieceCount, size: 25)
                                                    if gameCenterController.priority < gameCenterController.otherPriority{
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
                                            }
                                            
                                            if gameCenterController.otherPlayerPlaying {
                                                Image(gameCenterController.currentPlayer == .player1 ? "Blue Eye Open" : "Blue Eye Closed")
                                                    .frame(width: 55)
                                                    .padding(.trailing, 20)
                                            } else {
                                                Image(gameCenterController.currentPlayer == .player2 ? "Blue Eye Open" : "Blue Eye Closed")
                                                    .frame(width: 55)
                                                    .padding(.trailing, 20)
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
                            }
                            .padding(.top, 70)
                        }
                        Spacer()
                        HStack{
                            Spacer()
                            BoardView(selectedCell: $selectedCell, currentPlayer: $gameCenterController.currentPlayer, rows: board.size.rows, cols: board.size.columns, cellSize: cellSize, onMoveCompleted: { move in onMoveCompleted(move)}, gameType: gameType)
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
                    }

                    if showPauseMenu {
                        Color.black.opacity(0.65)
                            .ignoresSafeArea()
                            .onTapGesture {
                                if showPauseMenu {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        showPauseMenu.toggle()
                                    }
                                }
                            }
                    }

                    PauseMenuView(showPauseMenu: $showPauseMenu, isPaused: $gameCenterController.isPaused, remainingTime: $gameCenterController.remainingTime, selectedCell: $selectedCell, gameType: gameType, currentPlayer: $gameCenterController.currentPlayer)
                        .scaleEffect(showPauseMenu ? 1 : 0)
                        .allowsHitTesting(showPauseMenu)
                        .animation(.easeInOut(duration: 0.5), value: showPauseMenu)

                    
                    if gameCenterController.isGameOver {
                        WinView(showWinMenu: $gameCenterController.isGameOver, isPaused: $gameCenterController.isPaused, remainingTime: $gameCenterController.remainingTime, gameType: gameType, winner: winner, currentPlayer: $gameCenterController.currentPlayer)
                    }
                    if isCountDownVisible {
                        CountDownView(isVisible: $isCountDownVisible)
                    }
                    LottieView(animationName: "particles", ifActive: false, contentMode: true, isLoop: true)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .allowsHitTesting(false)
                        .edgesIgnoringSafeArea(.all)
                }
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
//                .frame(height: UIScreen.main.bounds.height * 1)
                
            }

        }
        .edgesIgnoringSafeArea(.all)
        .onChange(of: gameCenterController.connectionLost, perform: { newValue in
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
                        gameCenterController.resetGame()
                    })
                )
        }
        .navigationBarHidden(true)
        .onChange(of: board.cells) { _ in
            if board.isGameOver() == true {
                gameCenterController.isGameOver = true
                self.gameCenterController.isPaused = true
            }
        }
        .onChange(of: board.gameOver, perform: { newValue in
            if newValue == true {
                gameCenterController.isGameOver = true
                self.gameCenterController.isPaused = true
            }
        })
        .onChange(of: gameCenterController.remainingTime, perform: { newValue in
            print("Remaining time: ", newValue)
            if newValue == 0 && gameType == .oneVone {
                switchPlayer()
                gameCenterController.remainingTime = 15
                selectedCell = nil
//                gameCenterController.isSelected = false
                selectedCell = nil
            } else if newValue == 0 && gameType == .ai {
                gameCenterController.remainingTime = 15
//                gameCenterController.isSelected = false
                selectedCell = nil
                switchPlayer()
                performAIMoveAfterDelay()
            } else if newValue == 0 && gameType == .multiplayer {
                gameCenterController.remainingTime = 15
                gameCenterController.otherPlayerPlaying.toggle()
                gameCenterController.currentlyPlaying.toggle()
                let gameState = GameState(isPaused: gameCenterController.isPaused, isGameOver: gameCenterController.isGameOver, currentPlayer: gameCenterController.currentPlayer, currentlyPlaying: gameCenterController.currentlyPlaying, priority: gameCenterController.priority)
                let message = GameMessage(messageType: .move, move: nil, gameState: gameState)
                if let data = gameCenterController.encodeMessage(message) {
                    do {
                        try gameCenterController.match?.sendData(toAllPlayers: data, with: .reliable)
                    } catch {
                        print("Failed to send move: ", error)

                    }
                }
            }
        })
        .onReceive(timer) { _ in
            print("Remaining time: ", gameCenterController.remainingTime)
            if !gameCenterController.isPaused && gameCenterController.remainingTime > 0 && !isCountDownVisible && !gameCenterController.isQuitGame {
                gameCenterController.remainingTime -= 1
                print("remaining time after receive: ", gameCenterController.remainingTime)
            }
        }
        .onAppear {
            gameCenterController.remainingTime = 15
            gameCenterController.board = self.board
            gameCenterController.isQuitGame = false
            SoundManager.shared.turnDownMusic()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                SoundManager.shared.playCountDown()

            }
        }
        .environmentObject(board)
        .onDisappear {
            self.gameCenterController.isPaused = false
            self.gameCenterController.isGameOver = false
            self.gameCenterController.currentPlayer = .player1
            self.gameCenterController.remainingTime = 15
            self.gameCenterController.isQuitGame = true
            self.timer.upstream.connect().cancel()
            SoundManager.shared.turnUpMusic()
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
    
    
    
    func calculateCellSize(geometry: GeometryProxy) -> CGFloat {
        let maxCellWidth = geometry.size.width * 0.175
        let availableWidth = geometry.size.width * 0.95
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
            // Prepare the game over status
            let gameState = GameState(isPaused: true, isGameOver: true, currentPlayer: self.gameCenterController.currentPlayer, currentlyPlaying: gameCenterController.currentlyPlaying, priority: self.gameCenterController.priority)
            let codableMove = CodableMove.fromMove(move)
            let message = GameMessage(messageType: .gameState, move: codableMove, gameState: gameState)
            // Send the game over status to the other player
            if let data = gameCenterController.encodeMessage(message) {
                do {
                    try gameCenterController.match?.sendData(toAllPlayers: data, with: .reliable)
                } catch {
                    print("Failed to send game over status: ", error)
                }
            }
            self.gameCenterController.isGameOver = true
            self.gameCenterController.isPaused = true
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
            }
            else if gameType == .ai && gameCenterController.currentPlayer == .player2 {
                // Use a single main thread delay, instead of nested or global ones.

                performAIMoveAfterDelay()
                // This is outside the async block. If you want this reset to always occur immediately after the AI makes a move, then it's correctly placed.
            }
        }
    }
    func switchPlayer() {
        gameCenterController.currentPlayer = (gameCenterController.currentPlayer == .player1) ? .player2 : .player1
    }
    
    func performAIMoveAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            // Let the AI perform its move and get the converted pieces.
            if let convertedPieces = self.board.performAIMove() {
                
                // Update convertedCells and previouslyConvertedCells on the main thread.
                for piece in convertedPieces {
                    gameCenterController.convertedCells.append((row: piece.row, col: piece.col, byPlayer: gameCenterController.currentPlayer))
                    gameCenterController.previouslyConvertedCells.append((row: piece.row, col: piece.col, byPlayer: gameCenterController.currentPlayer))
                }
                
                // Play the conversion sound if any pieces were converted.
                if !convertedPieces.isEmpty {
                    SoundManager.shared.playConvertSound()
                }

                // Check if the game is over.
                if board.isGameOver() {
                    self.gameCenterController.isGameOver = true
                    self.gameCenterController.isPaused = true
                    return
                }
                
                // Switch the current player and reset the timer.
                self.gameCenterController.currentPlayer = .player1
                self.gameCenterController.remainingTime = 15

                // Play move sound.
                SoundManager.shared.playMoveSound()
            }
        }
    }

    func configurePauseMenu() {
        gameCenterController.isPaused.toggle()
        showPauseMenu.toggle()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameType: .oneVone, gameSize: (8 ,5))
            .environmentObject(AppLanguageManager())
            .environmentObject(GameCenterManager(currentPlayer: .player1))
    }
}
