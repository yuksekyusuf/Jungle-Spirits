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

    var body: some View {
        
        VStack {
            ZStack {
                Image("Unselected cell")
//                if selected {
//                    PlayerView(player: <#T##CellState#>)
//                }
                PlayerView(player: state, selected: isSelected)
                    .frame(width: 64)
                
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
