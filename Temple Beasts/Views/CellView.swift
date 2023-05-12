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
        Rectangle()
            .fill(color(for: state))
            .frame(width: size, height: size)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(isSelected ? Color.yellow: Color.black, lineWidth: 1)
            }
//            .overlay {
//                RoundedRectangle(cornerRadius: 5)
//                    .fill(highlighted ? Color.yellow.opacity(0.3) : Color.clear)
//            }
            .overlay{
                RoundedRectangle(cornerRadius: 5)
                    .fill(highlighted ? Color.blue.opacity(0.1) : Color.clear)
            }
    }
    private func color(for state: CellState) -> Color {
            switch state {
            case .empty:
                return Color(.systemBackground)
            case .player1:
                return Color.red
            case .player2:
                return Color.blue
            }
        }
}
//struct CellView_Previews: PreviewProvider {
//    static var previews: some View {
//        CellView()
//    }
//}
