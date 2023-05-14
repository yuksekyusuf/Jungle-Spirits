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
            //Group 1788 1
            if player == .player1 {
                Image(uiImage: UIImage(named: "Group 1788 1")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 62, height: 66)
                    .clipped()
            } else if player == .player2 {
                Image(uiImage:  UIImage(named: "Group 1798")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 62, height: 66)
                    .clipped()
            }
            
//                .frame(width: 64, height: 69)
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
