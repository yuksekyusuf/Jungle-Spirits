//
//  PieceCountView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 8.06.2023.
//

import SwiftUI

struct PieceCountView: View {
    var pieceCount: Int
    var body: some View {
        Text("\(pieceCount)")
            .font(.system(size: 30, weight: .heavy, design: .rounded))
            .foregroundColor(Color(#colorLiteral(red: 0.93, green: 0.93, blue: 1, alpha: 1)))
            .tracking(0.9)
            .multilineTextAlignment(.center)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius:0, x:0, y:2)
    }
}

struct PieceCountView_Previews: PreviewProvider {
    static var previews: some View {
        PieceCountView(pieceCount: 2)
    }
}
