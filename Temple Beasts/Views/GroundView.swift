//
//  SwiftUIView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/5/23.
//

import SwiftUI


struct GroundView: View {
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .opacity(0.7)
            .frame(width: 75, height: 75)
            .cornerRadius(10)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        GroundView()
    }
}
