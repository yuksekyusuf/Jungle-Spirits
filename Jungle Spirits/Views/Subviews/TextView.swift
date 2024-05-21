//
//  test.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 15.09.2023.
//

import SwiftUI

struct TextView: View {
    let text: String
    let size: CGFloat
    var body: some View {
        ZStack {
            Text(text)
                .font(.custom("TempleGemsRegular", size: size))                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .stroke(color: .black, width: 1.0)
                .shadow(color: .black, radius: 0, x: 0, y: 3)
                .shadow(color: Color("ShadowColor"), radius: 0, x: 0, y: 4)
        }
    }
}
struct StrokeText: View {
    let text: String
    let width: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(color)
            Text(text)
        }
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        TextView(text: "Üsküdar", size: 24)
    }
}

extension View {
    func stroke(color: Color, width: CGFloat = 1) -> some View {
        modifier(StrokeModifer(strokeSize: width, strokeColor: color))
    }
}

struct StrokeModifer: ViewModifier {
    private let id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .blue
    
    func body(content: Content) -> some View {
        if strokeSize > 0 {
            appliedStrokeBackground(content: content)
        } else {
            content
        }
    }
    
    private func appliedStrokeBackground(content: Content) -> some View {
        content
            .padding(strokeSize*2)
            .background(
                Rectangle()
                    .foregroundColor(strokeColor)
                    .mask(alignment: .center) {
                        mask(content: content)
                    }
            )
    }
    
    func mask(content: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { ctx in
                if let resolvedView = context.resolveSymbol(id: id) {
                    ctx.draw(resolvedView, at: .init(x: size.width/2, y: size.height/2))
                }
            }
        } symbols: {
            content
                .tag(id)
                .blur(radius: strokeSize)
        }
    }
}

struct JungleTextView: View {
    let text: String
    var body: some View {
        ZStack {
            Text(text)
                .font(.custom("TempleGemsRegular", size: 24))
                .foregroundColor(.white)
                .stroke(color: .black, width: 1.0)
                .shadow(color: .black, radius: 0, x: 0, y: 3)
                .shadow(color: Color("ShadowColor4"), radius: 0, x: 0, y: 4)
            
//            StrokeText(text: text, width: 1.75, color: .black)
//                .font(.custom("TempleGemsRegular", size: 24))
//                .foregroundColor(.white)
//                .shadow(color: .black, radius: 0, x: 0, y: 3)
//                .shadow(color: Color("ShadowColor"), radius: 0, x: 0, y: 4)
        }
    }
}
