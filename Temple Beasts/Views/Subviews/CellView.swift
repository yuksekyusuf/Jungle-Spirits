//
//  CellView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/10/23.
//

import SwiftUI

struct CellView: View {
    let state: CellState
    let size: CGFloat
    let isSelected: Bool
    let highlighted: Bool
    let outerHighlighted: Bool
    
    @State private var justChanged: Bool = false

    var body: some View {
        
        VStack {
            ZStack {
                Image("Unselected cell")
                    
                
                
                PlayerView(player: state, selected: isSelected)
                    .frame(width: 72)
                    .transition(.opacity)
                    .animation(.easeIn(duration: 0.5), value: state)
                    .offset(y: -4)
                
                if highlighted && state == .empty {
                    Image("Highlighted")
                        .offset(y: -3)
                }
                
                if outerHighlighted && state == .empty {
                    Image("OuterHighlighted")
                        .offset(y: -3)
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
            .frame(width: size, height: size + 8)

        }
    }
}
struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(state: .player1, size: 40, isSelected: false, highlighted: false, outerHighlighted: false)
    }
}
