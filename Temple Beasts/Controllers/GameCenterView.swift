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
    @EnvironmentObject var gameCenterController: GameCenterManager
    
    class Coordinator: NSObject, GKMatchmakerViewControllerDelegate {
        var parent: GameCenterView
        var gameCenterController: GameCenterManager
        
        init(_ parent: GameCenterView, gameCenterController: GameCenterManager) {
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
                self.gameCenterController.path.append(3)
                self.gameCenterController.startGame(newMatch: match)
                
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
