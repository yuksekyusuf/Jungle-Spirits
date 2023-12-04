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
    var body: some View {
            VStack {
//                Text("\(mapNumber). " + mapName)
//                    .font(.custom("TempleGemsRegular", size: 24))
//                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).tracking(0.84).multilineTextAlignment(.center).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:0, x:0, y:1)                .tracking(0.72)
//                    .multilineTextAlignment(.center)
//                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:0, x:0, y:1)
//                    .padding(.bottom, 30)
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
