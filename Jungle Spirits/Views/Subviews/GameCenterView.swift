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
    @Binding var isPresentingMatchmaker: Bool
    
    class Coordinator: NSObject, GKMatchmakerViewControllerDelegate, GKInviteEventListener {
        var parent: GameCenterView
        var gameCenterController: GameCenterManager
        var recipients = [GKPlayer]()
        
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
            DispatchQueue.main.async {
                self.gameCenterController.path.append(Int.random(in: 100...10000))
                self.gameCenterController.startGame(newMatch: match)
            }
        }
        
        
        func player(_ player: GKPlayer, didAccept invite: GKInvite) {
            gameCenterController.invite = invite
            DispatchQueue.main.async {
                self.gameCenterController.isMatchmakingPresented = true
            }

        }
        
        func player(_ player: GKPlayer, didRequestMatchWithRecipients recipientPlayers: [GKPlayer]) {
            gameCenterController.recipients = recipientPlayers
            DispatchQueue.main.async {
                self.gameCenterController.isMatchmakingPresented = true
                
            }
            
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, gameCenterController: gameCenterController)
    }
    func makeUIViewController(context: Context) -> GKMatchmakerViewController {
        gameCenterController.matchRequest?.minPlayers = 2
        gameCenterController.matchRequest?.maxPlayers = 2
        if let invite = gameCenterController.invite {
            let mvc = GKMatchmakerViewController(invite: invite)
            mvc?.matchmakerDelegate = context.coordinator
            return mvc!
        }

        let vc = GKMatchmakerViewController(matchRequest: gameCenterController.matchRequest!)
        vc?.matchmakerDelegate = context.coordinator
        return vc!
        
    }
    func updateUIViewController(_ uiViewController: GKMatchmakerViewController, context: Context) {
        // Update the view controller
    }
    
}


//extension GameCenterView {
//    func showMatchmakerViewController() {
//        guard let coordinator = self.makeCoordinator() else { return }
//        coordinator.presentMatchmakerViewController()
//    }
//}

// Extend Coordinator to conform to GKInviteEventListener
//extension GameCenterView.Coordinator: GKInviteEventListener {
//    // Handle received invitation
//    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
//        guard let matchmakerVC = GKMatchmakerViewController(invite: invite) else { return }
//        matchmakerVC.matchmakerDelegate = self
//        if let rootViewController = getRootViewController() {
//            DispatchQueue.main.async {
//                rootViewController.present(matchmakerVC, animated: true)
//            }
//        }
//    }
//    
//    
//    
//    // Optionally, implement method to handle matchmaking for invited players
//    func player(_ player: GKPlayer, didRequestMatchWithRecipients recipientPlayers: [GKPlayer]) {
//        let request = GKMatchRequest()
//        request.recipients = recipientPlayers
//        request.maxPlayers = 2
//        request.minPlayers = 2
//        if let matchmakerVC = GKMatchmakerViewController(matchRequest: request) {
//            matchmakerVC.matchmakerDelegate = self
//            DispatchQueue.main.async {
//                self.parent.isPresentingMatchmaker = true
//            }
//        }
//    }
//    
//    func getRootViewController() -> UIViewController? {
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let rootViewController = windowScene.windows.first?.rootViewController else {
//            return nil
//        }
//        return rootViewController
//    }
//}
