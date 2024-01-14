//
//  MapsTabView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 15.11.2023.
//

import SwiftUI

struct MapsTabView: View {
    
    let mapNumber: Int
    let mapName: String
    let levelBundle: GameLevelBundle
    @Binding var heartStatus: Bool
//    @Binding var sealed: Bool
    var body: some View {
            VStack {
                LevelMapView(gameLevelBundle: levelBundle, showHeartStatus: $heartStatus)
            }
    
        
    }
}

struct MapsTabView_Previews: PreviewProvider {
    static var previews: some View {
        @State var status = false
        MapsTabView(mapNumber: 1, mapName: "Into the valley", levelBundle: GameLevelBundle.bundle1, heartStatus: $status).environmentObject(GameCenterManager(currentPlayer: .player1))
    }
}
