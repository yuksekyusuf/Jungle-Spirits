//
//  SwiftUIView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/21/23.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        VStack {
            Capsule()
                .frame(width: 360, height: 24)
                .foregroundColor(.black)
                .overlay(
                    Capsule()
                        .stroke(Color(red: 236/255, green: 234/255, blue: 235/255),
                                lineWidth: 3)
                        .shadow(color: Color(red: 192/255, green: 189/255, blue: 191/255),
                                radius: 3, x: 1.5, y: 1.5)
                        .clipShape(
                            Capsule()
                        )
                )
                .overlay(
                    Capsule()
                        .frame(width: 50)
                        .foregroundColor(.blue), alignment: .leading
                )

            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.black)
                    .cornerRadius(24)
                    .frame(width: 360, height: 24)
                    .overlay {
                        Capsule()
//                        .stroke(Color(red: 236/255, green: 234/255, blue: 235/255),
//                                lineWidth: 3)
                            .shadow(color: Color.white,
                                radius: 5, x: 2, y: 2)
                        .clipShape(
                            Capsule()
                        )
                    }
                Capsule()
                    .fill(LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(#colorLiteral(red: 1, green: 0.45366665720939636, blue: 0.3791666626930237, alpha: 1)), location: 0),
                            .init(color: Color(#colorLiteral(red: 1, green: 0.2078431397676468, blue: 0.3490196168422699, alpha: 1)), location: 0.5104166865348816),
                            .init(color: Color(#colorLiteral(red: 0.5583333373069763, green: 0, blue: 0.1675001084804535, alpha: 1)), location: 1)]),
                        startPoint: UnitPoint(x: 1.001960580351438, y: 0.4999984904828132),
                        endPoint: UnitPoint(x: 0.001960653828999348, y: 0.4999989975336838)))
                    .innerShadow(5, opacity: 0.5, x: 2, y: 2)
                    .padding(.leading, 4)
                    .frame(width: 250, height: 20)
            }
        }

        //        ZStack {
        //            Color.black
        //            VStack {
        Capsule()
            .fill(LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(#colorLiteral(red: 1, green: 0.45366665720939636, blue: 0.3791666626930237, alpha: 1)), location: 0),
                    .init(color: Color(#colorLiteral(red: 1, green: 0.2078431397676468, blue: 0.3490196168422699, alpha: 1)), location: 0.5104166865348816),
                    .init(color: Color(#colorLiteral(red: 0.5583333373069763, green: 0, blue: 0.1675001084804535, alpha: 1)), location: 1)]),
                startPoint: UnitPoint(x: 1.001960580351438, y: 0.4999984904828132),
                endPoint: UnitPoint(x: 0.001960653828999348, y: 0.4999989975336838)))
        //                .innerShadow(5, opacity: 0.5, x: 2, y: 2)
            .padding(.leading, 4)
            .frame(width: 300, height: 20)
        //            }
        //            .foregroundStyle(
        //                    .blue.gradient.shadow(
        //                        .inner(color: .black, radius: 5, x: 2, y: 2)
        //                    )
        //        )
        //        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
