//
//  WinView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 1.07.2023.
//

import SwiftUI

struct WinView: View {
    
    @Binding var showWinMenu: Bool
    @Binding var isPaused: Bool
    @EnvironmentObject var menuViewModel: MenuViewModel
    @EnvironmentObject var board: Board
    let winner: CellState
    @Binding var currentPlayer: CellState
    @State private var degrees = 0.0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                .opacity(0.65)
            VStack {
                Image("pauseMenuBackground")
                    .padding(.top, -200)
                    .overlay{
                        ZStack {
                            RoundedRectangle(cornerRadius: 46)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: Color(#colorLiteral(red: 0.7333333492279053, green: 0.7614035606384277, blue: 1, alpha: 1)), location: 0),
                                            .init(color: Color(#colorLiteral(red: 0.5364739298820496, green: 0.4752604365348816, blue: 0.9125000238418579, alpha: 1)), location: 1)]),
                                        startPoint: UnitPoint(x: 0.9999999999999999, y: 0),
                                        endPoint: UnitPoint(x: 2.980232305382913e-8, y: 1.0000000310465447))
                                )
                                .frame(width: 271, height: 258)
                                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.44999998807907104)), radius:16, x:0, y:10)
                            
                            Image("pausemenubackground1")
                                .frame(width: 240, height: 240)
                            Image(uiImage: #imageLiteral(resourceName: "pauseMenuPattern"))
                                .resizable()
                                .frame(width: 240, height: 240)
                                .clipped()
                                .blendMode(.overlay)
                                .frame(width: 240, height: 240)
                                .cornerRadius(44)
                            
                            
                            if winner == .player1 {
                                Image("redWinner")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 138, height: 138)
                                    .padding(.bottom, 20)
                                    .background {
                                        Image("winStar")
                                            .offset(y: -20)
                                            .allowsHitTesting(false)
                                    }
                            } else if winner == .player2 {
                                Image("blueWinner")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 138, height: 138)
                                    .padding(.bottom, 20)
                                    .background {
                                        Image("winStar")
                                            .offset(y: -20)
                                            .allowsHitTesting(false)
                                    }
                            } else {
                                Image("drawFaces")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 266.01456, height: 169.01501)
                                    .padding(.bottom, 20)
                                    .background {
                                        Image("winStar")
                                            .offset(y: -20)
                                            .allowsHitTesting(false)
                                    }
                            }
                            
                            
                            Image((winner == .player1 || winner == .player2) ? "Winner" : "draw")
                                .offset(y: -135)
                                .allowsHitTesting(false)
                            
                            
                            VStack {
                                Spacer()
                                Spacer()
                                HStack {
                                    Button {
                                        board.reset()
                                        showWinMenu.toggle()
                                        isPaused.toggle()
                                        currentPlayer = .player1
                                    } label: {
                                        RoundedRectangle(cornerRadius: 14)
                                            .foregroundColor(Color("AnotherPause"))
                                            .overlay{
                                                Image("iconReplay")
                                            }
                                            .frame(width: 94.5, height: 42)
                                        
                                        
                                    }
                                    Button {
                                        menuViewModel.path.removeAll()
                                    } label: {
                                        RoundedRectangle(cornerRadius: 14)
                                            .foregroundColor(Color("AnotherPause"))
                                            .overlay{
                                                Image("iconHome")
                                            }
                                            .frame(width: 94.5, height: 42)
                                        
                                    }
                                    
                                }
                                .offset(y: 20)
                                Spacer()
                            }
                            
                            Image("winLights")
                                .resizable()
                                .frame(width: 400, height: 400)
                                .blendMode(.overlay)
                                .allowsHitTesting(false)
                                .rotationEffect(.degrees(degrees))
                                
                        }
                        .onAppear {
                            let baseAnimation = Animation.linear(duration: 15).repeatForever()
                            withAnimation(baseAnimation) {
                                self.degrees += 360
                            }
                        }
                    }
            }
        }

    }
}

struct WinView_Previews: PreviewProvider {
    static var previews: some View {
        @State var check = true
        @State var player: CellState = .player1
        @State var paused: Bool = true
        WinView(showWinMenu: $check, isPaused: $paused, winner: .empty, currentPlayer: $player)
    }
}
