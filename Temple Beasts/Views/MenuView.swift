//
//  MenuView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/21/23.
//

import SwiftUI

class MenuViewModel: ObservableObject {
    @Published var path: [Int] = []
}

struct MenuView: View {
    
    @State var gameType: GameType? = nil
    var views: [String] = ["Menu", "Game", "PauseMenu"]
    @StateObject var menuViewModel = MenuViewModel()


    var body: some View {
        
        
        NavigationStack(path: $menuViewModel.path) {
            ZStack {
                Image("Menu Screen")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack(spacing: 0) {
                    
                    //Single Player
                    
                    NavigationLink {
                        GameView(gameType: .ai)
                    } label: {
                        MenuButtonView(text: "Single Player")
                            .padding(.bottom, -10)
                    }
                    .simultaneousGesture(TapGesture().onEnded({
                        menuViewModel.path.append(1)
                    }))

                    //1 vs 1
                    NavigationLink {
                        GameView(gameType: .oneVone)
                    } label: {
                        MenuButtonView(text: "1 vs 1")
                            .padding(.bottom, -10)
                    }
                    .simultaneousGesture(TapGesture().onEnded({
                        menuViewModel.path.append(2)
                    }))

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
        .environmentObject(menuViewModel)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
//        @State var active: ActiveView = .menuView
        MenuView()
    }
}

