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
    @State private var showAnimation: Bool = false
    var onConversion: (() -> Void)? = nil
    let cellPosition: (row: Int, col: Int)
    
    @Binding var convertedCells: [(row: Int, col: Int, byPlayer: CellState)]


    var body: some View {
        HStack {
            
            if convertedCells.contains(where: { $0.row == cellPosition.row && $0.col == cellPosition.col }) {
                let conversion = convertedCells.first(where: { $0.row == cellPosition.row && $0.col == cellPosition.col })
                if conversion?.byPlayer == .player1 {
                    LottieView(animationName: "blueToRed", ifActive: false)
                                .onAppear {
                                    // Start the Lottie animation or any other setup you need
                                }
                        } else {
                            LottieView(animationName: "redToBlue", ifActive: false)
                                .onAppear {
                                    
                                }
//                            LottieView(name: player1ToPlayer2AnimationName)
//                                .onAppear {
//                                    // Start the Lottie animation or any other setup you need
//                                }
                        }
            
                
            } else {
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
    }
    func convertPiece() {
           // Logic to trigger the Lottie animation
           showAnimation = true
        onConversion?()
       }
}

//struct PlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerView(player: .player1, selected: false)
//    }
//}
