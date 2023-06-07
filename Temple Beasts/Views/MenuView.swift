//
//  MenuView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/21/23.
//

import SwiftUI



struct MenuView: View {
    
    @State var gameType: GameType? = nil
    @State var views: [String] = ["Menu", "Game", "PauseMenu"]
    @State var stackPath = NavigationPath()
    
    var body: some View {
        
        
        NavigationStack(path: $stackPath) {
            ZStack {
                Image("Menu Screen")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack(spacing: 0) {
                    //Single Player
//                    NavigationLink(value: views) {
//                        
//                    }
//                    .navigationDestination(for: String.self) { _ in
//                        GameView(gameType: .ai)
//                    }
                    NavigationLink(destination: GameView(gameType: .ai)) {
                        MenuButtonView(text: "Single Player")
                        .padding(.bottom, -10)
                    }

                    
                    //1 vs 1
                    NavigationLink(destination: GameView(gameType: .oneVone)) {
                        MenuButtonView(text: "1 vs 1")
                                                .padding(.bottom, -10)

                    }
                    

                    //Settings
                    Button {
                        
                    } label: {
                        MenuButtonView(text: "Settings")
                    }
                    .padding(.bottom, -10)
                }
                .padding(.top, 200)
            }
            .ignoresSafeArea()

        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
//        @State var active: ActiveView = .menuView
        MenuView()
    }
}
