//
//  PlayerView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/5/23.
//

import SwiftUI

struct PlayerView: View {
    var player: CellState
    var body: some View {
        HStack {
            if player == .player1 {
                Image(uiImage: UIImage(named: "Red")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
            } else if player == .player2 {
                Image(uiImage:  UIImage(named: "Blue")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
            }
            
        }
    }
    
    var playerImage: some View {
        Image(systemName: "star.fill")
            .font(.headline)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(player: .player2)
    }
}
