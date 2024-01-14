//
//  SwiftUIView2.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 14.01.2024.
//

import SwiftUI

struct SealedMapView: View {
    var body: some View {
        ZStack {
            Image("sealedMap")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.95)
            VStack {
                TextView(text: "Map is sealed")
                Text("Finish the other maps first to unseal this map")
                    .font(.custom("TempleGemsRegular", size: 24))
                    .kerning(0.48)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.8, green: 0.8, blue: 1))
                    .frame(width: 190, alignment: .center)
            }
        }
    }
}
struct SealedMapView_Previews: PreviewProvider {
    static var previews: some View {
        SealedMapView()
    }
}
