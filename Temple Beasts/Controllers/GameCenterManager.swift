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
}

class GameCenterManager: NSObject, GKMatchDelegate, ObservableObject {
    @Published var isPaused: Bool = false
    @Published var isGameOver: Bool = false
    @Published var currentPlayer: CellState
    @Published var currentlyPlaying = false
    @Published var otherPlayerPlaying: Bool = false
    @Published var remainingTime = 15

    
    
    var localPlayer = GKLocalPlayer.local
    var otherPlayer: GKPlayer?
    var priority: Int = 0
    var otherPriority = 0

    init(currentPlayer: CellState) {
        self.currentPlayer = currentPlayer
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
                UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true, completion: nil)
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
                    self.currentPlayer = self.currentPlayer == .player1 ? .player2 : .player1
                    self.otherPlayerPlaying.toggle()
                    self.currentlyPlaying.toggle()
                    print("After the move, the local player is playing?: ", self.currentlyPlaying)
                    print("After the move, the local player is : ", self.currentPlayer.rawValue)
                    _ = self.board?.performMove(from: move.source, to: move.destination, player: self.currentPlayer)
                    self.currentPlayer = self.currentPlayer == .player1 ? .player2 : .player1
                    // Check for game over after performing the move
                    guard let gameState = message.gameState else { return }
//                    if gameState.isGameOver == true {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            self.isGameOver = true
//                        }
//                    }
                    self.remainingTime = 15


                case .gameState:
                    guard let gameState = message.gameState else { return }
                    if let isPause = gameState.isPaused {
                        self.isPaused = isPause
                    }
                    if let isOver = gameState.isGameOver, isOver {
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
                    self.otherPriority = gameState.priority
                    print("This is other priority: \(self.otherPriority)")

                }
            }
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        // IMPLEMENT THIS LATER. IT CONFIGURES WHEN A PLAYER DISCONNECTS
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }


    func startGame(newMatch: GKMatch) {
        match = newMatch
        match?.delegate = self
        otherPlayer = match?.players.first

        // Generate a random priority
        priority = Int.random(in: 1...100)
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
}

// enum PlayerAuthState: String {
//    case authenticating = "Logging in to Game Center..."
//    case unauthenticated = "Please sign in to Game Center to play."
//    case authenticated = "Successfully authenticated"
//
//    case error = "There was an error logging into Game Center"
//    case restricted = "You're not allowed to player multiplayer games!"
// }
//

// extension GameCenterController: GKMatchmakerViewControllerDelegate {
//    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
//        viewController.dismiss(animated: true)
//        startGame(newMatch: match)
//
//    }
//    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
//        viewController.dismiss(animated: true)
//
//    }
//    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
//        viewController.dismiss(animated: true)
//    }
//
// }
//
//

// extension GameCenterController: GKMatchDelegate {
//    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
//        let content = String(decoding: data, as: UTF8.self)
//
//
//        if content.starts(with: "strData:") {
//            let message = content.replacing("strData:", with: "")
//            receivedData(message)
//        } else {
//
//        }
//    }
//
//    func sendString(_ message: String) {
//        guard let encoded = "strData:\(message)".data(using: .utf8) else { return }
//        sendData(encoded, mode: .reliable)
//
//    }
//
//    func sendData(_ data: Data, mode: GKMatch.SendDataMode) {
//        do {
//            try match?.sendData(toAllPlayers: data, with: mode)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
//    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
//
//    }
// }

//    func startMatchMaking() {
//        let request = GKMatchRequest()
//        request.minPlayers = 2
//        request.maxPlayers = 2
//
//        let matchMakinVC = GKMatchmakerViewController(matchRequest: request)
//        matchMakinVC?.matchmakerDelegate = self
//        rootViewController?.present(matchMakinVC!, animated: true)
//
//
//    }
//
//    func startGame(newMatch: GKMatch) {
//        match = newMatch
//        match?.delegate = self
//        otherPlayer = match?.players.first
//    }
//
//    func receivedData(_ message: String) {
//        let messageSplit = message.split(separator: ":")
//        guard let messagePrefix = messageSplit.first else { return }
//        let parameter = String(messageSplit.last ?? "")
//        switch messagePrefix {
//        case "began":
//            if playerUUIDKey == parameter {
//                playerUUIDKey == UUID().uuidString
//                sendString("began:\(playerUUIDKey)")
//                break
//            }
//
//            currentlyMakingAMove = playerUUIDKey < parameter
//            inGame = true
//
//
//
//        default:
//            break
//        }
//    }
