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
    
    var body: some View {
            Image(levelMapName(for: gameLevelBundle))
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .overlay {
                    GeometryReader { geo in
                        VStack {
                            LevelButtonNavigation(gameLevel: gameLevelBundle.levels[0], boardSize: gameLevelBundle.levels[0].boardSize, obstacles: gameLevelBundle.levels[0].obstacles, level: gameLevelBundle.levels[0].id)
                                .offset(x: geo.size.width/4, y: geo.size.height/1.35)
                            
                            LevelButtonNavigation(gameLevel: gameLevelBundle.levels[1], boardSize: gameLevelBundle.levels[1].boardSize, obstacles: gameLevelBundle.levels[1].obstacles, level: gameLevelBundle.levels[1].id)
                                .offset(x: geo.size.width/2.7, y: geo.size.height/2.13)
                            LevelButtonNavigation(gameLevel: gameLevelBundle.levels[2], boardSize: gameLevelBundle.levels[2].boardSize, obstacles: gameLevelBundle.levels[2].obstacles, level: gameLevelBundle.levels[2].id)
                                .offset(x: geo.size.width/2.0, y: geo.size.height/3.9)
                            
                            LevelButtonNavigation(gameLevel: gameLevelBundle.levels[3], boardSize: gameLevelBundle.levels[3].boardSize, obstacles: gameLevelBundle.levels[3].obstacles, level: gameLevelBundle.levels[3].id)
                                .offset(x: geo.size.width/1.6, y: -geo.size.height/90)
                            LevelButtonNavigation(gameLevel: gameLevelBundle.levels[4], boardSize: gameLevelBundle.levels[4].boardSize, obstacles: gameLevelBundle.levels[4].obstacles, level: gameLevelBundle.levels[4].id)
                                .offset(x: geo.size.width/2.2, y: -geo.size.height/3.8)
                            
                            LevelButtonNavigation(gameLevel: gameLevelBundle.levels[5], boardSize: gameLevelBundle.levels[5].boardSize, obstacles: gameLevelBundle.levels[5].obstacles, level: gameLevelBundle.levels[5].id)
                                .offset(x: geo.size.width/3.6, y: -geo.size.height/2.05)
                            
                            LevelButtonNavigation(gameLevel: gameLevelBundle.levels[6], boardSize: gameLevelBundle.levels[6].boardSize, obstacles: gameLevelBundle.levels[6].obstacles, level: gameLevelBundle.levels[6].id)
                                .offset(x: geo.size.width/7.3, y: -geo.size.height/1.3)
                        }
                    }
                }
        
    }
    private func levelMapName(for bundle: GameLevelBundle) -> String {
        switch bundle {
        case .bundle1:
            return "LevelMapOne"
        case .bundle2:
            return "LevelMapTwo"
        case .bundle3:
            return "LevelMapThree"
        case .bundle4:
            return "LevelMapFour"
        }
    }
}

struct LevelButtonNavigation: View {
    @EnvironmentObject var gameCenterController: GameCenterManager
    let gameLevel: GameLevel
    let boardSize: (rows: Int, cols: Int)
    let obstacles: [(Int, Int)]
    let level: Int
    var body: some View {
        NavigationLink {
            GameView(gameType: .ai, gameSize: (row: boardSize.rows, col: boardSize.cols), obstacles: obstacles)
        } label: {
            LevelButton(level: gameLevel.id, currentLevel: gameCenterController.currentLevel)
            
        }
        .simultaneousGesture(TapGesture().onEnded({
            gameCenterController.path.append(10)
        }))
        .disabled(!(gameLevel.id <= gameCenterController.currentLevel.id))
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
                Text(level > 7 ? "\(level/7)" : "\(level)")
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
            } else if level < currentLevel.id {
                Image("LevelUnlockedButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.15)
                Text(level > 7 ? "\(level/7)" : "\(level)")
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
        LevelMapView(gameLevelBundle: GameLevelBundle.bundle2).environmentObject(GameCenterManager(currentPlayer: .player1))
    }
}





