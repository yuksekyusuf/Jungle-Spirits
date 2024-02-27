//
//  CreditView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 19.09.2023.
//

import SwiftUI
import SwiftUIIntrospect

struct CreditView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var appLanguageManager: AppLanguageManager

    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
//    @State private var scrollOffset: Int = 0
    @State private var autoScrolling = false
    @State private var scrollAmount: CGFloat = 0
    @State private var scrollTarget: String? = nil
    @State private var contentOffset: CGPoint = .zero

    @Binding var isPresent: Bool
    
    var designer: String {
        appLanguageManager.localizedStringForKey("DESIGNER", language: appLanguageManager.currentLanguage)
    }
    
    var developer: String {
        appLanguageManager.localizedStringForKey("DEVELOPER", language: appLanguageManager.currentLanguage)
    }
    private var overlayView: some View {
        ZStack{
            
            ScrollViewReader { proxy in
                
//                ScrollableView(self.$contentOffset, animationDuration: 6.0, showsScrollIndicator: false, axis: .vertical) {
//                    LazyVStack {
//                        Color.clear.frame(height: 1).id(1)
//
//                        Image("CreditLogo")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 270, height: 168)
//                            .padding(.top, 48)
////                            .id(1)
//                        Image("CreditLine")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 164, height: 48)
//                            .padding(.top, 10)
//                     
//
//                        VStack(spacing: 0) {
//                            Text("YASIR")
//                                .font(Font.custom("TempleGemsRegular", size: 28))
//                                .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95))
//                                .padding(.top, 20)
//
//                            Text(designer)
//                                .font(Font.custom("TempleGemsRegular", size: 23))
//                                .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95).opacity(0.4))
//                                .offset(y: -10)
//                            Button {
//                                openURL(URL(string: "https://twitter.com/yasirbugra")!)
//                            } label: {
//                                Image("YasirButton")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .offset(y: -10)
//                                    .id(2)
//
//                            }
//
//                            VStack(spacing: 0) {
//                                Text("YUSUF")
//                                    .font(Font.custom("TempleGemsRegular", size: 28))
//                                    .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95))
//                                    .padding(.top, 32)
//                                Text(developer)
//                                    .font(Font.custom("TempleGemsRegular", size: 23))
//                                    .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95).opacity(0.4))
//                                    .offset(y: -10)
//                                Button {
//                                    openURL(URL(string: "https://twitter.com/ay_yuksek")!)
//                                } label: {
//                                    Image("YusufButton")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .offset(y: -10)
//                                }
//
//                            }
//                            .offset(y: -32)
//                            Text("MADE IN NYC . 2023")
//                                .font(Font.custom("TempleGemsRegular", size: 18))
//                                .multilineTextAlignment(.center)
//                                .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95))                             
//                                .frame(width: 211, alignment: .center)
//                                .offset(y: -24)
//                                .id(3)
//                        }
//                        .frame(width: 168)
//                        Color.clear.frame(height: 1).id("end")
//                    }
//                    .frame(width: 270)
//                    .onAppear {
//                            self.contentOffset = CGPoint(x: 0, y: (300))
//                    }
//                }
//                .background {
//                    Image("CreditBackground")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 284, height: 302)
//                }

            }
            
        }
        
    }
    var body: some View {
        VStack {
            ZStack {
                overlayView
                .frame(width: 284, height: 302)
                .shadow(color: .black.opacity(0.45), radius: 8, x: 0, y: 10)
                Button {
                    withAnimation(.easeOut(duration: 0.5)) {
                        self.isPresent.toggle()
                    }
                } label: {
                    Image("CreditButton")
                        .resizable()
                        .scaledToFill()
                    
                }
                .frame(width: 44, height: 44)
                .offset(x: 138, y: -138)
                
            }
            
        }
        
        .transition(.scale)
        .background(
            ZStack {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 1, green: 0.74, blue: 0.83), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.41, green: 0.33, blue: 0.88), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 1, y: 0),
                    endPoint: UnitPoint(x: 0, y: 1)
                )
                    .clipShape(RoundedRectangle(cornerRadius: 48, style: .continuous))
                
                    
            }
                .frame(width: 307, height: 326)
            
        )
        
      
    }

}

struct CreditView_Previews: PreviewProvider {
    static var previews: some View {
        @State var present = true
        CreditView(isPresent: $present)
            .environmentObject(AppLanguageManager())
    }
}




