//
//  test.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/13/23.
//

import SwiftUI

struct test: View {
    var body: some View {
        //Rectangle 5611
        ZStack {
            
            RoundedRectangle(cornerRadius: 44)
                .fill(LinearGradient(
                        gradient: Gradient(stops: [
                    .init(color: Color(#colorLiteral(red: 0.7333333492279053, green: 0.7614035606384277, blue: 1, alpha: 1)), location: 0),
                    .init(color: Color(#colorLiteral(red: 0.5364739298820496, green: 0.4752604365348816, blue: 0.9125000238418579, alpha: 1)), location: 1)]),
                        startPoint: UnitPoint(x: 0.9999999999999999, y: 0),
                        endPoint: UnitPoint(x: 2.980232305382913e-8, y: 1.0000000310465447)))
            .frame(width: 271, height: 258)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.44999998807907104)), radius:16, x:0, y:10)
            
            //Rectangle 5613
            RoundedRectangle(cornerRadius: 44)
                .fill(Color(#colorLiteral(red: 0.38098958134651184, green: 0.3932499885559082, blue: 0.6875, alpha: 1)))
            .frame(width: 251, height: 238)
        }
        
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
