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


    var body: some View {
            Image("LevelMapOne")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .overlay {
//                    ZStack {
                        GeometryReader { geo in
                            VStack {
                                NavigationLink {
                                    GameView(gameType: .ai, gameSize: (row: GameLevel.level1.boardSize.rows, col: GameLevel.level1.boardSize.cols), obstacles: [])
                                } label: {
                                    LevelButton(level: GameLevel.level1, currentLevel: gameCenterController.currentLevel)
                                }
                                .simultaneousGesture(TapGesture().onEnded({
                                        gameCenterController.path.append(10)
                                }))
                                .offset(x: geo.size.width/4, y: geo.size.height/1.35)
                                .disabled(!(GameLevel.level1.id <= gameCenterController.currentLevel.id))
                                
                                
                                NavigationLink {
                                    GameView(gameType: .ai, gameSize: (row: GameLevel.level2.boardSize.rows, col: GameLevel.level2.boardSize.cols), obstacles: [])
                                } label: {
                                    LevelButton(level: GameLevel.level2, currentLevel: gameCenterController.currentLevel)

                                }
                                .simultaneousGesture(TapGesture().onEnded({
                                        gameCenterController.path.append(10)
                                }))
                                .offset(x: geo.size.width/2.7, y: geo.size.height/2.13)
                                .disabled(!(GameLevel.level2.id <= gameCenterController.currentLevel.id))
                                
                                NavigationLink {
                                    GameView(gameType: .ai, gameSize: (row: GameLevel.level3.boardSize.rows, col: GameLevel.level3.boardSize.cols), obstacles: GameLevel.level3.obstacles)
                                } label: {
                                    
                                    LevelButton(level: GameLevel.level3, currentLevel: gameCenterController.currentLevel)
                                    
                                }
                                .simultaneousGesture(TapGesture().onEnded({
                                        gameCenterController.path.append(12)
                                }))
                                .offset(x: geo.size.width/2.0, y: geo.size.height/3.9)
                                .disabled(!(GameLevel.level3.id <= gameCenterController.currentLevel.id))
                                
                                NavigationLink {
                                    GameView(gameType: .ai, gameSize: (row: GameLevel.level4.boardSize.rows, col: GameLevel.level4.boardSize.cols), obstacles: GameLevel.level4.obstacles)
                                } label: {
                                    LevelButton(level: GameLevel.level4, currentLevel: gameCenterController.currentLevel)
                                    
                                }
                                .simultaneousGesture(TapGesture().onEnded({
                                        gameCenterController.path.append(13)
                                }))
                                .offset(x: geo.size.width/1.6, y: -geo.size.height/90)
                                .disabled(!(GameLevel.level4.id <= gameCenterController.currentLevel.id))
                                
                                NavigationLink {
                                    GameView(gameType: .ai, gameSize: (row: GameLevel.level5.boardSize.rows, col: GameLevel.level5.boardSize.cols), obstacles: GameLevel.level5.obstacles)
                                } label: {
                                    LevelButton(level: GameLevel.level5, currentLevel: gameCenterController.currentLevel)
                                    
                                }
                                .simultaneousGesture(TapGesture().onEnded({
                                        gameCenterController.path.append(14)
                                }))
                                .offset(x: geo.size.width/2.2, y: -geo.size.height/3.8)
                                .disabled(!(GameLevel.level5.id <= gameCenterController.currentLevel.id))

                                NavigationLink {
                                    GameView(gameType: .ai, gameSize: (row: GameLevel.level6.boardSize.rows, col: GameLevel.level6.boardSize.cols), obstacles: GameLevel.level6.obstacles)
                                } label: {
                                    LevelButton(level: GameLevel.level6, currentLevel: gameCenterController.currentLevel)
                                    
                                }
                                .simultaneousGesture(TapGesture().onEnded({
                                        gameCenterController.path.append(15)
                                }))
                                .offset(x: geo.size.width/3.6, y: -geo.size.height/2.05)
                                .disabled(!(GameLevel.level6.id <= gameCenterController.currentLevel.id))
//
                                NavigationLink {
                                    GameView(gameType: .ai, gameSize: (row: GameLevel.level7.boardSize.rows, col: GameLevel.level7.boardSize.cols), obstacles: GameLevel.level7.obstacles)
                                } label: {
                                    LevelButton(level: GameLevel.level7, currentLevel: gameCenterController.currentLevel)
                                    
                                }
                                .simultaneousGesture(TapGesture().onEnded({
                                        gameCenterController.path.append(16)
                                }))
                                .offset(x: geo.size.width/7.3, y: -geo.size.height/1.3)
                                .disabled(!(GameLevel.level7.id <= gameCenterController.currentLevel.id))

                            }
                        }
//                    }
                    
        }
    }
}





struct LevelButton: View {
    let level: GameLevel
    let currentLevel: GameLevel
    @EnvironmentObject var gameCenterManager: GameCenterManager

    var body: some View {
        ZStack {
            if level.id == currentLevel.id {
                Image("CurrentLevelCell")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.15)
                Text(level.id.description)
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
            } else if level.id < currentLevel.id {
                Image("LevelUnlockedButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.15)
                Text(level.id.description)
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
         // Disable button if level is locked
    }
}

struct LevelMapView_Previews: PreviewProvider {
    static var previews: some View {
        LevelMapView().environmentObject(GameCenterManager(currentPlayer: .player1))
    }
}


