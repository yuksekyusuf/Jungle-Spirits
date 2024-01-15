//
//  SwiftUIView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 13.01.2024.
//

import SwiftUI
import Pow

struct IrisView: View {
    @State var sealed = false
    @State var showLevelMap = false
    var body: some View {
            ZStack {
                if sealed {
                    Image("Menu Screen")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.movingParts.iris(blurRadius: 10))

                    if showLevelMap {
                        Image("mapsTabBackground")
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }



                }
            }
            .autotoggle($sealed, with: .spring(dampingFraction: 1))

    }

}
//
struct GlowExample: View {
    @State var isFormValid = false

    var body: some View {
        ZStack {
            Color.clear
            JungleButtonView(text: "ENTER THE JUNGLE", width: 300, height: 50)
                .conditionalEffect(.repeat(.glow(color: .blue, radius: 70), every: 1.5  ),
                                   condition: isFormValid)
            .animation(.default, value: isFormValid)
            .onTapGesture {
                isFormValid.toggle()
            }
        }
    }

}


struct GlowExample_Previews: PreviewProvider {
    static var previews: some View {
        GlowExample()
    }
}
