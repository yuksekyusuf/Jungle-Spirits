//
//  SwiftUIView2.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 14.01.2024.
//

import SwiftUI

struct SealedMapView: View {
    @EnvironmentObject var appLanguageManager: AppLanguageManager

    var sealed: String {
        appLanguageManager.localizedStringForKey("SEALED", language: appLanguageManager.currentLanguage)
    }
    
    var finishMap: String {
        appLanguageManager.localizedStringForKey("FINISH_MAP", language: appLanguageManager.currentLanguage)
    }
    
    var body: some View {
        ZStack {
            Image("sealedMap")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.95)
            VStack(spacing: 0) {
                Text(sealed)
                    .font(.custom("TempleGemsRegular", size: 30))
                    .foregroundColor(.white)
                    .stroke(color: .black, width: 1.0)
                    .shadow(color: .black, radius: 0, x: 0, y: 3)
                Text(finishMap)
                    .font(.custom("TempleGemsRegular", size: 16))
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
