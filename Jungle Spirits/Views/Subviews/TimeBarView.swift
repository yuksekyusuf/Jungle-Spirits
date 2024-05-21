//
//  TimeBarView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 8.06.2023.
//

import SwiftUI

struct TimeBarView: View {
    var remainingTime: Int
    var totalTime: Int
    let currentPlayer: CellState
    let curretlyPlaying: Bool
    let gameType: GameType
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width * CGFloat(remainingTime) / CGFloat(totalTime)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.black)
                    .cornerRadius(24)
                    .frame(width: geo.size.width, height: 24)
                if gameType == .multiplayer && curretlyPlaying {
                    if currentPlayer == .player1 {
                        Capsule()
                            .fill(LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color(#colorLiteral(red: 1, green: 0.45366665720939636, blue: 0.3791666626930237, alpha: 1)), location: 0),
                                    .init(color: Color(#colorLiteral(red: 1, green: 0.2078431397676468, blue: 0.3490196168422699, alpha: 1)), location: 0.5104166865348816),
                                    .init(color: Color(#colorLiteral(red: 0.5583333373069763, green: 0, blue: 0.1675001084804535, alpha: 1)), location: 1)]),
                                startPoint: UnitPoint(x: 1.001960580351438, y: 0.4999984904828132),
                                endPoint: UnitPoint(x: 0.001960653828999348, y: 0.4999989975336838)).shadow(.inner(color: .white.opacity(0.3), radius: 0, x: 1, y: 3)))
                        
                            .padding(.leading, 4)
                            .frame(width: width, height: 16)
                    } else if currentPlayer == .player2 {
                        Capsule()
                            .fill(LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.21, green: 0.62, blue: 1), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.1, green: 0.46, blue: 1), location: 1.00)
                                ],
                                startPoint: UnitPoint(x: 1, y: 0.5),
                                endPoint: UnitPoint(x: 0, y: 0.5)
                            )
                                .shadow(.inner(color: .white.opacity(0.3), radius: 0, x: 1, y: 3)))
                            .padding(.leading, 4)
                            .frame(width: width, height: 16)
                    }
                } else if gameType == .multiplayer && !curretlyPlaying {
                    if currentPlayer == .player2 {
                        Capsule()
                            .fill(LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color(#colorLiteral(red: 1, green: 0.45366665720939636, blue: 0.3791666626930237, alpha: 1)), location: 0),
                                    .init(color: Color(#colorLiteral(red: 1, green: 0.2078431397676468, blue: 0.3490196168422699, alpha: 1)), location: 0.5104166865348816),
                                    .init(color: Color(#colorLiteral(red: 0.5583333373069763, green: 0, blue: 0.1675001084804535, alpha: 1)), location: 1)]),
                                startPoint: UnitPoint(x: 1.001960580351438, y: 0.4999984904828132),
                                endPoint: UnitPoint(x: 0.001960653828999348, y: 0.4999989975336838)).shadow(.inner(color: .white.opacity(0.3), radius: 0, x: 1, y: 3)))
                        
                            .padding(.leading, 4)
                            .frame(width: width, height: 16)
                    } else if currentPlayer == .player1 {
                        Capsule()
                            .fill(LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.21, green: 0.62, blue: 1), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.1, green: 0.46, blue: 1), location: 1.00)
                                ],
                                startPoint: UnitPoint(x: 1, y: 0.5),
                                endPoint: UnitPoint(x: 0, y: 0.5)
                            )
                                .shadow(.inner(color: .white.opacity(0.3), radius: 0, x: 1, y: 3)))
                            .padding(.leading, 4)
                            .frame(width: width, height: 16)
                    }
                } else {
                    if currentPlayer == .player1 {
                        Capsule()
                            .fill(LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color(#colorLiteral(red: 1, green: 0.45366665720939636, blue: 0.3791666626930237, alpha: 1)), location: 0),
                                    .init(color: Color(#colorLiteral(red: 1, green: 0.2078431397676468, blue: 0.3490196168422699, alpha: 1)), location: 0.5104166865348816),
                                    .init(color: Color(#colorLiteral(red: 0.5583333373069763, green: 0, blue: 0.1675001084804535, alpha: 1)), location: 1)]),
                                startPoint: UnitPoint(x: 1.001960580351438, y: 0.4999984904828132),
                                endPoint: UnitPoint(x: 0.001960653828999348, y: 0.4999989975336838)).shadow(.inner(color: .white.opacity(0.3), radius: 0, x: 1, y: 3)))
                            .padding(.leading, 4)
                            .frame(width: width, height: 16)
                    } else if currentPlayer == .player2 {
                        Capsule()
                            .fill(LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.21, green: 0.62, blue: 1), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.1, green: 0.46, blue: 1), location: 1.00)
                                ],
                                startPoint: UnitPoint(x: 1, y: 0.5),
                                endPoint: UnitPoint(x: 0, y: 0.5)
                            )
                                .shadow(.inner(color: .white.opacity(0.3), radius: 0, x: 1, y: 3)))
                            .padding(.leading, 4)
                            .frame(width: width, height: 16)
                    }
                }
                
            }
        }
        .frame(height: 25)
        .padding([.leading, .trailing], 18)
    }
}

struct TimeBarView_Previews: PreviewProvider {
    static var previews: some View {
        TimeBarView(remainingTime: 100, totalTime: 150, currentPlayer: .player1, curretlyPlaying: true, gameType: .multiplayer)
    }
}
