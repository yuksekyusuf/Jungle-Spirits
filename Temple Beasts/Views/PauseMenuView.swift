//
//  PauseMenuView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/21/23.
//

import SwiftUI

struct PauseMenuView: View {
    
    @Binding var showPauseMenu: Bool
    @Binding var isPaused: Bool
    @Binding var remainingTime: Int
//    @State private var isMusicOn: Bool = false
    @State private var soundState: Bool = UserDefaults.standard.bool(forKey: "sound")
    @AppStorage("music") private var musicState: Bool = false
    @EnvironmentObject var menuViewModel: MenuViewModel
    @EnvironmentObject var board: Board
    @Binding var currentPlayer: CellState
    
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
                            
                            Image("pauseMenuPieces")
                                .offset(y: -122)
                            VStack {
                                Spacer()
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color("AnotherPause"))
                                    .frame(width: 201, height: 89)
                                    .padding(.top, 40)
                                    .overlay{
                                        HStack {
                                            VStack(spacing: 5) {
                                                Image("Note")
                                                
                                                Image("iconSound")
                                                
                                            }
                                            VStack(spacing: 12) {
                                                Text("MUSIC")
                                                    .font(Font.custom("Watermelon-Regular", size: 24))
                                                    .foregroundColor(Color(#colorLiteral(red: 0.83, green: 0.85, blue: 1, alpha: 1)))
                                                Text("SOUND")
                                                    .font(Font.custom("Watermelon-Regular", size: 24))
                                                    .foregroundColor(Color(#colorLiteral(red: 0.83, green: 0.85, blue: 1, alpha: 1)))
                                            }
                                            
                                            VStack(spacing: 5) {
                                                Toggle(isOn: $musicState) {
                                                    Text("")
                                                }
                                                .toggleStyle(CustomToggleView())
                                                .onChange(of: musicState) { newValue in
                                                    UserDefaults.standard.set(newValue, forKey: "music")
                                                    if newValue {
                                                        SoundManager.shared.playBackgroundMusic()
                                                    } else {
                                                        SoundManager.shared.stopBackgroundMusic()
                                                    }
                                                }
                                                
                                                Toggle(isOn: $soundState) {
                                                    Text("")
                                                }
                                                .toggleStyle(CustomToggleView())
                                                .onChange(of: soundState, perform: { newValue in
                                                    UserDefaults.standard.set(newValue, forKey: "sound")
                                                })
                                            }
                                        }
                                        .padding(.top, 40)
                                    }
                                Spacer()
                                HStack {
                                    Button {
                                        board.reset()
                                        showPauseMenu.toggle()
                                        isPaused.toggle()
                                        currentPlayer = .player1
                                        remainingTime = 15
                                    } label: {
                                        PauseMenuIconView(imageName: "iconReplay")
                                        
                                    }
                                    
                                    Button {
                                        showPauseMenu.toggle()
                                        isPaused.toggle()
                                    } label: {
                                        PauseMenuIconView(imageName: "iconResume")
                                        
                                    }
                                    Button {
                                        menuViewModel.path.removeAll()
                                    } label: {
                                        PauseMenuIconView(imageName: "iconHome")
                                    }
                                }
                                .padding(.bottom, 20)
                                Spacer()
                                
                            }
                        }
                    }
            }
        }
//        .onAppear {
//            SoundManager.shared.startPlayingIfNeeded()
//        }
        
    }
}


struct PauseMenuView_Previews: PreviewProvider {
    static var previews: some View {
        @State var check = true
        @State var show = true
        @State var player: CellState = .player1
        @State var remainingTime: Int = 15
        PauseMenuView(showPauseMenu: $check, isPaused: $show, remainingTime: $remainingTime, currentPlayer: $player)
    }
}


