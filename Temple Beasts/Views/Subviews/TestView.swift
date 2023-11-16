//
//  TestView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 15.11.2023.
//

import SwiftUI

struct CustomTestTabView: View {
    @State private var selectedTab = 1
    let numberOfTabs = 4

    var body: some View {
        ZStack{
            Color.black
            VStack {
                ZStack {
                    
                    TabView(selection: $selectedTab) {
                        ForEach(1...numberOfTabs, id: \.self) { index in
                            MapsTabView(mapNumber: index, mapName: "Map \(index)", levelBundle: GameLevelBundle(rawValue: index) ?? .bundle1)
                                .tag(index)
                                .padding(.bottom, 30)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
//                    .offset(y: 50) // Adjust this value to move the indicators off-screen

                    .overlay{
                        GeometryReader { geo in
                            Color("coverColor")
                                .frame(width: 80, height: 18)
                                .offset(x: geo.size.width * 0.4, y: geo.size.height * 0.95)
                        }
                    }
                    
                    
                }
                
                
               

                HStack {
                    ForEach(1...numberOfTabs, id: \.self) { index in
                        if selectedTab == index {
                            Image("SelectedTabAsset")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .onTapGesture {
                                    selectedTab = index
                                }
                        } else {
                            Image("UnselectedTabAsset")
                                .resizable()
                                .frame(width: 8, height: 8)
                                .onTapGesture {
                                    selectedTab = index
                                }
                        }
                        
                    }
                }
            }
            .padding(.bottom, UIScreen.main.bounds.height * 0.1)

        }
            }
}

struct CustomTestTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTestTabView().environmentObject(GameCenterManager(currentPlayer: .player1))
    }
}
