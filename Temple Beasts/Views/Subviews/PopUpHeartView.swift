//
//  PopUpHeartView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 13.01.2024.
//

import SwiftUI
import Pow

struct PopUpHeartView: View {
    let remainingHearts: Int
    @State var isAdded = false
    var body: some View {
        VStack {
            ZStack {
                if isAdded {
                    HeartView(hearts: remainingHearts)
                    .transition(.movingParts.vanish(.blue))            }
//                    .transition(AnyTransition.asymmetric(insertion: .movingParts.vanish(.blue), removal: .movingParts.vanish(.blue)))            }
                
                
                
            }
            .autotoggle($isAdded, with: .spring())
            Button {
                isAdded.toggle()
            } label: {
                Text("Click me")
                    .font(.headline)
            }

        }
        
        
    }
}

struct PopUpHeartView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpHeartView(remainingHearts: 5)
    }
}
