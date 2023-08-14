//
//  LottieView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 13.08.2023.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var animationName: String
    var ifActive: Bool

    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: animationName)
        if ifActive {
            animationView.animationSpeed = 1.75
        }
        animationView.play()
        return animationView
    }
    
    func updateUIView(_ uiView: Lottie.LottieAnimationView, context: Context) {
        
    }
    
    
    typealias UIViewType = LottieAnimationView
    
    
}

