//
//  CreditView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 19.09.2023.
//

import SwiftUI

struct CreditView: View {
    @Environment(\.openURL) var openURL
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State private var scrollOffset: Int = 0
    @Binding var isPresent: Bool
    private var overlayView: some View {
        ZStack{
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Image("CreditLogo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 270, height: 168)
                            .padding(.top, 48)
                            .id(1)
                        Image("CreditLine")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 164, height: 48)
                            .id(2)
                        
                        VStack(spacing: 0) {
                            Text("YASIR")
                                .font(Font.custom("TempleGemsRegular", size: 28))
                                .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95))
                                .padding(.top, 32)
                            Text("DESIGNER")
                                .font(Font.custom("TempleGemsRegular", size: 23))
                                .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95).opacity(0.4))
                                .offset(y: -10)
                            Button {
                                openURL(URL(string: "https://twitter.com/yasirbugra")!)
                            } label: {
                                Image("YasirButton")
                                    .resizable()
                                    .scaledToFit()
                                    .offset(y: -10)
                                    .id(3)
                                
                            }
                            VStack(spacing: 0) {
                                Text("YUSUF")
                                    .font(Font.custom("TempleGemsRegular", size: 28))
                                    .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95))
                                    .padding(.top, 32)
                                Text("DEVELOPER")
                                    .font(Font.custom("TempleGemsRegular", size: 23))
                                    .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95).opacity(0.4))
                                    .offset(y: -10)
                                Button {
                                    openURL(URL(string: "https://twitter.com/ay_yuksek")!)
                                } label: {
                                    Image("YusufButton")
                                        .resizable()
                                        .scaledToFit()
                                        .offset(y: -10)
                                        .id(4)
                                }
                            }
                            .offset(y: -32)
                            
                            Text("MADE IN NYC . 2023")
                                .font(Font.custom("TempleGemsRegular", size: 18))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95))                             .frame(width: 211, alignment: .center)
                                .offset(y: -24)
                                .id(5)
                            
                            Color.clear.id("end")
                            
                        }
                        .frame(width: 168)
                        
                    }
                    .frame(width: 270)
                }
                .background {
                    Image("CreditBackground")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 284, height: 302)
                }
//                .onReceive(timer) { _ in
//                                withAnimation {
//                                    proxy.scrollTo("end", anchor: .bottom)
//                                }
//                            }
//                .onLongPressGesture {
//                    timer.upstream.connect().cancel()
//
//                }
//                .onTapGesture {
//                    timer.upstream.connect().cancel()
//
//                }
            }
            
        }
        
    }
    var body: some View {

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
    }
}
