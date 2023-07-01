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
    @State var gameType: GameType? = nil
    @State var hapticState: Bool = true
    @State var soundState: Bool = true
//    @AppStorage("haptic") var hapticState: Bool?
//    @AppStorage("sound") var soundState: Bool?
    var views: [String] = ["Menu", "Game", "PauseMenu"]
    @StateObject var menuViewModel = MenuViewModel()


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
                    VStack {
                        
                        
                        NavigationLink {
                            GameView(gameType: .ai)
                        } label: {
                            Image("SinglePlayer")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 280)
                            
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
                                .frame(maxWidth: 280)
                                
                        }
                        .simultaneousGesture(TapGesture().onEnded({
                            menuViewModel.path.append(2)
                        }))

                        HStack(spacing: 0) {
                            Spacer()
                            Button {
                                soundState.toggle()
                                UserDefaults.standard.set(soundState, forKey: "sound")
                            } label: {
                                Image("sound")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 78)
                                
                            }

                            Button {
                                
                            } label: {
                                Image("music")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 78)
                                    .padding(.trailing, 16)
                                    .padding(.leading, 16)
                            }

                            
                            
                            
                            
                            Button {
                                hapticState.toggle()
                                UserDefaults.standard.set(hapticState, forKey: "haptic")
                            } label: {
                                Image("vibrate")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 78)
                            }
                            Spacer()
                        }
                    }
                    .padding(.bottom, 130)
                    
                }
            }
        }
        .onAppear{
            UserDefaults.standard.set(soundState, forKey: "sound")
        }
        .environmentObject(menuViewModel)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
//        @State var active: ActiveView = .menuView
        MenuView()
    }
}

