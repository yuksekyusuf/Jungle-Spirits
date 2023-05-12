//
//  PlayerView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/5/23.
//

import SwiftUI

struct PlayerView: View {
    var body: some View {
        playerImage
            .foregroundColor(.white)
    }
    
    var playerImage: some View {
        Image(systemName: "star.fill")
            .font(.headline)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
