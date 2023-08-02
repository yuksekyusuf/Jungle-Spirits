//
//  HowToPlayView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 2.08.2023.
//

import SwiftUI

struct HowToPlayView: View {
    @EnvironmentObject var gameCenterManager: GameCenterManager
    @State var selectedTab = 0
    var body: some View {
            VStack {
                HStack(alignment: .center) {
                    Button {
                        gameCenterManager.path.removeAll()
                    } label: {
                        Image("Left Arrow")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55)
                    }
                    Text("How to Play")
                        .foregroundColor(.white)
                        .font(Font.custom("Watermelon-Regular", size: 28))
                        .padding(.leading, 30)
                }
                .padding(.trailing, 80)
                .padding(.top, 20)
                Spacer()
                TabView(selection: $selectedTab) {
                    InfoTabView(title: "Selecting a Gem", description: "Select a gem. Notice the green and yellow areas? That's where the magic happens!", image: "SelectAGem")
                        .tag(0)

                    InfoTabView(title: "Cloning", description: "Move to a green area, and your gem clones itself. Double the fun!", image: "Cloning")
                        .tag(1)
                    
                    InfoTabView(title: "Teleportation", description: "Leap to a yellow area, and your gem teleports. It's a two-tile jump!", image: "Teleport")
                        .tag(2)
                    
                    InfoTabView(title: "Converting Enemies", description: "Whenever your gem touches an enemy - whether horizontally, vertically, or diagonally - they join your ranks! Strategize to maximize conversions.", image: "Converting")
                        .tag(3)
                    InfoTabView(title: "Objective", description: "Rule the board, convert more enemies, and outsmart your opponent. Ready to conquer?", image: "Objective")
                        .tag(4)
                }
                .frame(height: UIScreen.main.bounds.height * 0.6)
                .padding(.bottom, 30)
                .tabViewStyle(PageTabViewStyle())
                if selectedTab < 4 {
                    Button {
                        withAnimation(.easeInOut) {
                            selectedTab+=1
                        }
                    } label: {
                        Image("NextButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 167)
                            .padding(.bottom, 20)
                    }
                } else {
                    Button {
                        withAnimation(.easeInOut) {
                            gameCenterManager.path.removeAll()
                        }
                    } label: {
                        Image("GotIt")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 167)
                            .padding(.bottom, 20)
                    }
                }
            }
            .background {
                Image("purebackground")
                    .resizable()
                    .scaledToFill()
                    .frame(height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            }
            .navigationBarHidden(true)
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
    }
}
