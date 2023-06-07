//
//  MenuButtonView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 8.06.2023.
//

import SwiftUI

struct MenuButtonView: View {
    var text: String
    var body: some View {
        ZStack {
            Image("Button")
            Text(text)
                .font(.custom("Watermelon-Regular", size: 24)).foregroundColor(Color(#colorLiteral(red: 0.83, green: 0.85, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                .textCase(.uppercase).shadow(color: Color(#colorLiteral(red: 0.46, green: 0.03, blue: 0.13, alpha: 1)), radius:0, x:0, y:1)
            
        }
    }
}

struct MenuButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView(text: "Single Player")
    }
}
