//
//  LottieView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 13.08.2023.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var animationName: String = "L"
    var ifActive: Bool = false
    var contentMode: Bool = false
    var isLoop: Bool = false
    var completion: (() -> Void)? = nil

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView(name: animationName)
        animationView.contentMode = .scaleAspectFit
        if ifActive {
            animationView.animationSpeed = 1.75
        }
        if contentMode && isLoop {
            animationView.loopMode = .loop
        }
        animationView.play { (finished) in
                if finished {
                    completion?()
                }
            }
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
//    typealias UIViewType = LottieAnimationView
    
    
}


struct LottieView2: UIViewRepresentable {
    var lottieFile = "Red Guy Win" // lottiefile
    var loopMode: LottieLoopMode = .loop
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView(name: lottieFile)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play{ (finished) in
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    
    
  
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
