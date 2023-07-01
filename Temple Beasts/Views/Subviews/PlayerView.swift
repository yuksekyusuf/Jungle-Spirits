//
//  PlayerView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/5/23.
//

import SwiftUI

struct PlayerView: View {
    var player: CellState
    var selected: Bool
    var body: some View {
        HStack {
            if selected == true {
                if player == .player1 {
                    Image(uiImage: UIImage(named: "redActive")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                } else if player == .player2 {
                    Image(uiImage:  UIImage(named: "blueActive")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                }
            } else if selected == false {
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
    }
    
    var playerImage: some View {
        Image(systemName: "star.fill")
            .font(.headline)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(player: .player2, selected: true)
    }
}