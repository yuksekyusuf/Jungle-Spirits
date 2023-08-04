//
//  InfoTabView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 2.08.2023.
//

import SwiftUI

struct InfoTabView: View {
    let title: String
    let description: String
    let image1: String
    let image2: String
    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.custom("Watermelon-Regular", size: 24))
                .foregroundColor(Color(#colorLiteral(red: 0.63, green: 0.64, blue: 1, alpha: 1)))
                .tracking(0.72)
                .multilineTextAlignment(.center).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:0, x:0, y:1)
                .padding(.bottom, 30)
            SlideView(image1: image1, image2: image2)
                .frame(width: 266)
                .padding(.bottom, 30)
            Text(description)
                .font(.custom("Watermelon-Regular", size: 16))
                .foregroundColor(Color(#colorLiteral(red: 0.62, green: 0.71, blue: 0.8, alpha: 1)))
                .tracking(0.48)
                .multilineTextAlignment(.center)
                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:0, x:0, y:1)
                .lineSpacing(7.0)
        }
        .frame(width: 278)
        .padding(.bottom, 50)

    }
}

struct InfoTabView_Previews: PreviewProvider {
    static var previews: some View {
        InfoTabView(title: "Selecting a Gem", description: "Select a gem. Notice the green and yellow areas? That's where the magic happens!", image1: "Teleport 1", image2: "Teleport 2")
    }
}
