//
//  test.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 15.09.2023.
//

import SwiftUI

struct TextView: View {
    let text: String
    var body: some View {
        StrokeText(text: text, width: 1.75, color: .black)
            .font(.custom("Watermelon-Regular", size: 24))
            .foregroundColor(.white)
            .shadow(color: .black, radius: 0, x: 0, y: 3)
            .shadow(color: Color("ShadowColor"), radius: 0, x: 0, y: 4)
    }
}
struct StrokeText: View {
    let text: String
    let width: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(color)
            Text(text)
        }
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        TextView(text: "Welcome")
    }
}
