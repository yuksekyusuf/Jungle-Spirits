//
//  HeartStatusView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 2.12.2023.
//

import SwiftUI

struct HeartStatusView: View {
    let heartCount: Int
    @EnvironmentObject var appLanguageManager: AppLanguageManager

    @Binding var nextHeartTime: String
    @Binding var isPresent: Bool
    
    var hearts: String {
        appLanguageManager.localizedStringForKey("HEARTS", language: appLanguageManager.currentLanguage)
    }
    
    var next_hearts: String {
        appLanguageManager.localizedStringForKey("NEXT_HEARTS", language: appLanguageManager.currentLanguage)
    }
    
    var okay: String {
        appLanguageManager.localizedStringForKey("OK", language: appLanguageManager.currentLanguage)
    }
    
    var body: some View {
        ZStack {
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 272, height: 166)
              .background(
                LinearGradient(
                  stops: [
                    Gradient.Stop(color: Color(red: 0.73, green: 0.76, blue: 1), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.54, green: 0.48, blue: 0.91), location: 1.00),
                  ],
                  startPoint: UnitPoint(x: 1, y: 0),
                  endPoint: UnitPoint(x: 0, y: 1)
                )
              )
              .cornerRadius(44)
              .shadow(color: .black.opacity(0.45), radius: 20, x: 0, y: 32)
            Image("HeartBackground")
                .resizable()
                .scaledToFit()
                .frame(width: 252)
            Button {
                withAnimation {
                    self.isPresent.toggle()
                }
            } label: {
                ZStack(alignment: .center) {
                    Rectangle()
                        .fill(Color(red: 0.48, green: 0.4, blue: 0.98))
                        .frame(width: 148, height: 42, alignment: .center)
                        .cornerRadius(14)
                        .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
                    Text(okay)
                        .font(Font.custom("TempleGemsRegular", size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.83, green: 0.85, blue: 1))
                        .frame(width: 148, height: 42, alignment: .center)
                        .offset(y: 2)

                }
               
            }
            .offset(y: 80)
            VStack {
                Text("\(heartCount) \(hearts.capitalizedSentence)")
                .font(Font.custom("Watermelon", size: 32))
                .kerning(0.96)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.top, 10)
                .padding(.bottom, 5)
                Text("\(next_hearts) \(nextHeartTime)")
                  .font(Font.custom("Temple Gems", size: 20))
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.84, green: 0.82, blue: 1))
                  .frame(width: 168, alignment: .center)
            }
            .offset(y: 2)
            

            .frame(width: 253, alignment: .center)
            if heartCount == 0 {
                Image("noHeart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 116)
                    .offset(y: -65)
            } else {
                Image("heartRemains")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 116)
                    .offset(y: -65)
            }
            

        }
        
    }
    
    func localizedStringForKey(_ key: String, language: String) -> String {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

struct HeartStatusView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPresentTrue = true
        @State var remainingTime = "9:27"
        HeartStatusView(heartCount: 0, nextHeartTime: $remainingTime, isPresent: $isPresentTrue).environmentObject(AppLanguageManager())
            
    }
}


