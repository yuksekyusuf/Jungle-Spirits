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
    var isPaused: Bool
    var isGameOver: Bool
    var currentPlayer: CellState
    
}

class GameCenterManager: NSObject, GKMatchDelegate, ObservableObject {
    
    @Published var isPaused: Bool = false
    @Published var isGameOver: Bool = false
    @Published var currentPlayer: CellState
    
    @Published var currentlyPlaying = false
    var localPlayer = GKLocalPlayer.local
    var otherPlayer: GKPlayer?
    
    
    init(currentPlayer: CellState) {
        self.currentPlayer = currentPlayer
    }
    
    @Published var isUserAuthenticated = false
    @Published var match: GKMatch?
    {
        didSet {
            self.isMatched = match != nil
            if let match = match {
                
                match.delegate = self
                otherPlayer = match.players.first
                self.currentPlayer = self.randomStartingPlayer()

                if let otherPlayer = otherPlayer?.teamPlayerID {
                    if localPlayer.teamPlayerID > otherPlayer {
                        currentlyPlaying = true
//                        currentPlayer = .player1
                    } else if localPlayer.teamPlayerID < otherPlayer {
                        currentlyPlaying = false
//                        currentPlayer = .player2
                    }
                    
                }
            }
        }
    }
    @Published var isMatched = false
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
    
    func encodeMove(_ move: Move) -> Data? {
        let codableMove = CodableMove.fromMove(move)
        let encoder = JSONEncoder()
        return try? encoder.encode(codableMove)
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
                            guard let gameState = message.gameState else { return }
                            let move = Move.fromCodable(codableMove)
                            self.board?.performMove(from: move.source, to: move.destination, player: self.currentPlayer)
                            
                            self.currentPlayer = gameState.currentPlayer
                            self.currentlyPlaying = self.currentPlayer == (self.localPlayer == self.otherPlayer ? .player1 : .player2)
                            
                        case .gameState:
                            guard let gameState = message.gameState else { return }
                            self.isPaused = gameState.isPaused
                            self.isGameOver = gameState.isGameOver
                            self.currentPlayer = gameState.currentPlayer
                            self.currentlyPlaying = self.currentPlayer == (self.localPlayer == self.otherPlayer ? .player1 : .player2)
                        }
                    }
        }
        
    }
    
 
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        //IMPLEMENT THIS LATER. IT CONFIGURES WHEN A PLAYER DISCONNECTS
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        
    }
    
    func randomStartingPlayer() -> CellState {
        let randomNumber = Int.random(in: 1...2)
        return randomNumber == 1 ? .player1 : .player2
    }
    
    // In GameCenterController
    func initializeGame() {
        // Determine initial player and whether the local player is currently playing.
//        self.currentPlayer = self.randomStartingPlayer()


        // Create initial game state.
        let gameState = GameState(isPaused: self.isPaused, isGameOver: self.isGameOver, currentPlayer: self.currentPlayer)

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
    func startGame(newMatch: GKMatch) {
        match = newMatch
        match?.delegate = self
        otherPlayer = match?.players.first
        
        // Determine the starting player randomly
        self.currentPlayer = self.randomStartingPlayer()

        // Create initial game state.
        let gameState = GameState(isPaused: self.isPaused, isGameOver: self.isGameOver, currentPlayer: self.currentPlayer)

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
//        if let otherPlayer = otherPlayer?.teamPlayerID {
//            if localPlayer.teamPlayerID > otherPlayer {
//                currentlyPlaying = true
////                        currentPlayer = .player1
//            } else if localPlayer.teamPlayerID < otherPlayer {
//                currentlyPlaying = false
////                        currentPlayer = .player2
//            }
//
//        }
    }
}












//enum PlayerAuthState: String {
//    case authenticating = "Logging in to Game Center..."
//    case unauthenticated = "Please sign in to Game Center to play."
//    case authenticated = "Successfully authenticated"
//
//    case error = "There was an error logging into Game Center"
//    case restricted = "You're not allowed to player multiplayer games!"
//}
//


//extension GameCenterController: GKMatchmakerViewControllerDelegate {
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
//}
//
//

//extension GameCenterController: GKMatchDelegate {
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
//}


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
