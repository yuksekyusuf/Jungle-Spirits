//
//  PauseMenuView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/21/23.
//

import SwiftUI

struct PauseMenuView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var showPauseMenu: Bool
    @State private var isMusicOn = false
    @State private var isSoundOn = false
    var body: some View {
        
        
        VStack {
            
            Image("pauseMenuBackground")
                .padding(.top, -200)
                .overlay{
                    ZStack {
                        RoundedRectangle(cornerRadius: 44)
                            .fill(LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color(#colorLiteral(red: 0.7333333492279053, green: 0.7614035606384277, blue: 1, alpha: 1)), location: 0),
                                    .init(color: Color(#colorLiteral(red: 0.5364739298820496, green: 0.4752604365348816, blue: 0.9125000238418579, alpha: 1)), location: 1)]),
                                startPoint: UnitPoint(x: 0.9999999999999999, y: 0),
                                endPoint: UnitPoint(x: 2.980232305382913e-8, y: 1.0000000310465447)))
                            .frame(width: 271, height: 258)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.44999998807907104)), radius:16, x:0, y:10)
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color("PauseMenuColor1"), Color("PauseMenuColor2")]), startPoint: .top, endPoint: .bottom))
                            .frame(width: 240, height: 240)
                            .cornerRadius(44)
                        
                        //pauseMenuPattern
                        Image(uiImage: #imageLiteral(resourceName: "pauseMenuPattern"))
                            .resizable()
                            .frame(width: 240, height: 240)
                            .clipped()
                            .blendMode(.overlay)
                            .frame(width: 240, height: 240)
                            .cornerRadius(44)
                        
                        Image("pauseMenuPieces")
                            .offset(y: -122)
                        
                        
                        
                        VStack {
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color("AnotherPause"))
                                .frame(width: 201, height: 89)
                                .padding(.top, 40)
                                .overlay{
                                    
                                    HStack {
                                        VStack(spacing: 5) {
                                            Image("Note")
                                            
                                            Image("iconSound")

                                        }
                                        
                                        VStack(spacing: 12) {
                                            Text("MUSIC")
                                                .font(Font.custom("Watermelon-Regular", size: 24))
                                                .foregroundColor(Color(#colorLiteral(red: 0.83, green: 0.85, blue: 1, alpha: 1)))
                                            Text("SOUND")
                                                .font(Font.custom("Watermelon-Regular", size: 24))
                                                .foregroundColor(Color(#colorLiteral(red: 0.83, green: 0.85, blue: 1, alpha: 1)))
                                        }
                                        
                                        VStack(spacing: 5) {
                                            Toggle(isOn: $isMusicOn) {
                                                Text("")
                                            }
                                                .toggleStyle(CustomToggleStyle())
                                            Toggle(isOn: $isSoundOn) {
                                                Text("")
                                            }
                                                .toggleStyle(CustomToggleStyle())
                                        }
                                    }
                                    .padding(.top, 40)
                                }
                            Spacer()
                            HStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .frame(width: 59, height: 44)
                                    .foregroundColor(Color("AnotherPause"))
                                    .overlay{
                                        Image("iconReplay")
                                    }
                                
                                RoundedRectangle(cornerRadius: 14)
                                    .frame(width: 59, height: 44)
                                    .foregroundColor(Color("AnotherPause"))
                                    .padding([.leading, .trailing], 6)
                                    .overlay{
                                        Image("iconResume")
                                    }
                                    .onTapGesture {
                                        showPauseMenu.toggle()
                                    }
                                
                                RoundedRectangle(cornerRadius: 14)
                                    .frame(width: 59, height: 44)
                                    .foregroundColor(Color("AnotherPause"))
                                    .overlay{
                                        Image("iconHome")
                                    }
                            }
                            .padding(.bottom, 20)
                            Spacer()
                            
                        }
                        
                        
                    }
                }
            
        }
        
    }
}

struct CustomToggleStyle: ToggleStyle {
    
    var activeColor: Color = Color(#colorLiteral(red: 0.4125000238418579, green: 1, blue: 0.8589999675750732, alpha: 1))
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            //Rectangle 5621
            RoundedRectangle(cornerRadius: 44)
                .fill(Color(#colorLiteral(red: 0.16862745583057404, green: 0.07058823853731155, blue: 0.4000000059604645, alpha: 1)))
                .overlay{
                    RoundedRectangle(cornerRadius: 44)
                        .fill(configuration.isOn ? Color(#colorLiteral(red: 0.4125000238418579, green: 1, blue: 0.8589999675750732, alpha: 1)) : Color("AnotherPause"))
                        .frame(width: 24, height: 24)
                        .offset(x: configuration.isOn ? 12 : -12)
                }
                .frame(width: 56, height: 32)
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
    
}

//struct PauseMenuView_Previews: PreviewProvider {
//    static var previews: some View {
////        PauseMenuView(showPauseMenu: $true)
//    }
//}
