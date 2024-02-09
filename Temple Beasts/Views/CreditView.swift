//
//  CreditView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 19.09.2023.
//

import SwiftUI

struct CreditView: View {
    @Environment(\.openURL) var openURL
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
//    @State private var scrollOffset: Int = 0
    @State private var autoScrolling = true
    @State private var scrollAmount: Int = 0
    @State private var scrollTarget: String? = nil

    @Binding var isPresent: Bool
    private var overlayView: some View {
        ZStack{
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
//                        Color.clear.frame(height: 1).id("start")

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
                        Color.clear.frame(height: 1).id(3)
                        Color.clear.frame(height: 1).id(4)
                        Color.clear.frame(height: 1).id(5)
                        Color.clear.frame(height: 1).id(6)
                        Color.clear.frame(height: 1).id(7)
                        Color.clear.frame(height: 1).id(8)

                        VStack(spacing: 0) {
                            Text("YASIR")
                                .font(Font.custom("TempleGemsRegular", size: 28))
                                .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95))
                                .padding(.top, 32)
                                .id(9)

                            Text("DESIGNER")
                                .font(Font.custom("TempleGemsRegular", size: 23))
                                .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95).opacity(0.4))
                                .offset(y: -10)
                                .id(10)
                            Button {
                                openURL(URL(string: "https://twitter.com/yasirbugra")!)
                            } label: {
                                Image("YasirButton")
                                    .resizable()
                                    .scaledToFit()
                                    .offset(y: -10)
                                    .id(11)
                                
                            }

                            VStack(spacing: 0) {
                                Text("YUSUF")
                                    .font(Font.custom("TempleGemsRegular", size: 28))
                                    .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95))
                                    .padding(.top, 32)
                                    .id(12)
                                Text("DEVELOPER")
                                    .font(Font.custom("TempleGemsRegular", size: 23))
                                    .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95).opacity(0.4))
                                    .offset(y: -10)
                                    .id(13)
                                Button {
                                    openURL(URL(string: "https://twitter.com/ay_yuksek")!)
                                } label: {
                                    Image("YusufButton")
                                        .resizable()
                                        .scaledToFit()
                                        .offset(y: -10)
                                        .id(14)
                                }

                            }
                            .offset(y: -32)
                            
                            Text("MADE IN NYC . 2023")
                                .font(Font.custom("TempleGemsRegular", size: 18))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.62, green: 0.55, blue: 0.95))                             .frame(width: 211, alignment: .center)
                                .offset(y: -24)
                                .id(15)

                            Color.clear.id(13)
                            
                        }
                        .frame(width: 168)
                        Color.clear.frame(height: 1).id("end")

                    }
                    .frame(width: 270)
                    
                }
                
                .background {
                    Image("CreditBackground")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 284, height: 302)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation(.easeInOut(duration: 1.0).speed(0.1)) {
                            proxy.scrollTo("end", anchor: nil)
                        }
                    }
                    
                }
//                .onChange(of: autoScrolling) { new in
//                    if new == true {
//                        withAnimation(.linear(duration: 2.5)) {
//                            proxy.scrollTo(15, anchor: .bottom)
//                        }
//                    }
//                }
//                .onReceive(timer) { _ in
//                            if autoScrolling {
//                                // Perform the scrolling action
//                                // Increment your offset to scroll down
//                                scrollAmount += 1  // Adjust this value as needed
//                                withAnimation(.linear(duration: 0.2)) {
//                                    proxy.scrollTo(scrollAmount, anchor: .bottom)
//                                }
//                            }
//                        }
//                .onChange(of: scrollPosition) { newPosition in
//                    withAnimation(.linear(duration: 0.5)) { // Smooth and slow animation
//                        proxy.scrollTo(Int(newPosition), anchor: .bottom)
//                    }
//                }
//                .onReceive(timer) { _ in
//                    if autoScrolling {
//                        scrollPosition += 0.25 // Very small increment for smooth scrolling
//                        //                                if scrollPosition > 3 { // Adjust based on your content size
//                        //                                    scrollPosition = 1 // Reset or stop scrolling
//                        //                                }
//                    }
//                }
//                .onReceive(timer) { _ in
//                    if autoScrolling {
//                        scrollOffset = min(scrollOffset + 1, CGFloat.leastNonzeroMagnitude)
//                        withAnimation(.easeOut(duration: 1.5)) {
//                            proxy.scrollTo(3, anchor: .bottom) // Assuming the last item has an ID of 3
//                        }
////                        scrollOffset += 1
////                        withAnimation(.linear(duration: 0.15)) {
////                            proxy.scrollTo(scrollOffset)
////                        }
//                    }
//                }
//                .onReceive(timer) { _ in
//                                withAnimation {
//                                    proxy.scrollTo("end", anchor: .bottom)
//                                }
//                            }
//                .onLongPressGesture {
//                    timer.upstream.connect().cancel()
//
//                }
////                .onTapGesture {
////                    timer.upstream.connect().cancel()
////
////                }
            }
            
        }
        
    }
    var body: some View {
        VStack {
            ZStack {
                overlayView
                .frame(width: 284, height: 302)
                .gesture(DragGesture().onChanged({ _ in
                                stopAutoScrolling()
                            }))
                            .onTapGesture {
                                stopAutoScrolling()
                            }
                            .onLongPressGesture {
                                stopAutoScrolling()
                            }
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
        
        .onAppear {
            // Start auto-scrolling after a 1-second delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                autoScrolling = true
            }
        }
        
      
        .onDisappear {
            // Stop auto-scrolling and cleanup when the view disappears
            stopAutoScrolling()
        }
    }
    private func stopAutoScrolling() {
        autoScrolling = false
        timer.upstream.connect().cancel()
    }
}

struct CreditView_Previews: PreviewProvider {
    static var previews: some View {
        @State var present = true
        CreditView(isPresent: $present)
    }
}
