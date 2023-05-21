//
//  SwiftUIView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/21/23.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        //Rectangle 5622
        
        //Rectangle 5621
//        ZStack{
//            RoundedRectangle(cornerRadius: 44)
//                .fill(Color(#colorLiteral(red: 0.16862745583057404, green: 0.07058823853731155, blue: 0.4000000059604645, alpha: 1)))
//            .frame(width: 56, height: 32)
//            RoundedRectangle(cornerRadius: 44)
//                .fill(Color(#colorLiteral(red: 0.4125000238418579, green: 1, blue: 0.8589999675750732, alpha: 1)))
//            .frame(width: 24, height: 24)
//        }
        
        var systemImage: String = "checkmark"
            var activeColor: Color = .green
         
            
                HStack {
                    
         
                    Spacer()
         
                    RoundedRectangle(cornerRadius: 30)
                        .fill(activeColor)
                        .overlay {
                            Circle()
                                .fill(.white)
                                .padding(3)
                                .overlay {
                                    Image(systemName: systemImage)
                                        .foregroundColor(activeColor)
                                }
                                .offset(x: -10)
         
                        }
                        .frame(width: 50, height: 32)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                
                            }
                        }
                }
            
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
