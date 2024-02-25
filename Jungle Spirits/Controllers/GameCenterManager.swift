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

class GameCenterManager: NSObject, GKMatchDelegate, ObservableObject, GKLocalPlayerListener {
    
    @Published var isPaused: Bool = false
    @Published var isGameOver: Bool = false
    @Published var currentPlayer: CellState
    @Published var currentlyPlaying = false
    @Published var otherPlayerPlaying: Bool = false
    @Published var remainingTime = 15
    @Published var isQuitGame = false
//    @Published var path: [Int] = []
    @Published var path = NavigationPath()

    @Published var connectionLost: Bool = false
    @Published  var convertedCells: [(row: Int, col: Int, byPlayer: CellState)] = []
    @Published  var previouslyConvertedCells: [(row: Int, col: Int, byPlayer: CellState)] = []
    
    @Published var isSelected = false
    @Published var selectedCell: (row: Int, col: Int)? = nil
    
    @Published var localPlayerImage: UIImage? = nil
    @Published var localPlayerName: String = GKLocalPlayer.local.displayName ?? "Unknown Player"
    @Published var remotePlayerName: String? = nil
    @Published var remotePlayerImage: UIImage? = nil    
    @Published var isSearchingForMatch = false
    @Published var isMatchFound = false
    @Published var invite: GKInvite?
//    @Published var remainingHearts: Int = UserDefaults.standard.integer(forKey: "hearts")
    @Published var achievedLevel: GameLevel = GameLevel.level1_1
    @Published var currentLevel: GameLevel? = nil
    @Published var currentBundle: GameLevelBundle = GameLevelBundle.bundle1
    
    //MARK: - Heart Timer
    @Published var heartTimer: Timer?
    @Published var remainingHeartTime: String = "0:00"
    private let heartTimeInterval: TimeInterval = 900
    func startHeartTimer() {
        heartTimer?.invalidate()
        heartTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateRemainingTime()
        }
    }
    

    
    //MARK: - GROUP ACTIVITY
    var recipients = [GKPlayer]()
    var matchRequest: GKMatchRequest?
  
    
    
    private func timeUntilNextHeart() -> TimeInterval {
           let lastHeartTime = UserDefaults.standard.double(forKey: "lastHeartTime")
           let lastTime = Date(timeIntervalSinceReferenceDate: lastHeartTime)
           let elapsedTime = Date().timeIntervalSince(lastTime)
           let remainingTime = heartTimeInterval - (elapsedTime.truncatingRemainder(dividingBy: heartTimeInterval))
           return max(0, remainingTime)
       }

       private func formatTimeForDisplay(seconds: TimeInterval) -> String {
           let minutes = Int(seconds) / 60
           let remainingSeconds = Int(seconds) % 60
           return "\(minutes):\(String(format: "%02d", remainingSeconds))"
       }

       private func updateRemainingTime() {
           let time = timeUntilNextHeart()
           remainingHeartTime = formatTimeForDisplay(seconds: time)
       }
       
       deinit {
           heartTimer?.invalidate()
       }
    
    
    

    var onAuthenticated: (() -> Void)?

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
        matchRequest = GKMatchRequest()
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
    
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        self.invite = invite
    }
    
    func fetchLocalPlayerImage() {
        GKLocalPlayer.local.loadPhoto(for: .normal) { [weak self] image, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to load player photo: \(error.localizedDescription)")
                    return
                }
                self?.localPlayerImage = image
                print("local player image", image)
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
                GKLocalPlayer.local.register(self)
                self.isUserAuthenticated = true
                self.onAuthenticated?()
                
            } else if let vc = gcAuthVC {
                // Show game center login UI
//                rootViewController?.present(vc, animated: true)
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
                // MOVE THE QUICKMATCH METHODS HERE!!!
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
        print("Other player", otherPlayer)
        if match?.expectedPlayerCount != 0 {
            print("Still waiting for \(match?.expectedPlayerCount) players to connect.")
        }
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
//            self.path.removeAll()
            self.path = NavigationPath()
        }
    }
    
    func startObservingAppLifecycle() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func appWillResignActive() {
        // Start the background timer
        backgroundTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
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
        print("\(matchRequest)")
    }
    
}

///comment test

extension GameCenterManager {
    // Start Group Activity and wait for recipients
    @available(iOS 16.2, *)
    func startGroupActivity() {
        GKMatchmaker.shared().startGroupActivity { [weak self] player in
            print("Found a player: \(player)")
            self?.recipients.append(player)
        }
    }

    // Async method to start the match
//    func startMatch() async throws -> GKMatch? {
//        guard let matchRequest = self.matchRequest else {
//            return nil
//        }
//        matchRequest.recipients = self.recipients
//
//        do {
//            let match = try await GKMatchmaker.shared().findMatch(for: matchRequest)
//            DispatchQueue.main.async {
//                // Configure your game to start with the found match
//                self.startGame(newMatch: match)
//            }
//            return match
//        } catch {
//            print("Failed to find a match: \(error)")
//            throw error
//        }
//    }
}

//extension GameCenterManager {
//    func findMatch(for request: GKMatchRequest) async throws -> GKMatch {
//        return try await withCheckedThrowingContinuation { continuation in
//            GKMatchmaker.shared().findMatch(for: request) { match, error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                } else if let match = match {
//                    continuation.resume(returning: match)
//                } else {
//                    continuation.resume(throwing: NSError(domain: "com.yourappname.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "No match found and no error provided."]))
//                }
//            }
//        }
//    }
//
//    func startQuickMatch() {
//        isSearchingForMatch = true
//
//        let matchRequest = GKMatchRequest()
//        matchRequest.minPlayers = 2
//        matchRequest.maxPlayers = 2
//
//        Task {
//            do {
//                let match = try await self.findMatch(for: matchRequest)
//                match.delegate = self
//
//                DispatchQueue.main.async {
//                    if let remotePlayer = match.players.first {
//                        remotePlayer.loadPhoto(for: .normal) { [weak self] (image, error) in
//                            guard let self = self else { return }
//
//                            if let image = image {
//                                self.remotePlayerImage = image
//                                self.remotePlayerName = remotePlayer.displayName
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                    self.isMatchFound = true
//                                    self.startGame(newMatch: match)
//                                    self.path.append(3)
//                                }
//                            }
//                        }
//                    }
//                }
//            } catch {
//                print("Matchmaking failed with error: \(error.localizedDescription)")
//            }
//        }
//    }
//}

extension GameCenterManager {
//    func findMatch(for request: GKMatchRequest) async throws -> GKMatch {
//        return try await withCheckedThrowingContinuation { continuation in
//            GKMatchmaker.shared().findMatch(for: request) { match, error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                } else if let match = match {
//                    continuation.resume(returning: match)
//                } else {
//                    continuation.resume(throwing: NSError(domain: "com.yourappname.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "No match found and no error provided."]))
//                }
//            }
//        }
//    }
//
//    func startQuickMatch() {
//        isSearchingForMatch = true
//
//        let matchRequest = GKMatchRequest()
//        matchRequest.minPlayers = 2
//        matchRequest.maxPlayers = 2
//
//        Task {
//            do {
//                let match = try await GKMatchmaker.shared().findMatch(for: matchRequest)
//                match.delegate = self
//                self.remotePlayerName = otherPlayer?.displayName
//
//                DispatchQueue.main.async { [weak self] in
//                    guard let self = self else { return }
//
//                    if let remotePlayer = match.players.first {
//                        remotePlayer.loadPhoto(for: .normal) { (image, error) in
//                            if let image = image {
//                                self.remotePlayerImage = image
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                    self.isMatchFound = true
//                                    self.startGame(newMatch: match)
//                                    self.path.append(3)
//                                }
//                            }
//                        }
//                    }
//                }
//            } catch {
//                print("Matchmaking failed with error: \(error.localizedDescription)")
//            }
//        }
//    }
//
    


    func startQuickMatch() {
            isSearchingForMatch = true

            let matchRequest = GKMatchRequest()
            matchRequest.minPlayers = 2
            matchRequest.maxPlayers = 2

            GKMatchmaker.shared().findMatch(for: matchRequest, withCompletionHandler: { [weak self] (match, error) in
                guard let self = self else { return }
                print("Is matched?2 ", match)




                    if let error = error {
                        print("Matchmaking failed with error: \(error.localizedDescription)")
                        return
                    }

                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
                    if let match = match {
                        match.delegate = self
                        print("is match delegate", match.delegate)
                        print("Remote player, ", match.players.first)
                        self.isSearchingForMatch = false
                        self.otherPlayer = match.players.first
                        self.remotePlayerName = self.otherPlayer?.displayName
                        self.startGame(newMatch: match)
                        self.otherPlayer?.loadPhoto(for: .small) {(image, error) in
                            if let image = image {
                                self.remotePlayerImage = image
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    print("Remote player, ", match.players.first)
                                    self.isMatchFound = true
                                    self.path.append(Int.random(in: 100...10000))
                                    print("is match delegate", match.delegate)

                                }
                            }
                        }
//                        self.isMatchFound = true
//                        self.startGame(newMatch: match)
//                        self.path.append(3)
//                        self.currentPlayer = .initial
//                        if let remotePlayer = match.players.first {
//                            remotePlayer.loadPhoto(for: .normal) {
//                                if let image = image {
//                                    self.remotePlayerImage = image
//                                    self.remotePlayerName = remotePlayer.displayName
//
//                                }
//                            }
//                        }
                        print("When players are matched, their current player state is ", self.currentPlayer.rawValue)
                    } else {
                        print("No match found or an unknown error occurred.")
                    }
                }

//                    if let match = match {
//                        match.delegate = self
//                        print("is match delegate", match.delegate)
//                        print("Remote player, ", match.players.first)
//                        currentPlayer = .initial
//                        print("When players are matched, their current player state is ", currentPlayer.rawValue)
//
//                        if let remotePlayer = match?.players.first {
//                            remotePlayer.loadPhoto(for: .normal) { (image, error) in
//                                if let image = image {
//                                    self.remotePlayerImage = image
//                                    self.remotePlayerName = remotePlayer.displayName
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                        print("Remote player, ", match.players.first)
//
//                                        self.isMatchFound = true
//                                        self.startGame(newMatch: match)
//                                        self.path.append(3)
//                                        print("is match delegate", match.delegate)
//
//                                    }
//                                }
//                            }
//                        }
////
//                    } else {
//                        print("No match found or an unknown error occurred.")
//                    }

            })
        }
}


//extension GameCenterManager: GKMatchmakerViewControllerDelegate {
//    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
//
//    }
//
//    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
//
//    }
//
//    func presentMatchmaker() {
//            isSearchingForMatch = true
//
//            let matchRequest = GKMatchRequest()
//            matchRequest.minPlayers = 2
//            matchRequest.maxPlayers = 2
//
//            if let viewController = GKMatchmakerViewController(matchRequest: matchRequest) {
//                viewController.matchmakerDelegate = self
//                // You can present this view controller, or just keep it in the background if you don't want the default UI.
//            }
//
//        }
//
//    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
//           self.match = match
//           self.otherPlayer = match.players.first
//
//            self.otherPlayer?.loadPhoto(for: .normal) {(image, error) in
//            if let image = image {
//                self.remotePlayerImage = image
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    print("Remote player, ", match.players.first)
//                    self.isMatched = true
//                    self.isMatchFound = true
//                    self.startGame(newMatch: match)
//                    self.path.append(3)
//                    print("is match delegate", match.delegate)
//
//                }
//            }
//        }
//       }
//}
