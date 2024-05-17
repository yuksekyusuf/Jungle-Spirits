//
//  VanishView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 12.01.2024.
//

import SwiftUI
import Pow

struct PopUpWinView: View {
    @EnvironmentObject var gameCenterController: GameCenterManager
    @EnvironmentObject var heartManager: HeartManager
    @State var isAdded: Bool = false
    let gameType: GameType
    let winner: CellState
    @Binding var showWinView: Bool
    
    var body: some View {
        ZStack{
            if isAdded {
                WinView(showWinMenu: $isAdded, isPaused: $gameCenterController.isPaused, remainingTime: $gameCenterController.remainingTime, gameType: gameType, winner: winner, currentPlayer: $gameCenterController.currentPlayer, remainingHearts: $heartManager.currentHeartCount, onContinue: {
                        withAnimation {
                            isAdded.toggle()
                            showWinView.toggle()
                        }
                    })
                    .frame(width: 250, height: 250)
                    .transition(AnyTransition.asymmetric(insertion: .movingParts.swoosh.combined(with: .opacity), removal: .movingParts.vanish(.blue)))

            }
        }
        .autotoggle($isAdded, with: .spring())
        
    }
}




struct PopUpWinView_Previews: PreviewProvider {
    static var previews: some View {
        @State var hearts = 5
        @State var boolion = false
        PopUpWinView(gameType: .ai, winner: .player1, showWinView: $boolion)
            .environmentObject(GameCenterManager(currentPlayer: .player1))
            .environmentObject(HeartManager.shared)
    }
}




