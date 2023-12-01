//
//  HeartView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 17.11.2023.
//

import SwiftUI

struct HeartView: View {
    let hearts: Int
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
                Text("\(hearts)")
                    .font(.custom("TempleGemsRegular", size: 30))
                    .foregroundColor(.white)
                    .stroke(color: .black, width: 1.0)
                    .shadow(color: .black, radius: 0, x: 0, y: 3)

            }
        }                .frame(width: 72, height: 46)


        
    }
}

struct HeartView_Previews: PreviewProvider {
    static var previews: some View {
        HeartView(hearts: 5)
    }
}
