//
//  test.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 4.08.2023.
//

import SwiftUI

struct SlideView: View {
    @State private var isShowingFirstImage = true
    let image1: String
    let image2: String
    let timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
       var body: some View {
           ZStack {
               Image(image1)
                   .resizable()
                   .scaledToFit()
                   .opacity(isShowingFirstImage ? 1 : 0)
               Image(image2)
                   .resizable()
                   .scaledToFit()
                   .mask(Image(image2).resizable())
                   .opacity(isShowingFirstImage ? 0 : 1)
           }
           .onReceive(timer) { _ in
               withAnimation(.easeInOut(duration: 0.4)) {
                   self.isShowingFirstImage.toggle()
               }
           }
       }
}


struct SlideView_Previews: PreviewProvider {
    static var previews: some View {
        SlideView(image1: "Teleport 1", image2: "Teleport 2")
    }
}
