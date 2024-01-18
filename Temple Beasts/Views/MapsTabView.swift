//
//  MapsTabView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 15.11.2023.
//

import SwiftUI
import Pow

//struct MapsTabView: View {
//
//    let mapNumber: Int
//    let mapName: String
//    let levelBundle: GameLevelBundle
//    @Binding var heartStatus: Bool
////    @Binding var sealed: Bool
//    @State var firstShow: Bool = UserDefaults.standard.bool(forKey: "fi")
//    @EnvironmentObject var gameCenterManager: GameCenterManager
//    var body: some View {
//            ZStack {
//                if levelBundle == GameLevelBundle.bundle1 {
//                    LevelMapView(gameLevelBundle: levelBundle, showHeartStatus: $heartStatus)
//                    if !firstShow {
//                        SealedMapView()
//                            .transition(.movingParts.iris(blurRadius: 10))
//                            .zIndex(1)
//
//                    }
//
//                } else {
//                    if levelBundle == gameCenterManager.currentBundle {
//                        LevelMapView(gameLevelBundle: levelBundle, showHeartStatus: $heartStatus)
//                    } else {
//                        SealedMapView()
//                    }
//                }
//            }
//            .onAppear {
//                if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") == true {
//                    UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
//
//                }
//
//
//                if firstShow == false {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        withAnimation(.spring()) {
//                            firstShow.toggle()
//                            UserDefaults.
//                        }
//                    }
//                }
//
//
//            }
//
//
//
//
//    }
//}

struct MapsTabView_Previews: PreviewProvider {
    static var previews: some View {
        @State var status = false
        MapsTabView(mapNumber: 1, mapName: "Into the valley", levelBundle: GameLevelBundle.bundle3, heartStatus: $status).environmentObject(GameCenterManager(currentPlayer: .player1))
    }
}


struct MapsTabView: View {

    let mapNumber: Int
    let mapName: String
    let levelBundle: GameLevelBundle
    @Binding var heartStatus: Bool
    @State private var showSeal = UserDefaults.standard.bool(forKey: "firstShowMap")
//    @State var firstShow: Bool = UserDefaults.standard.bool(forKey: "firstShowMap")
    @EnvironmentObject var gameCenterManager: GameCenterManager
    var body: some View {
        ZStack {

            if levelBundle == gameCenterManager.currentBundle {
                LevelMapView(gameLevelBundle: levelBundle, showHeartStatus: $heartStatus)
            } else {
                SealedMapView()
            }

            if !showSeal {
                SealedMapView()
                    .transition(.movingParts.iris(blurRadius: 10))
                    .zIndex(1)
            }
        }
        .onAppear {
            if UserDefaults.standard.bool(forKey: "firstShowMap") == false {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.spring(dampingFraction: 1)) {
                        showSeal = true
                        UserDefaults.standard.set(true, forKey: "firstShowMap")
                    }
                }
            }


        }
    }
}
