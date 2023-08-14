//
//  CellView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/10/23.
//

import SwiftUI

struct CellView: View {
    let state: CellState
    let isSelected: Bool
    let highlighted: Bool
    let outerHighlighted: Bool
    let width = UIScreen.main.bounds.width * 0.175
    let offsetY = UIScreen.main.bounds.height * 0.0046
    let tileNumbers = [1, 2, 3, 4]

    var body: some View {
        ZStack {
            if let random = tileNumbers.randomElement() {
                Image("Unselected cell \(random)")
                                   .resizable()
                                   .scaledToFit()
                                   .frame(width: width)
            }

            
            PlayerView(player: state, selected: isSelected)
                .frame(width: width)
                .transition(.opacity)
                .animation(.easeIn(duration: 0.5), value: state)
//                .offset(y: -offsetY)

            if highlighted && state == .empty {
                Image("Highlighted")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(6)
//                    .offset(y: -offsetY)

            }
            if outerHighlighted && state == .empty {
                Image("OuterHighlighted")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(6)
//                    .offset(y: -offsetY)

            }
            if isSelected && state == .player1 {
                Image("EllipseRed")
                    .blendMode(.overlay)
                    .allowsHitTesting(false)
            }
            if isSelected && state == .player2 {
                Image("EllipseBlue")
                    .blendMode(.overlay)
                    .allowsHitTesting(false)
            }
        }
        .frame(width: width, height: width)
    }
}
struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(state: .player1, isSelected: false, highlighted: false, outerHighlighted: true)
    }
}
