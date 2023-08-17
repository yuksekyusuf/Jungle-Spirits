//
//  MenuView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/21/23.
//

import SwiftUI
import StoreKit


struct MenuView: View {
    @Environment(\.requestReview) var requestReview
    @StateObject var gameCenterController: GameCenterManager = GameCenterManager(currentPlayer: .player1)
    @State private var isMatchmakingPresented = false
    @State var gameType: GameType?
    @AppStorage("music") var musicState: Bool = true
    @AppStorage("haptic") var hapticState: Bool = true
    @AppStorage("sound") var soundState: Bool = true
    
    
    
    let buttonWidth = UIScreen.main.bounds.width * 0.8
    let singleButtonWidth = UIScreen.main.bounds.width * 0.40
    let smallButtonWidth = UIScreen.main.bounds.width * 0.24
    
    var body: some View {
        
        
        NavigationStack(path: $gameCenterController.path) {
            if UserDefaults.standard.howToPlayShown {
                ZStack {
                    Image("Menu Screen")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    VStack(spacing: 0) {
                        HStack {
                            Button {
                                requestReview()
                            } label: {
                                Image("like")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                    .padding(.leading, 20)
                            }
                            Spacer()
                            NavigationLink {
                                HowToPlayView()
                            } label: {
                                Image("info")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                    .padding(.trailing, 20)
                            }
                            .simultaneousGesture(TapGesture().onEnded({
                                gameCenterController.path.append(1)
                            }))
                            
                        }
                        .padding(.top, 70)
                        Spacer()
                        Image("menuLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                            .offset(y: -110)
                        
                        //                    LottieView(animationName: "logo", ifActive: false, contentMode: true, isLoop: true)
                        //                        .frame(width: UIScreen.main.bounds.width * 0.8)
                        //                                            .offset(y: -90)
                        //                                            .allowsHitTesting(false)
                        
                        
                        Spacer()
                        VStack {
                            HStack {
                                NavigationLink {
                                    GameView(gameType: .ai)
                                } label: {
                                    Image("SinglePlayer")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: singleButtonWidth)
                                }
                                .simultaneousGesture(TapGesture().onEnded({
                                    gameCenterController.path.append(2)
                                }))
                                
                                // 1 vs 1
                                NavigationLink {
                                    GameView(gameType: .oneVone)
                                } label: {
                                    Image("1 vs 1")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: singleButtonWidth)
                                }
                                .simultaneousGesture(TapGesture().onEnded({
                                    gameCenterController.path.append(3)
                                }))
                            }
                            
                            ZStack {
                                NavigationLink(destination: GameView(gameType: .multiplayer), isActive: $gameCenterController.isMatched) {
                                    EmptyView()
                                }
                                Button {
                                    self.isMatchmakingPresented = true
                                } label: {
                                    Image("OnlineButton")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: buttonWidth)
                                }
                                .sheet(isPresented: $isMatchmakingPresented) {
                                    GameCenterView().environmentObject(gameCenterController)
                                }
                            }
                            .padding(.top, 3)
                            
                            HStack(spacing: 0) {
                                Spacer()
                                Image(soundState ? "soundOn" : "soundOff")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: smallButtonWidth)
                                    .onTapGesture {
                                        soundState.toggle()
                                        UserDefaults.standard.set(soundState, forKey: "sound")
                                    }
                                Image(musicState ? "musicOn" : "musicOff" )
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: smallButtonWidth)
                                    .padding(.trailing, 16)
                                    .padding(.leading, 16)
                                    .onTapGesture {
                                        musicState.toggle()
                                        UserDefaults.standard.set(musicState, forKey: "music")
                                        if musicState {
                                            SoundManager.shared.playBackgroundMusic()
                                        } else {
                                            SoundManager.shared.stopBackgroundMusic()
                                        }
                                    }
                                Image(hapticState ? "vibrationOn" : "vibrationOff")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: smallButtonWidth)
                                    .onTapGesture {
                                        hapticState.toggle()
                                        UserDefaults.standard.set(hapticState, forKey: "haptic")
                                        if hapticState {
                                            HapticManager.shared.notification(type: .error)
                                        }
                                    }
                                Spacer()
                            }
                            .padding(.top, 8)
                        }
                        .padding(.bottom, 90)
                    }
                    LottieView(animationName: "particles", ifActive: false, contentMode: true, isLoop: true)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    //                    .edgesIgnoringSafeArea(.all)
                        .allowsHitTesting(false)
                }
                .ignoresSafeArea()
            } else {
                HowToPlayView()
            }
        }
        .onAppear {
            UserDefaults.standard.set(soundState, forKey: "sound")
            UserDefaults.standard.set(musicState, forKey: "music")
            UserDefaults.standard.set(hapticState, forKey: "haptic")
            
            SoundManager.shared.startPlayingIfNeeded()
            if !gameCenterController.isUserAuthenticated {
                gameCenterController.authenticateUser()
            }
        }
        .environmentObject(gameCenterController)
    }
}


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
