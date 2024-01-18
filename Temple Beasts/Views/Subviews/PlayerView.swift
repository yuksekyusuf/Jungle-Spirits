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
    


    var body: some View {
        Group {
                // 1. Check for current conversion
                if let conversion = convertedCells.first(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) {
                    if conversion.byPlayer == .player1 {
                        LottieView(animationName: "blueToRed", ifActive: false, contentMode: false, isLoop: false) {
                            if let index = convertedCells.firstIndex(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) {
                                convertedCells.remove(at: index)
                            }

                        }

                    } else {
                        LottieView(animationName: "redToBlue", ifActive: false, contentMode: false, isLoop: false)
                        {
                            if let index = convertedCells.firstIndex(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) {
                                convertedCells.remove(at: index)
                            }
                            
                        }

                    }
                }
                // 2. Check for previously converted but now selected
                else if previouslyConvertedCells.contains(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) && selected {
                    displayRegularOrSelectedAnimation()
                }
                // 3. Check for previously converted but not selected
                else if previouslyConvertedCells.contains(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) {
                    if player == .player1 {
                        LottieView(animationName: "redDefault", ifActive: false, contentMode: false, isLoop: false)
//                        LottieView2(lottieFile: "redDefault")
                    } else if player == .player2 {
                        LottieView(animationName: "blueDefault", ifActive: false, contentMode: false, isLoop: false)
//                        LottieView2(lottieFile: "blueDefault")

                    }
                }
                // 4. Display regular or selected animation
                else {
                    displayRegularOrSelectedAnimation()
                }
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
