//
//  GameCenterView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 7.07.2023.
//

import GameKit
import SwiftUI

struct GameCenterView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var menuViewModel: MenuViewModel // Inject the MenuViewModel
    @EnvironmentObject var gameCenterController: GameCenterManager

        class Coordinator: NSObject, GKMatchmakerViewControllerDelegate {
            var parent: GameCenterView
                var gameCenterController: GameCenterManager
                var menuViewModel: MenuViewModel  // Add this property

                init(_ parent: GameCenterView, gameCenterController: GameCenterManager, menuViewModel: MenuViewModel) {
                    self.parent = parent
                    self.gameCenterController = gameCenterController
                    self.menuViewModel = menuViewModel  // Initialize the property
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
//                        self.gameCenterController.startGame(newMatch: match)

                        self.menuViewModel.path.append(3)
                        
                        // Initialize the game in GameCenterController
//                        self.gameCenterController.initializeGame()
                    }
                }
        }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, gameCenterController: gameCenterController, menuViewModel: menuViewModel)
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



//enum MessageType: Int, Codable {
//    case move
//    case gameState
//    case firstPlayer
//}
//
//struct GameMessage: Codable {
//    let messageType: MessageType
//    let move: CodableMove?
//    let gameState: GameState?
//}
//
//struct GameState: Codable {
//    var isPaused: Bool
//    var isGameOver: Bool
//    var currentPlayer: CellState
//    let firstPlayerID: String
//    
//    enum CodingKeys: CodingKey {
//        case isPaused, isGameOver, currentPlayer, firstPlayerID
//    }
//    
//    // You'll need to provide a custom initializer from decoder because CellState is a non-string RawRepresentable
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        isPaused = try container.decode(Bool.self, forKey: .isPaused)
//        isGameOver = try container.decode(Bool.self, forKey: .isGameOver)
//        firstPlayerID = try container.decode(String.self, forKey: .firstPlayerID)
//        let currentPlayerRawValue = try container.decode(Int.self, forKey: .currentPlayer)
//        currentPlayer = CellState(rawValue: currentPlayerRawValue) ?? .empty
//    }
//    
//    // Also a custom method to encode to a container because CellState is a non-string RawRepresentable
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(isPaused, forKey: .isPaused)
//        try container.encode(isGameOver, forKey: .isGameOver)
//        try container.encode(firstPlayerID, forKey: .firstPlayerID)
//        try container.encode(currentPlayer.rawValue, forKey: .currentPlayer)
//    }
//}



