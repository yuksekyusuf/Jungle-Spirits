//
//  ButtonView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 15.09.2023.
//

import SwiftUI

struct ButtonView: View {
    let text: String?
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .fill(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color("ButtonColor"), location: 0),
                        .init(color: Color("ButtonColor"), location: 1)]),
                    startPoint: UnitPoint(x: 1.001960580351438, y: 0.4999984904828132),
                    endPoint: UnitPoint(x: 0.001960653828999348, y: 0.4999989975336838)).shadow(.inner(color: Color("ShadowColor"), radius: 0, x: 0, y: -3)))
                .background(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.black, lineWidth: 8)
                    )
                .shadow(color: .black, radius: 0, x: 0, y: 4)
                .frame(width: width, height: height)
            if let text {
                TextView(text: text)
            }
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "Welcome", width: 200, height: 50)
    }
}
