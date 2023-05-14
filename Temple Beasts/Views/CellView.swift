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
//            Component 1792
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(red: 0.215, green: 0.207, blue: 0.417))
                PlayerView(player: state)
                
                
//                RoundedRectangle(cornerRadius: 6)
//                    .fill(LinearGradient(
//                        gradient: Gradient(stops: [
//                            .init(color: Color(red: 0, green: 0, blue: 0, opacity: 0), location: 0),
//                            .init(color: Color(red: 0, green: 0, blue: 0, opacity: 0.24), location: 1)
//                        ]),
//                        startPoint: UnitPoint(x: 0.5, y: 0),
//                        endPoint: UnitPoint(x: 0.5, y: 1)
//                    ))
//                    .blendMode(.overlay)
//
//                RoundedRectangle(cornerRadius: 6)
//                    .strokeBorder(Color(red: 0.169, green: 0.146, blue: 0.433), lineWidth: 1)
//
//                RoundedRectangle(cornerRadius: 6)
//                    .fill(LinearGradient(
//                        gradient: Gradient(stops: [
//                            .init(color: Color(red: 0, green: 0, blue: 0, opacity: 0), location: 0),
//                            .init(color: Color(red: 0, green: 0, blue: 0, opacity: 0.24), location: 1)
//                        ]),
//                        startPoint: UnitPoint(x: 0.5, y: 0),
//                        endPoint: UnitPoint(x: 0.5, y: 1)
//                    ))
            }
            .frame(width: size, height: size)
            
            //Rectangle 5610
            //Rectangle 5610

            
//            Rectangle()
//                .fill(color(for: state))
//                .frame(width: size, height: size)
//                .overlay {
//                    RoundedRectangle(cornerRadius: 5)
//                        .stroke(isSelected ? Color.yellow: Color.black, lineWidth: 1)
//                }
//    //            .overlay {
//    //                RoundedRectangle(cornerRadius: 5)
//    //                    .fill(highlighted ? Color.yellow.opacity(0.3) : Color.clear)
//    //            }
//                .overlay{
//                    RoundedRectangle(cornerRadius: 5)
//                        .fill(highlighted ? Color.blue.opacity(0.1) : Color.clear)
//                }
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
struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(state: .player1, size: 40, isSelected: false, highlighted: false, outerHighlighted: false)
    }
}
