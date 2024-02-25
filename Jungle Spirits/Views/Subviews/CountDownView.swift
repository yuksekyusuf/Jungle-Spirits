//
//  SwiftUIView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5.07.2023.
//

import SwiftUI

struct CountDownView: View {
    @State private var counter = 3
    @State private var scale: CGFloat = 0.1
    @State private var opacity: Double = 0.0
    @Binding var isVisible: Bool
    var body: some View {
        ZStack {
            
            
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            if counter > 0 {
                Text("\(counter)")
                    .font(Font.custom("Tricky Jimmy", size: 90))
                    .shadow(color: .black, radius: 24, y: 8)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "#B8DBFF"), Color(hex: "#FFD9CF")]),
                            startPoint: .leading,
                            endPoint: .trailing)
                    )
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            runAnimation()
                        }
                    }
            }
        }
    }
    private func runAnimation() {
        withAnimation(.easeInOut) {
            scale = 2
            opacity = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut) {
                scale = 2
                opacity = 0.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if counter > 1 {
                    counter -= 1
                    scale = 0.1
                    opacity = 1.0
                    runAnimation()
                } else {
                    isVisible = false
                }
            }
        }
    }
}

struct CountDownView_Previews: PreviewProvider {
    static var previews: some View {
        @State var visible = true
        CountDownView(isVisible: $visible)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Text {
    public func foregroundLinearGradient(
        colors: [Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint) -> some View {
            self.overlay {
                LinearGradient(
                    colors: colors,
                    startPoint: startPoint,
                    endPoint: endPoint
                )
                .mask(
                    self
                )
            }
        }
}
