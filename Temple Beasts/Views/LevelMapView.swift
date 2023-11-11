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
                .overlay {
                    ZStack {
                        
                        GeometryReader { geo in
                            VStack {
                                
                                NavigationLink {
                                    GameView(gameType: .ai, gameSize: (row: GameLevel.level1.boardSize.rows, col: GameLevel.level1.boardSize.cols), obstacles: [])
                                } label: {
                                    LevelButton(level: GameLevel.level1.id.description)
                                }
                                .simultaneousGesture(TapGesture().onEnded({
                                        gameCenterController.path.append(10)
                                }))
                                .position(x: geo.size.width/2.65, y: geo.size.height/1.2)

                                NavigationLink {
                                    GameView(gameType: .ai, gameSize: (row: GameLevel.level2.boardSize.rows, col: GameLevel.level2.boardSize.cols), obstacles: [])
                                } label: {
                                    LevelButton(level: GameLevel.level2.id.description)
                                        .position(x: geo.size.width/2.65, y: geo.size.height/5.2)


                                }
                                .simultaneousGesture(TapGesture().onEnded({
                                    gameCenterController.path.append(11)
                                }))
                                


                            }
                            
                            
                        }
                        Image("MapParticules")
                            .resizable()
                            .scaledToFit()
                            .allowsHitTesting(false)

                    }
                    
        }
            
        

    }
}





struct LevelButton: View {
    let level: String

    var body: some View {
        
        ZStack {
            Image("LevelUnlockedButton")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
            Text(level)
                .font(.custom("TempleGemsRegular", size: 30))
                .foregroundColor(.white)
                .stroke(color: .black, width: 1.0)
                .shadow(color: .black, radius: 0, x: 0, y: 3)
                .offset(x: 3, y: -11)
            
        }
//        .disabled(!level.unlocked) // Disable button if level is locked
    }
}

struct LevelMapView_Previews: PreviewProvider {
    static var previews: some View {
        LevelMapView()
    }
}
