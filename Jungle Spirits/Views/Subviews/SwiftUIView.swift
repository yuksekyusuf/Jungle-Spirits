//
//  SwiftUIView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 13.01.2024.
//

import SwiftUI
import Pow

struct IrisView: View {
    let mapNumber: Int
    let mapName: String
    let levelBundle: GameLevelBundle
    @Binding var heartStatus: Bool
    @State var firstShow: Bool = true
    @EnvironmentObject var gameCenterManager: GameCenterManager
    var body: some View {
        ZStack {
           
           
//                LevelMapView(gameLevelBundle: levelBundle, showHeartStatus: $heartStatus)

            if firstShow {
                SealedMapView()
                    .transition(.movingParts.iris(blurRadius: 10))
            }
//            if  {
////                if  {
////
////                }
//
//            } else if !firstShow {
//
//            }
            
//            else {
//                if levelBundle == gameCenterManager.currentBundle {
//                    LevelMapView(gameLevelBundle: levelBundle, showHeartStatus: $heartStatus)
//                } else {
//                    SealedMapView()
//                }
//            }
        }
        .onTapGesture {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(dampingFraction: 1)) {
                    firstShow.toggle()
                }
            }
        }
//        .onAppear {
//            if firstShow == false {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    withAnimation(.spring(dampingFraction: 1)) {
//                        firstShow = true
//                    }
//                }
//            }
//
//
//        }
        
    }
}
//
struct GlowExample: View {
    @State var isFormValid = false

    var body: some View {
        ZStack {
            Color.clear
            JungleButtonView(text: "ENTER THE JUNGLE", width: 300, height: 50)
                .conditionalEffect(.repeat(.glow(color: .blue, radius: 70), every: 1.5  ),
                                   condition: isFormValid)
            .animation(.default, value: isFormValid)
            .onTapGesture {
                isFormValid.toggle()
            }
        }
    }

}


struct IrisView_Previews: PreviewProvider {
    static var previews: some View {
        @State var status = false
        IrisView(mapNumber: 1, mapName: "Random", levelBundle: GameLevelBundle.bundle1, heartStatus: $status).environmentObject(GameCenterManager(currentPlayer: .player1))
    }
}
