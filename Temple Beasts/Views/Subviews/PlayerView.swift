//
//  PlayerView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/5/23.
//

import SwiftUI
//import Lottie

struct PlayerView: View {
    var player: CellState
    var selected: Bool
    
    @State private var isPressed: Bool = false
    @State private var conversionCompleted: Bool = false
    var onConversion: (() -> Void)? = nil
    let cellPosition: (row: Int, col: Int)
    let animationDuration: TimeInterval = 2.0
    
    @Binding var convertedCells: [(row: Int, col: Int, byPlayer: CellState)]
    @Binding var previouslyConvertedCells: [(row: Int, col: Int, byPlayer: CellState)]


    var body: some View {
        HStack {
            
            if convertedCells.contains(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) {
                let conversion = convertedCells.first(where: { $0.row == cellPosition.row && $0.col == cellPosition.col })
                if conversion?.byPlayer == .player1 {
                    LottieView(animationName: "blueToRed", ifActive: false)
                                .onAppear {
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
//                                        if let index = convertedCells.firstIndex(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) {
//                                            convertedCells.remove(at: index)
//                                        }
//                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                                        if let index = convertedCells.firstIndex(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) {
                                                                        conversionCompleted = true
                                                                        convertedCells.remove(at: index)
                                                                        conversionCompleted = false
                                                                    }
                                    }
                                }
                        } else {
                            LottieView(animationName: "redToBlue", ifActive: false)
                                .onAppear {
                                    //                                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                                    //                                        if let index = convertedCells.firstIndex(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) {
                                    //                                            convertedCells.remove(at: index)
                                    //                                        }
                                    //                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                                        if let index = convertedCells.firstIndex(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) {
                                                                        conversionCompleted = true
                                                                        convertedCells.remove(at: index)
                                                                        conversionCompleted = false
                                                                    }
                                    }
                                }
                        }
            }
            else {
                if selected == true {
                    if player == .player1 {
                        LottieView(animationName: "redActiveAnimation", ifActive: true)
    //                    Image(uiImage: UIImage(named: "redActive")!)
    //                        .resizable()
    //                        .aspectRatio(contentMode: .fit)
    //                        .clipped()
                    } else if player == .player2 {
                        LottieView(animationName: "gemBlue-select", ifActive: true)

    //                    Image(uiImage: UIImage(named: "blueActive")!)
    //                        .resizable()
    //                        .aspectRatio(contentMode: .fit)
    //                        .clipped()
                    }
                } else if selected == false {
                    if player == .player1 {
                        LottieView(animationName: "redNonActiveAnimation", ifActive: false)
    //                    Image(uiImage: UIImage(named: "Red")!)
    //                        .resizable()
    //                        .aspectRatio(contentMode: .fit)
    //                        .clipped()
                    } else if player == .player2 {
                        LottieView(animationName: "gemBlue-deselect", ifActive: false)

    //                    Image(uiImage: UIImage(named: "Blue")!)
    //                        .resizable()
    //                        .aspectRatio(contentMode: .fit)
    //                        .clipped()
                    }
                }
            }
        }
        .animation(.default, value: conversionCompleted)
        
    }
}

//struct PlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerView(player: .player1, selected: false)
//    }
//}
