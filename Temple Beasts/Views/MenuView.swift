//
//  MenuView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/21/23.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        
        
        NavigationView {
            ZStack {
                Image("Menu Screen")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            
                VStack(spacing: 0) {
                    
                    NavigationLink {
                        GameView()
                    } label: {
                        ZStack {
                            Image("Button")
                            
                            Text("Single Player").font(.custom("Watermelon-Regular", size: 24)).foregroundColor(Color(#colorLiteral(red: 0.83, green: 0.85, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                            //Available in iOS 14 only
                            .textCase(.uppercase).shadow(color: Color(#colorLiteral(red: 0.46, green: 0.03, blue: 0.13, alpha: 1)), radius:0, x:0, y:1)
                        }
                        .padding(.bottom, -10)
                    }


                    
                    Button {
                        
                    } label: {
                        ZStack {
                            Image("Button")
                            
                            Text("1 vs 1").font(.custom("Watermelon-Regular", size: 24)).foregroundColor(Color(#colorLiteral(red: 0.83, green: 0.85, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                            //Available in iOS 14 only
                            .textCase(.uppercase).shadow(color: Color(#colorLiteral(red: 0.46, green: 0.03, blue: 0.13, alpha: 1)), radius:0, x:0, y:1)
                        }
                    }
                    .padding(.bottom, -10)
                    Button {
                        
                    } label: {
                        ZStack {
                            Image("Button")
                            
                            Text("Settings").font(.custom("Watermelon-Regular", size: 24)).foregroundColor(Color(#colorLiteral(red: 0.83, green: 0.85, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                            //Available in iOS 14 only
                            .textCase(.uppercase).shadow(color: Color(#colorLiteral(red: 0.46, green: 0.03, blue: 0.13, alpha: 1)), radius:0, x:0, y:1)
                        }
                    }
                    .padding(.bottom, -10)


                }
                .padding(.top, 200)
            }
            .ignoresSafeArea()
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
