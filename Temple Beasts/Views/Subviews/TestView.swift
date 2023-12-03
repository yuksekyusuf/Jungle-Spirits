//
//  TestView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 15.11.2023.
//

import SwiftUI
import Lottie

struct CustomTestTabView: View {


    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text("Continue")
              .font(Font.custom("TempleGemsRegular", size: 24))
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.83, green: 0.85, blue: 1))
              .frame(width: 122, height: 22, alignment: .center)
        }
        .padding(10)
        .frame(width: 100)
//        .frame(maxWidth: .infinity, minHeight: 42, maxHeight: 42, alignment: .center)
        .background(Color(red: 0.48, green: 0.4, blue: 0.98))
        .cornerRadius(14)
    }
    
}

struct CustomTestTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTestTabView()
    }
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
