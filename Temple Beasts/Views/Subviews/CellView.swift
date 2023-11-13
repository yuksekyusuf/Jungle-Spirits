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
    let width: CGFloat
    let offsetY = UIScreen.main.bounds.height * 0.0046
    var isPressed: Bool
    @Binding var convertedCells: [(row: Int, col: Int, byPlayer: CellState)]
    @Binding var previouslyConvertedCells: [(row: Int, col: Int, byPlayer: CellState)]
    let cellPosition: (row: Int, col: Int)
    @Binding var moveMade: Bool
    @State private var selectedUnselectedImage: String = Self.randomUnselectedImage()
    
    
    var body: some View {
        ZStack {
            if state == .obstacle {
                EmptyView()
            } else {
                Image(selectedUnselectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: width + 6)
                
                PlayerView(player: state, selected: isSelected, cellPosition: cellPosition, convertedCells: $convertedCells, previouslyConvertedCells: $previouslyConvertedCells)
                    .frame(width: width, height: width)
                    .transition(.opacity)
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                    .offset(y: -4)
                
                if state == .obstacle {
                    Image("") // Replace with your obstacle image name
                        .resizable()
                        .scaledToFit()
                        .frame(width: width, height: width)
                }
                
                
                if highlighted && state == .empty {
                    Image("Highlighted")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(6)
                        .frame(width: width - 2.9)
                        .offset(y: -5)
                    
                }
                if outerHighlighted && state == .empty {
                    Image("OuterHighlighted")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(6)
                        .frame(width: width - 2.9)
                        .offset(y: -5)
                    
                }
                if isSelected && state == .player1 {
                    Image("EllipseRed")
                        .resizable()
                        .scaledToFill()
                        .frame(width: width + 30, height: width + 30)
                        .allowsHitTesting(false)
                        .blendMode(.overlay)
                    
                }
                if isSelected && state == .player2 {
                    Image("EllipseBlue")
                        .resizable()
                        .scaledToFill()
                        .frame(width: width + 30, height: width + 30)
                        .allowsHitTesting(false)
                        .blendMode(.overlay)
                }
            }
        }
        .frame(width: width, height: width + 6)
    }
    private static func randomUnselectedImage() -> String {
        let images = ["Unselected cell 1", "Unselected cell 2", "Unselected cell 3", "Unselected cell 4"]
        return images.randomElement() ?? "Unselected cell 1"
    }
}
struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        @State var convertedCells: [(row: Int, col: Int, byPlayer: CellState)] = [(1, 1, byPlayer: .player1)]
        @State var booli = false
        CellView(state: .empty, isSelected: true, highlighted: true, outerHighlighted: false, width: 80, isPressed: false, convertedCells: $convertedCells, previouslyConvertedCells: $convertedCells, cellPosition: (row: 30, col: 1), moveMade: $booli)
    }
}
