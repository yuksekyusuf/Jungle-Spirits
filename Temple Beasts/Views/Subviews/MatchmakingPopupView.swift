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
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white.opacity(0.7))
                        .frame(width: 300, height: 100)
                        .overlay(alignment: .leading) {
                            HStack {
                                if let image = gameCenterController.localPlayerImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .frame(width: 60)
                                }
                                VStack(alignment: .leading) {
                                    Text(gameCenterController.localPlayer.displayName)
                                        .font(.title2.bold())
                                        .foregroundColor(.white)
                                    Text("You")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.leading, 10)
                            
                        }
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white.opacity(0.7))
                        .frame(width: 300, height: 100)
                        .overlay(alignment: .leading){
                            HStack {
                                if isSearching {
                                    HStack {
                                        Circle()
                                            .fill(.secondary)
                                            .frame(width: 60)
                                            .padding(.trailing, 15)
                                        VStack(alignment: .leading) {
                                            Text("Player 2")
                                                .font(.title2.bold())
                                                .foregroundColor(.white)
                                                .offset(y: 3)
                                            HStack {
                                                ProgressView().tint(.blue)
                                                    .padding(.trailing, 2)
                                                Text("Matching")
                                                    .foregroundColor(.gray)
                                            }
                                            .offset(y: -8)
                                        }
                                        
                                    }
                                    .padding(.leading, 10)
                                }
                            }
                        }
                    if isSearching {
                        
                    }
                    //                    else if let remoteImage = gameCenterController.remotePlayerImage, let remoteName = gameCenterController.remotePlayerName {
                    //                        HStack {
                    //                            Image(uiImage: remoteImage)
                    //                                .resizable()
                    //                                .scaledToFit()
                    //                                .clipShape(Circle())
                    //                                .frame(width: 80)
                    //                            VStack(alignment: .leading) {
                    //                                Text(remoteName)
                    //                                    .font(.title2.bold())
                    //                                    .foregroundColor(.white)
                    //                                Text("Opponent")
                    //                                    .foregroundColor(.gray)
                    //                            }
                    //                        }
                    //                        .offset(x: -35)
                    //                    }
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
