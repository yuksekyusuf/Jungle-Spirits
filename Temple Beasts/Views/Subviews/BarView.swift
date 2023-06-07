//
//  test.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/20/23.
//

import SwiftUI

struct BarView: View {
    @State var width: CGFloat
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 42)
            .fill(LinearGradient(
                    gradient: Gradient(stops: [
                .init(color: Color(#colorLiteral(red: 1, green: 0.45366665720939636, blue: 0.3791666626930237, alpha: 1)), location: 0),
                .init(color: Color(#colorLiteral(red: 1, green: 0.2078431397676468, blue: 0.3490196168422699, alpha: 1)), location: 0.5104166865348816),
                .init(color: Color(#colorLiteral(red: 0.5583333373069763, green: 0, blue: 0.1675001084804535, alpha: 1)), location: 1)]),
                    startPoint: UnitPoint(x: 1.001960580351438, y: 0.4999984904828132),
                    endPoint: UnitPoint(x: 0.001960653828999348, y: 0.4999989975336838)))

            RoundedRectangle(cornerRadius: 42)
            .strokeBorder(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), lineWidth: 2)
        }
        .compositingGroup()
        .frame(width: width, height: 20)
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.23999999463558197)), radius:0, x:0, y:2.142857074737549)
    }
    
        
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        BarView(width: 244)
    }
}
