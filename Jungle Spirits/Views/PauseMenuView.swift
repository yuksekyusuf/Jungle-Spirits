//
//  PauseMenuView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/21/23.
//

import SwiftUI

struct PauseMenuView: View {
    @Binding var showPauseMenu: Bool
    @Binding var isPaused: Bool
    @Binding var remainingTime: Int
    @Binding var selectedCell: (row: Int, col: Int)?

    @State var gameType: GameType
    @State private var soundState: Bool = UserDefaults.standard.bool(forKey: "sound")
    @State private var musicState: Bool = UserDefaults.standard.bool(forKey: "music")
    @EnvironmentObject var board: Board
    @EnvironmentObject var gameCenterController: GameCenterManager
    @EnvironmentObject var appLanguageManager: AppLanguageManager
    @Binding var currentPlayer: CellState
    
    
    func localizedStringForKey(_ key: String, language: String) -> String {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    
    var music: String {
        appLanguageManager.localizedStringForKey("MUSIC", language: appLanguageManager.currentLanguage)
    }
    
    var sound: String {
        appLanguageManager.localizedStringForKey("SOUND", language: appLanguageManager.currentLanguage)
    }
    
    var body: some View {
        ZStack {
//            Color.black.ignoresSafeArea()
//                .opacity(0.65)
            VStack {
                Image("pauseMenuBackground")
                    .padding(.top, -200)
                    .overlay {
                        ZStack {
                            RoundedRectangle(cornerRadius: 46)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: Color(#colorLiteral(red: 0.7333333492279053, green: 0.7614035606384277, blue: 1, alpha: 1)), location: 0),
                                            .init(color: Color(#colorLiteral(red: 0.5364739298820496, green: 0.4752604365348816, blue: 0.9125000238418579, alpha: 1)), location: 1)]),
                                        startPoint: UnitPoint(x: 0.9999999999999999, y: 0),
                                        endPoint: UnitPoint(x: 2.980232305382913e-8, y: 1.0000000310465447))
                                )
                                .frame(width: 271, height: 258)
                                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.44999998807907104)), radius: 16, x: 0, y: 10)
                            
                            Image("pausemenubackground1")
                                .frame(width: 240, height: 240)
                            Image(uiImage: #imageLiteral(resourceName: "pauseMenuPattern"))
                                .resizable()
                                .frame(width: 240, height: 240)
                                .clipped()
                                .blendMode(.overlay)
                                .frame(width: 240, height: 240)
                                .cornerRadius(44)
                            
                            Image("pauseMenuPieces")
                                .offset(y: -122)
                            VStack {
                                Spacer()
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color("AnotherPause"))
                                    .frame(width: 201, height: 89)
                                    .padding(.top, 40)
                                    .overlay {
                                        HStack {
                                            VStack(spacing: 5) {
                                                Image("Note")
                                                
                                                Image("iconSound")
                                            }
                                            VStack(spacing: 12) {
                                                Text(music)
                                                    .font(Font.custom("TempleGemsRegular", size: 24))
                                                    .foregroundColor(Color(#colorLiteral(red: 0.83, green: 0.85, blue: 1, alpha: 1)))
                                                Text(sound)
                                                    .font(Font.custom("TempleGemsRegular", size: 24))
                                                    .foregroundColor(Color(#colorLiteral(red: 0.83, green: 0.85, blue: 1, alpha: 1)))
                                            }
                                            
                                            VStack(spacing: 5) {
                                                Toggle(isOn: $musicState) {
                                                    Text("")
                                                }
                                                .toggleStyle(CustomToggleView())
                                                .onChange(of: musicState) { newValue in
                                                    UserDefaults.standard.set(newValue, forKey: "music")
                                                    if newValue {
                                                        SoundManager.shared.playBackgroundMusic()
                                                        SoundManager.shared.turnDownMusic()
                                                    } else {
                                                        SoundManager.shared.stopBackgroundMusic()
                                                    }
                                                }
                                                
                                                Toggle(isOn: $soundState) {
                                                    Text("")
                                                }
                                                .toggleStyle(CustomToggleView())
                                                .onChange(of: soundState, perform: { newValue in
                                                    UserDefaults.standard.set(newValue, forKey: "sound")
                                                })
                                            }
                                        }
                                        .padding(.top, 40)
                                    }
                                Spacer()
                                HStack {
                                    if gameType == .multiplayer {
                                        Button {
                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                showPauseMenu.toggle()
                                            }
                                            
                                        } label: {
                                            PauseMenuIconView(imageName: "iconResume")
                                        }
                                        .padding(.trailing, 10)
                                        
                                        Button {
                                            gameCenterController.resetGame()
                                        } label: {
                                            PauseMenuIconView(imageName: "iconHome")
                                        }
                                        .padding(.leading, 10)
                                    } else {
                                        Button {
                                            board.reset()
                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                showPauseMenu.toggle()
                                            }
//                                            showPauseMenu.toggle()
                                            isPaused.toggle()
                                            currentPlayer = .player1
                                            remainingTime = 15
                                            selectedCell = nil
//                                            gameCenterController.isSelected = false
//                                            gameCenterController.selectedCell = nil
                                        } label: {
                                            PauseMenuIconView(imageName: "iconReplay")
                                        }
                                        
                                        Button {
                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                showPauseMenu.toggle()
                                            }
                                            gameCenterController.isPaused.toggle()
                                        } label: {
                                            PauseMenuIconView(imageName: "iconResume")
                                        }
                                        Button {
//                                            gameCenterController.path.removeAll()
                                            gameCenterController.path = NavigationPath()

                                        } label: {
                                            

                                            PauseMenuIconView(imageName: "iconMap2")

                                        }
                                    }
                                }
                                .padding(.bottom, 20)
                                Spacer()
                            }
                        }
                    }
            }
        }
        
    }
    
    
}
struct PauseMenuView_Previews: PreviewProvider {
    static var previews: some View {
        @State var check = true
        @State var show = true
        @State var player: CellState = .player1
        @State var remainingTime: Int = 15
        @State var cell: (row: Int, col: Int)? = (1, 1)
        PauseMenuView(showPauseMenu: $check, isPaused: $show, remainingTime: $remainingTime, selectedCell: $cell, gameType: .ai, currentPlayer: $player)
            .environmentObject(GameCenterManager(currentPlayer: .player1))
            .environmentObject(AppLanguageManager())
    }
}
