//
//  TestView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 16.09.2023.
//

import SwiftUI

struct MatchmakingPopupView: View {
    @EnvironmentObject var gameCenterController: GameCenterManager
    @Binding var isSearching: Bool
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                .opacity(0.7)
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.black.opacity(0.4))
                .frame(width: 350, height: 250)
            ZStack {
                VStack {
                    VStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 300, height: 100)
                            .overlay(alignment: .leading) {
                                
                            }
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 300, height: 100)
                        
                        
                        
                    }
                }
                VStack(alignment: .leading, spacing: 45) {
                    HStack {
                        
                        if let image = gameCenterController.localPlayerImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 60)
                        }
                        //                        Circle()
                        //                            .fill(.secondary)
                        //                            .frame(width: 60)
                        VStack(alignment: .leading) {
                            Text(gameCenterController.localPlayer.displayName)
                            //                            Text("Player 1")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            Text("You")
                                .foregroundColor(.gray)
                        }
                        
                    }
                    .offset(x: -50)
                    
                    
                    HStack {
                        if isSearching {
                            HStack {
                                Circle()
                                    .fill(.secondary)
                                    .frame(width: 60)
                                VStack(alignment: .leading) {
                                    Text("Player 2")
                                        .font(.title2.bold())
                                        .foregroundColor(.white)
                                    HStack {
                                        //                                        ProgressView().tint(.blue)
                                        Text("Matching")
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                            }
                        }
                        else if let remoteImage = gameCenterController.remotePlayerImage, let remoteName = gameCenterController.remotePlayerName {
                            HStack {
                                Image(uiImage: remoteImage)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 60)
                                VStack(alignment: .leading) {
                                    Text(remoteName)
                                        .font(.title2.bold())
                                        .foregroundColor(.white)
                                    Text("Opponent")
                                        .foregroundColor(.gray)
                                }
                            }
}
                        }
                            .offset(x: -50)
                    }
                    
                }
                
            }
        }
    }
    
    struct MatchmakingPopupView_Previews: PreviewProvider {
        static var previews: some View {
            @State var searching = true
            MatchmakingPopupView(isSearching: $searching)
        }
    }
