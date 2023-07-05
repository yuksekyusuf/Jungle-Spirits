//
//  GameCenterController.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5.07.2023.
//

import SwiftUI
import UIKit
import GameKit

class GameCenterController: ObservableObject {
    @Published var isUserAuthenticated = false
    @Published var match: GKMatch? {
        didSet {
            self.isMatched = match != nil
        }
    }
    @Published var isMatched = false


    
    init() {
        authenticateUser()
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

}

struct GameCenterView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
        @EnvironmentObject var gameCenterController: GameCenterController

        class Coordinator: NSObject, GKMatchmakerViewControllerDelegate {
            var parent: GameCenterView
            var gameCenterController: GameCenterController

            init(_ parent: GameCenterView, gameCenterController: GameCenterController) {
                self.parent = parent
                self.gameCenterController = gameCenterController
            }

            func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
                parent.presentationMode.wrappedValue.dismiss()
            }

            func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
                print("Matchmaker vc did fail with error: \(error.localizedDescription)")
            }

            func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
                parent.presentationMode.wrappedValue.dismiss()
                // Here you get the match object, which you can use to send and receive data between players
                DispatchQueue.main.async {
                    self.gameCenterController.match = match
                }
            }
        }

        func makeCoordinator() -> Coordinator {
            Coordinator(self, gameCenterController: gameCenterController)
        }

        func makeUIViewController(context: Context) -> GKMatchmakerViewController {
            let matchRequest = GKMatchRequest()
            matchRequest.minPlayers = 2
            matchRequest.maxPlayers = 2
            let vc = GKMatchmakerViewController(matchRequest: matchRequest)
            vc?.matchmakerDelegate = context.coordinator
            return vc!
        }

        func updateUIViewController(_ uiViewController: GKMatchmakerViewController, context: Context) {
            // Update the view controller
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
