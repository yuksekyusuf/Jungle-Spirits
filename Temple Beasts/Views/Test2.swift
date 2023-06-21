//
//  Test2.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 22.06.2023.
//

import SwiftUI

//
//  TimeBarView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 8.06.2023.
//

import SwiftUI

struct Test2: View {
    
    var remainingTime: Double
    var totalTime: Double
    var body: some View {
        GeometryReader { geo in
            let width = abs(geo.size.width * CGFloat(remainingTime) / CGFloat (totalTime))
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.black)
                    .cornerRadius(24)
                    .frame(width: 360, height: 24)
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
                    .frame(width: width, height: 20)
                
            }
            
        }
        
    }
}

struct Test2_Previews: PreviewProvider {
    static var previews: some View {
        Test2(remainingTime: 100.0, totalTime: 150.0)
    }
}

