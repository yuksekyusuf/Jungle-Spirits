//
//  PlayerView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/5/23.
//

import SwiftUI

struct PlayerView: View {
    var player: CellState
    var selected: Bool
    let cellPosition: (row: Int, col: Int)
    @Binding var convertedCells: [(row: Int, col: Int, byPlayer: CellState)]
    @Binding var previouslyConvertedCells: [(row: Int, col: Int, byPlayer: CellState)]
    
    let cellWidth: CGFloat
    
    @Binding var selectedCell: (row: Int, col: Int)?
    @Binding var targetCell: (row: Int, col: Int)?
    
    @State private var scaleAmount: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    
    func regularOrSelectedCircle() -> some View {
        Group {
            if selected {
                if player == .player1 {
                    Circle().foregroundColor(.red)
                } else if player == .player2 {
                    Circle().foregroundColor(.blue)
                }
            } else {
                if player == .player1 {
                    Circle().foregroundColor(.red).opacity(0.5)
                } else if player == .player2 {
                    Circle().foregroundColor(.blue).opacity(0.5)
                }
            }
        }
        .defaultCase { EmptyView() }
    }
    
    var body: some View {
        GeometryReader { geo in
            
            Group {
                    // 1. Check for current conversion
                    if let conversion = convertedCells.first(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) {
                        if conversion.byPlayer == .player1 {
                            Circle().foregroundColor(.red)
                            // [You can add further logic if needed to mimic the Lottie completion]
                        } else {
                            Circle().foregroundColor(.blue)
                            // [You can add further logic if needed to mimic the Lottie completion]
                        }
                    }
                    // 2. Check for previously converted but now selected
                    else if previouslyConvertedCells.contains(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) && selected {
                        regularOrSelectedCircle()
                    }
                    // 3. Check for previously converted but not selected
                    else if previouslyConvertedCells.contains(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) {
                        if player == .player1 {
                            Circle().foregroundColor(.red)
                        } else if player == .player2 {
                            Circle().foregroundColor(.blue)
                        }
                    }
                    // 4. Display regular or selected animation
                    else {
                        regularOrSelectedCircle()
                    }
                }
            .position(x: geo.size.width/2 + offset.width, y: geo.size.height/2 + offset.height)

        }
//        Group {
//            // 1. Check for current conversion
//            if let conversion = convertedCells.first(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) {
//                if conversion.byPlayer == .player1 {
//                    LottieView(animationName: "blueToRed", ifActive: false, contentMode: false, isLoop: false) {
//                        if let index = convertedCells.firstIndex(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) {
//                            convertedCells.remove(at: index)
//                        }
//
//                    }
//
//                } else {
//                    LottieView(animationName: "redToBlue", ifActive: false, contentMode: false, isLoop: false)
//                    {
//                        if let index = convertedCells.firstIndex(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) {
//                            convertedCells.remove(at: index)
//                        }
//
//                    }
//
//                }
//            }
//            // 2. Check for previously converted but now selected
//            else if previouslyConvertedCells.contains(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) && selected {
//                displayRegularOrSelectedAnimation()
//            }
//            // 3. Check for previously converted but not selected
//            else if previouslyConvertedCells.contains(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) {
//                if player == .player1 {
//                    LottieView(animationName: "redDefault", ifActive: false, contentMode: false, isLoop: false)
//                } else if player == .player2 {
//                    LottieView(animationName: "blueDefault", ifActive: false, contentMode: false, isLoop: false)
//                }
//            }
//            // 4. Display regular or selected animation
//            else {
//                displayRegularOrSelectedAnimation()
//            }
//        }
                
        .scaleEffect(scaleAmount)
//        .onTapGesture {
//            let targetPosition = CGPoint(x: CGFloat(cellPosition.col + 1) * cellWidth, y: CGFloat(cellPosition.row + 1) * cellWidth) // Move one cell over as a test
//            self.animateMove(to: targetPosition)
//        }
//        .onReceive([self.selectedCell, self.targetCell].publisher.first()) { _ in
//            guard let selected = selectedCell, let target = targetCell else { return }
//            if selected == self.cellPosition {
//                let targetPosition = CGPoint(x: CGFloat(target.col) * cellWidth, y: CGFloat(target.row) * cellWidth)
//                self.animateMove(to: targetPosition)
//            }
//        }
        .frame(width: cellWidth, height: cellWidth)
    }
    
    
    
    func animateMove(to targetPosition: CGPoint) {
        // Calculate the offset based on the current and target position
        print("Animating to: \(targetPosition)")

        let xOffset = targetPosition.x - CGFloat(cellPosition.col) * cellWidth
        let yOffset = targetPosition.y - CGFloat(cellPosition.row) * cellWidth

        withAnimation(.easeIn(duration: 0.3)) {
            scaleAmount = 0.1
        }

        withAnimation(.easeInOut(duration: 0.5)) {
            offset = CGSize(width: xOffset, height: yOffset)
        }

        withAnimation(.easeOut(duration: 0.3).delay(0.5)) {
            scaleAmount = 1.0
        }
    }
    
    
    func displayRegularOrSelectedAnimation() -> some View {
        Group {
            if selected {
                if player == .player1 {
                    LottieView(animationName: "redActiveAnimation", ifActive: true, contentMode: false, isLoop: false)
                } else if player == .player2 {
                    LottieView(animationName: "gemBlue-select", ifActive: true, contentMode: false, isLoop: false)
                }
            } else {
                if player == .player1 {
                    LottieView(animationName: "redNonActiveAnimation", ifActive: false, contentMode: false, isLoop: false)
                } else if player == .player2 {
                    LottieView(animationName: "gemBlue-deselect", ifActive: false, contentMode: false, isLoop: false)
                    
                }
            }
        }
        .defaultCase { EmptyView() } // Added this line
    }
}

extension View {
    @ViewBuilder
    func defaultCase<Content: View>(_ content: () -> Content) -> some View {
        switch self {
        case is EmptyView:
            content()
        default:
            self
        }
    }
}
