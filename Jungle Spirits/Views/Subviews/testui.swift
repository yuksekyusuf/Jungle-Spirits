//
//  testui.swift
//  Jungle Spirits
//
//  Created by Ahmet Yusuf Yuksek on 25.02.2024.
//

import SwiftUI

struct testui: View {
    @State var present = false
    var body: some View {
        ZStack {
            GameCenterView(isPresentingMatchmaker: $present)
        }
    }
}

#Preview {
    testui()
        .environmentObject(GameCenterManager(currentPlayer: .player1))
}
