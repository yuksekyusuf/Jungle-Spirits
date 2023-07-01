//
//  Ext+InnerShadow.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/20/23.
//

import SwiftUI


extension View {
    func innerShadow(_ shadowRadius: Double, opacity: Double = 0.5, x: Double = 0, y: Double = 0) -> some View {
        let opacity = min(1, max(0, opacity))
//        return self
//            .background {
//                Color(white: 1 - opacity)
//                    .overlay {
//                        Color.white
//                            .mask(self)
//                            .blur(radius: shadowRadius)
//                            .offset(x: x, y: y)
//                    }
//                    .mask(self)
//                    .compositingGroup()
//            }
//            .blendMode(.multiply)
//            .compositingGroup()
//
        
        return self
//            .compositingGroup()
            .background(
                Color(white: opacity)
                    .overlay(content: {
                        Color.white
                            .mask(self)
//                            .blur(radius: 0)
                            .offset(x: x, y: y)
                    })
                    .mask(self)
                    .compositingGroup()

            )
            .blendMode(.multiply)
            .compositingGroup()
        
    }
}
