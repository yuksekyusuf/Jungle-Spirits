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
    @AppStorage("shownHowToPlay") var howToPlayShown: Bool = false
    var body: some View {
            VStack {
                if UserDefaults.standard.howToPlayShown {
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
                    
                } else {
                    Text("How to Play")
                        .foregroundColor(.white)
                        .font(Font.custom("Watermelon-Regular", size: 28))
                        .padding(.top, 20)
                }
                Spacer()
                TabView(selection: $selectedTab) {
                    InfoTabView(title: "Selecting a Gem", description: "Select a gem. Notice the green and yellow areas? That's where the magic happens!", image1: "SelectAGem 1", image2: "SelectAGem 2")
                        .tag(0)

                    InfoTabView(title: "Cloning", description: "Move to a green area, and your gem clones itself. Double the fun!", image1: "Cloning 1", image2: "Cloning 2")
                        .tag(1)
                    
                    InfoTabView(title: "Teleportation", description: "Leap to a yellow area, and your gem teleports. It's a two-tile jump!", image1: "Teleport 1", image2: "Teleport 2")
                        .tag(2)
                    
                    InfoTabView(title: "Converting Enemies", description: "Whenever your gem touches an enemy - whether horizontally, vertically, or diagonally - they join your ranks! Strategize to maximize conversions.", image1: "Converting 1", image2: "Converting 2")
                        .tag(3)
                    InfoTabView(title: "Objective", description: "Rule the board, convert more enemies, and outsmart your opponent. Ready to conquer?", image1: "Objective 1", image2: "Objective 2")
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
                            UserDefaults.standard.howToPlayShown = true

                            gameCenterManager.path.removeAll()
//
//                            print("Before button tapped", UserDefaults.standard.howToPlayShown)
//                            if UserDefaults.standard.howToPlayShown {
//                                gameCenterManager.path.removeAll()
//                            } else {
//                                UserDefaults.standard.howToPlayShown = true
//                            }
//                            print("After button tapped", UserDefaults.standard.howToPlayShown)
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

extension UserDefaults {
    var howToPlayShown: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "shownHowToPlay") as? Bool) ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "shownHowToPlay")
        }
    }
}
