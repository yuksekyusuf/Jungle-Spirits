//
//  HeartView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 17.11.2023.
//

import SwiftUI

struct HeartView: View {
//    let hearts: Int
    @EnvironmentObject var gameCenterManager: GameCenterManager
    @EnvironmentObject var heartManager: HeartManager
    var body: some View {
        ZStack {
            Image("heartFrame")
                .resizable()
                .scaledToFill()
                .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 4)
            HStack {
                Image("heartPic")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .padding(.trailing, 2)
                Text("\(heartManager.currentHeartCount)")
                    .font(.custom("TempleGemsRegular", size: 30))
                    .foregroundColor(.white)
                    .stroke(color: .black, width: 1.0)
                    .shadow(color: .black, radius: 0, x: 0, y: 3)
                    .offset(x: -1, y: 1)
                
            }
        }                .frame(width: 74, height: 50)
        
        
    }
}

struct HeartView_Previews: PreviewProvider {
    static var previews: some View {
        HeartView().environmentObject(GameCenterManager(currentPlayer: .player1))
    }
}
