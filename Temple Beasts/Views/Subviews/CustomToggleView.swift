//
//  CustomToggleView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 8.06.2023.
//

import SwiftUI

struct CustomToggleView: ToggleStyle {
    
    var activeColor: Color = Color(#colorLiteral(red: 0.4125000238418579, green: 1, blue: 0.8589999675750732, alpha: 1))
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            RoundedRectangle(cornerRadius: 44)
                .fill(Color(#colorLiteral(red: 0.16862745583057404, green: 0.07058823853731155, blue: 0.4000000059604645, alpha: 1)))
                .overlay{
                    RoundedRectangle(cornerRadius: 44)
                        .fill(configuration.isOn ? Color(#colorLiteral(red: 0.4125000238418579, green: 1, blue: 0.8589999675750732, alpha: 1)) : Color("AnotherPause"))
                        .frame(width: 24, height: 24)
                        .offset(x: configuration.isOn ? 12 : -12)
                }
                .frame(width: 56, height: 32)
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}

