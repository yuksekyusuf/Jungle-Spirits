//
//  GameCenterController.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5.07.2023.
//

import SwiftUI
import UIKit
import GameKit



enum MessageType: Int, Codable {
    case move
    case gameState
}

struct GameMessage: Codable {
    let messageType: MessageType
    let move: CodableMove?
    let gameState: GameState?
}

struct GameState: Codable {
    var isPaused: Bool?
    var isGameOver: Bool?
    var currentPlayer: CellState?
    var currentlyPlaying: Bool?
    var priority: Int
    var goneToBackground: Bool = false
}

class GameCenterManager: NSObject, GKMatchDelegate, ObservableObject {
    @Published var isPaused: Bool = false
    @Published var isGameOver: Bool = false
    @Published var currentPlayer: CellState
    @Published var currentlyPlaying = false
    @Published var otherPlayerPlaying: Bool = false
    @Published var remainingTime = 15
    @Published var isQuitGame = false
    @Published var path: [Int] = []
    @Published var connectionLost: Bool = false
    @Published  var convertedCells: [(row: Int, col: Int, byPlayer: CellState)] = []
    @Published  var previouslyConvertedCells: [(row: Int, col: Int, byPlayer: CellState)] = []

    var backgroundTimer: Timer?
    var localPlayer = GKLocalPlayer.local
    var otherPlayer: GKPlayer?
    var priority: Int = 0
    var otherPriority = 0

    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    init(currentPlayer: CellState) {
        self.currentPlayer = currentPlayer
        super.init()
            startObservingAppLifecycle()
    }

    @Published var isUserAuthenticated = false
    @Published var isMatched = false
    @Published var match: GKMatch? {
        didSet {
            self.isMatched = match != nil
            if let match = match {
                match.delegate = self
                currentPlayer = .initial
                print("When players are matched, their current player state is ", currentPlayer.rawValue)
            }
        }
    }
    var board: Board? {
        didSet {
            if let board = board {
                board.notifyChange()
            }
        }
    }
    func authenticateUser() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { [self] gcAuthVC, error in
            if GKLocalPlayer.local.isAuthenticated {
                // Player is already authenticated
                self.isUserAuthenticated = true
            } else if let vc = gcAuthVC {
                // Show game center login UI
                rootViewController?.present(vc, animated: true)
            } else {
                // Game center authentication failed
                print("Authentication failed: " + error!.localizedDescription)
            }
        }
    }
    
    func encodeMessage(_ message: GameMessage) -> Data? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(message)
            return data
        } catch {
            print("Failed to encode message: ", error.localizedDescription)
            return nil
        }
    }

    func decodeMessage(from data: Data) -> GameMessage? {
        do {
            let decoder = JSONDecoder()
            let message = try decoder.decode(GameMessage.self, from: data)
            return message
        } catch {
            print("Failed to decode message: ", error.localizedDescription)
            return nil
        }
    }

    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        if let message = decodeMessage(from: data) {
            DispatchQueue.main.async {
                switch message.messageType {
                case .move:
                    guard let codableMove = message.move else { return }
                    let move = Move.fromCodable(codableMove)
                    self.processMove(move)
                    guard let gameState = message.gameState else { return }
                    if let isOver = gameState.isGameOver, isOver {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.isGameOver = true
                        }
                    }

                case .gameState:
                    guard let gameState = message.gameState else { return }
                    if let isPause = gameState.isPaused {
                        self.isPaused = isPause
                    }
                    if let isOver = gameState.isGameOver, isOver {
                        guard let codableMove = message.move else { return }
                        let move = Move.fromCodable(codableMove)
                        self.currentPlayer = self.currentPlayer == .player1 ? .player2 : .player1
                        self.otherPlayerPlaying.toggle()
                        self.currentlyPlaying.toggle()
                        print("After the move, the local player is playing?: ", self.currentlyPlaying)
                        print("After the move, the local player is : ", self.currentPlayer.rawValue)
                        _ = self.board?.performMove(from: move.source, to: move.destination, player: self.currentPlayer)
                        self.currentPlayer = self.currentPlayer == .player1 ? .player2 : .player1
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.isGameOver = true
                        }
                    }
                    if self.currentPlayer == .initial {
                        let isLocalPlayerStart = self.priority > gameState.priority
                        self.currentPlayer = isLocalPlayerStart ? .player1 : .player2
                        self.otherPlayerPlaying = !isLocalPlayerStart
                        print("After receiving the first data, local player is \(self.currentPlayer.rawValue)")
                        self.currentlyPlaying = isLocalPlayerStart
                        print("After receiving the first data, Local player is playing?: \(self.currentlyPlaying)")
                        print("After receiving the first data, remote player is playing?: ", self.otherPlayerPlaying)
                    }
                    if gameState.goneToBackground {
                        DispatchQueue.main.async {
                            self.connectionLost = true
                        }
                    }
                    self.otherPriority = gameState.priority
                    print("This is other priority: \(self.otherPriority)")

                }
            }
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        DispatchQueue.main.async {
                switch state {
                case .connected:
                    print("\(player.displayName) connected")
                case .disconnected:
                    print("\(player.displayName) disconnected")
                    self.connectionLost = true
                case .unknown:
                    print("Unknown state for player \(player.displayName)")
                @unknown default:
                    print("A new, unknown state was added")
                }
            }
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }


    func startGame(newMatch: GKMatch) {
        match = newMatch
        match?.delegate = self
        otherPlayer = match?.players.first

        // Generate a random priority
        priority = Int.random(in: 1...10000)
        print("This is my priority: \(self.priority)")

        // Create initial game state.
        let gameState = GameState(isPaused: self.isPaused, isGameOver: self.isGameOver, currentPlayer: self.currentPlayer, currentlyPlaying: false, priority: self.priority)

        // Encode the initial game state into a message.
        let message = GameMessage(messageType: .gameState, move: nil, gameState: gameState)

        // Send the initial game state to the other player.
        if let data = self.encodeMessage(message) {
            do {
                try self.match!.sendData(toAllPlayers: data, with: .reliable)
            } catch {
                print("Error sending data: \(error.localizedDescription)")
            }
        }
        
    }
    
    func resetGame() {
        match?.delegate = nil
        match = nil
        otherPlayer = nil
        DispatchQueue.main.async {
            self.path.removeAll()
        }
    }
    
    func startObservingAppLifecycle() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func appWillResignActive() {
        // Start the background timer
        backgroundTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
            self.connectionLost = true
            let gameState = GameState(isPaused: true, isGameOver: self.isGameOver, currentPlayer: self.currentPlayer, priority: self.priority, goneToBackground: true)
            let message = GameMessage(messageType: .gameState, move: nil, gameState: gameState)
            if let data = self.encodeMessage(message) {
                do {
                    try self.match?.sendData(toAllPlayers: data, with: .reliable)
                } catch {
                    print("Failed to send background message: ", error)
                }
            }
        }
    }
    @objc func appDidBecomeActive() {
        // Invalidate the timer since the player returned to the app
        backgroundTimer?.invalidate()
        backgroundTimer = nil
    }
 
    
    
    func processMove(_ move: Move) {
        // Update the board with the move
        self.currentPlayer = self.currentPlayer == .player1 ? .player2 : .player1
        self.otherPlayerPlaying.toggle()
        self.currentlyPlaying.toggle()
        
        // Check if cell is already converted
        if let convertedPieces = self.board?.performMove(from: move.source, to: move.destination, player: self.currentPlayer) {
            if !convertedPieces.isEmpty {
                SoundManager.shared.playConvertSound()
                HapticManager.shared.notification(type: .success)
                for piece in convertedPieces {
                    convertedCells.append((row: piece.row, col: piece.col, byPlayer: currentPlayer))
                    previouslyConvertedCells.append((row: piece.row, col: piece.col, byPlayer: currentPlayer))

                   }
            }
        }
        self.currentPlayer = self.currentPlayer == .player1 ? .player2 : .player1
        self.remainingTime = 15
    }
    
}
