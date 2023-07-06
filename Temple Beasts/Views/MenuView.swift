//
//  MenuView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/21/23.
//

import SwiftUI
import StoreKit

class MenuViewModel: ObservableObject {
    @Published var path: [Int] = []
}

struct MenuView: View {
    @Environment(\.requestReview) var requestReview
    @StateObject var gameCenterController = GameCenterController()
    
    
    @State private var isMatchmakingPresented = false
    
    
    //    @State private var showingGameCenterView = false
    //       @State private var navigateToGameView = false
    
    @State var gameType: GameType? = nil
    @State var hapticState: Bool = true
    @State var soundState: Bool = UserDefaults.standard.bool(forKey: "sound")
    @AppStorage("music") private var musicState: Bool = false
    
    //    @AppStorage("haptic") var hapticState: Bool?
    //    @AppStorage("sound") var soundState: Bool?
    var views: [String] = ["Menu", "Game", "PauseMenu"]
    @StateObject var menuViewModel = MenuViewModel()
    
    let buttonWidth = UIScreen.main.bounds.width * 0.71
    let singleButtonWidth = UIScreen.main.bounds.width * 0.35
    let smallButtonWidth = UIScreen.main.bounds.width * 0.198
    
    var body: some View {
        NavigationStack(path: $menuViewModel.path) {
            ZStack {
                Image("Menu Screen")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
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
                        Image("info")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .padding(.trailing, 20)
                    }
                    .padding(.top, 10)
                    Spacer()
                    Image("menuLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                        .offset(y: -110)
                    
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
                                menuViewModel.path.append(1)
                            }))
                            
                            //1 vs 1
                            NavigationLink {
                                GameView(gameType: .oneVone)
                            } label: {
                                Image("1 vs 1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: singleButtonWidth)
                                
                            }
                            .simultaneousGesture(TapGesture().onEnded({
                                menuViewModel.path.append(2)
                            }))
                        }
                        
                        ZStack {
                            NavigationLink(destination: GameView(gameType: .oneVone), isActive: $gameCenterController.isMatched) {
                                ProgressView()
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
                                }
                            Spacer()
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear{
            UserDefaults.standard.set(soundState, forKey: "sound")
            SoundManager.shared.startPlayingIfNeeded()
            if !gameCenterController.isUserAuthenticated {
                gameCenterController.authenticateUser()
            }
        }
        .environmentObject(menuViewModel)
        .environmentObject(gameCenterController)
        
        
    }
    
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        //        @State var active: ActiveView = .menuView
        MenuView()
    }
}



