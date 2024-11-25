//
//  LevelMapView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 10.11.2023.
//

struct Level {
    let id: Int
    let unlocked: Bool
    let position: CGPoint
}

import SwiftUI

struct LevelMapView: View {
    @EnvironmentObject var gameCenterController: GameCenterManager
    let gameLevelBundle: GameLevelBundle
    @Binding var showHeartStatus: Bool
    let isTutorial: Bool
    var body: some View {
        Image(levelMapName(for: gameLevelBundle))
            .resizable()
            .scaledToFit()
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .overlay {
                GeometryReader { geo in
                    VStack {
                        if isTutorial {
                            LevelButtonNavigation(showHeartStatus: $showHeartStatus, gameLevel: gameLevelBundle.levels[0], boardSize: gameLevelBundle.levels[0].boardSize, obstacles: gameLevelBundle.levels[0].obstacles, level: gameLevelBundle.levels[0].id, isTutorial: true)
                                .offset(x: geo.size.width/4, y: geo.size.height/1.35)
                        } else {
                            LevelButtonNavigation(showHeartStatus: $showHeartStatus, gameLevel: gameLevelBundle.levels[0], boardSize: gameLevelBundle.levels[0].boardSize, obstacles: gameLevelBundle.levels[0].obstacles, level: gameLevelBundle.levels[0].id, isTutorial: false)
                                .offset(x: geo.size.width/4, y: geo.size.height/1.35)
                        }
                        
                        LevelButtonNavigation(showHeartStatus: $showHeartStatus, gameLevel: gameLevelBundle.levels[1], boardSize: gameLevelBundle.levels[1].boardSize, obstacles: gameLevelBundle.levels[1].obstacles, level: gameLevelBundle.levels[1].id, isTutorial: false)
                            .offset(x: geo.size.width/2.7, y: geo.size.height/2.13)
                        LevelButtonNavigation(showHeartStatus: $showHeartStatus, gameLevel: gameLevelBundle.levels[2], boardSize: gameLevelBundle.levels[2].boardSize, obstacles: gameLevelBundle.levels[2].obstacles, level: gameLevelBundle.levels[2].id, isTutorial: false)
                            .offset(x: geo.size.width/2.0, y: geo.size.height/3.9)
                        
                        LevelButtonNavigation(showHeartStatus: $showHeartStatus, gameLevel: gameLevelBundle.levels[3], boardSize: gameLevelBundle.levels[3].boardSize, obstacles: gameLevelBundle.levels[3].obstacles, level: gameLevelBundle.levels[3].id, isTutorial: false)
                            .offset(x: geo.size.width/1.6, y: -geo.size.height/90)
                        LevelButtonNavigation(showHeartStatus: $showHeartStatus, gameLevel: gameLevelBundle.levels[4], boardSize: gameLevelBundle.levels[4].boardSize, obstacles: gameLevelBundle.levels[4].obstacles, level: gameLevelBundle.levels[4].id, isTutorial: false)
                            .offset(x: geo.size.width/2.2, y: -geo.size.height/3.8)
                        
                        LevelButtonNavigation(showHeartStatus: $showHeartStatus, gameLevel: gameLevelBundle.levels[5], boardSize: gameLevelBundle.levels[5].boardSize, obstacles: gameLevelBundle.levels[5].obstacles, level: gameLevelBundle.levels[5].id, isTutorial: false)
                            .offset(x: geo.size.width/3.6, y: -geo.size.height/2.05)
                        
                        LevelButtonNavigation(showHeartStatus: $showHeartStatus, gameLevel: gameLevelBundle.levels[6], boardSize: gameLevelBundle.levels[6].boardSize, obstacles: gameLevelBundle.levels[6].obstacles, level: gameLevelBundle.levels[6].id, isTutorial: false)
                            .offset(x: geo.size.width/7.3, y: -geo.size.height/1.3)
                    }
                }
            }
        //        }
        
        
    }
    private func levelMapName(for bundle: GameLevelBundle) -> String {
        switch bundle {
        case .bundle1:
            return "LevelMapOne"
        case .bundle2:
            return "LevelMapTwo"
        case .bundle3:
            return "LevelMapThree"
        }
    }
}
struct LevelButtonNavigation: View {
    @EnvironmentObject var gameCenterController: GameCenterManager
    @EnvironmentObject var heartManager: HeartManager
    @EnvironmentObject var userViewModel: UserViewModel
//    @EnvironmentObject var navCoordinator: NavigationCoordinator
    @State private var isNavigationActive = false
    @Binding var showHeartStatus: Bool
    
    let gameLevel: GameLevel
    let boardSize: (rows: Int, cols: Int)
    let obstacles: [(Int, Int)]
    let level: Int
    let isTutorial: Bool
    var body: some View {
        
        ZStack {
            Button(action: {
                
                if heartManager.currentHeartCount > 0 || userViewModel.isSubscriptionActive {
                    gameCenterController.currentLevel = gameLevel
                    gameCenterController.path.append(gameLevel)
                    isNavigationActive = true
                } else {
                    showHeartStatus.toggle()
                }
            }) {
                LevelButton(level: gameLevel.id, currentLevel: gameCenterController.achievedLevel)
            }
            .disabled(!(gameLevel.id <= gameCenterController.achievedLevel.id))
            if isTutorial {
                NavigationLink(destination: TutorialView(gameCenterManager: gameCenterController, storyMode: true), isActive: $isNavigationActive) {
                    EmptyView()
                }
                .hidden() // Hide
            } else {
                NavigationLink(destination: GameView(gameType: .ai, gameSize: (row: boardSize.rows, col: boardSize.cols), obstacles: obstacles), isActive: $isNavigationActive) {
                    EmptyView()
                }
                .hidden() // Hide
            }
            
        }
    }
}


struct LevelButton: View {
    let level: Int
    let currentLevel: GameLevel
    @EnvironmentObject var gameCenterManager: GameCenterManager
    var body: some View {
        ZStack {
            if level == currentLevel.id {
                Image("CurrentLevelCell")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.15)
                Text(level % 7 != 0 ? "\(level % 7)" : "\(7)")
                    .font(.custom("TempleGemsRegular", size: UIScreen.main.bounds.width * 0.07))
                    .foregroundColor(.white)
                    .stroke(color: .black, width: 1.0)
                    .shadow(color: .black, radius: 0, x: 0, y: 3)
                    .offset(x: 3, y: -11)
                Image("LevelPlayer")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.15)
                    .offset(x: 3, y: -46)
                    .zIndex(1)
            } else if level < currentLevel.id {
                Image("LevelUnlockedButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.15)
                Text(level % 7 != 0 ? "\(level % 7)" : "\(7)")
                    .font(.custom("TempleGemsRegular", size: UIScreen.main.bounds.width * 0.07))
                    .foregroundColor(.white)
                    .stroke(color: .black, width: 1.0)
                    .shadow(color: .black, radius: 0, x: 0, y: 3)
                    .offset(x: 3, y: -11)
            } else {
                Image("LockedLevel")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.15)
            }
        }
    }
}

struct LevelMapView_Previews: PreviewProvider {
    static var previews: some View {
        @State var heartStatus = true
        LevelMapView(gameLevelBundle: GameLevelBundle.bundle2, showHeartStatus: $heartStatus, isTutorial: false).environmentObject(GameCenterManager(currentPlayer: .player1))
    }
}





