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
    @Binding var remainingTime: Int
    @EnvironmentObject var gameCenterManager: GameCenterManager
    @EnvironmentObject var board: Board
    let gameType: GameType
    let winner: CellState
    @Binding var currentPlayer: CellState
    @State private var degrees = 0.0
    @Binding var remainingHearts: Int
    @State private var nextLevel: Int = 0
    
    var onContinue: () -> Void
    
    var body: some View {
        ZStack {
//            Color.black.ignoresSafeArea()
//                .opacity(0.65)
            VStack {
                if UIScreen.main.bounds.height <= 667 {
                    HeartView(hearts: remainingHearts)
                        .padding(.top, 20)
                        .opacity(0)
                } else {
                    HeartView(hearts: remainingHearts)
                        .padding(.top, 70)
                        .opacity(0)
                }
                Spacer()
                if gameType == .ai {
                    VStack {
                        Image("pauseMenuBackground")
                            .padding(.top, -200)
                            .overlay {
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
                                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.44999998807907104)), radius: 16, x: 0, y: 10)
                                    
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
                                        LottieView2()
                                            .frame(width: 200, height: 200)
                                            .padding(.bottom, 30)
                                            .background {
                                                Image("winStar")
                                                    .offset(y: -20)
                                                    .allowsHitTesting(false)
                                            }
                                    } else if winner == .player2 {
                                        LottieView2(lottieFile: "Red guy fail")
                                            .frame(width: 200, height: 200)
                                            .padding(.bottom, 30)
                                            .background {
                                                Image("winStar")
                                                    .offset(y: -20)
                                                    .allowsHitTesting(false)
                                            }
                                    } else if winner == .draw {
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
                                    if winner == .player1 {
                                        Image( "Winner")
                                            .offset(y: -135)
                                            .allowsHitTesting(false)
                                    } else if winner == .player2 {
                                        Image( "ohLost")
                                            .offset(y: -135)
                                            .allowsHitTesting(false)
                                    } else {
                                        Image("draw")
                                            .offset(y: -135)
                                            .allowsHitTesting(false)
                                    }
                                    VStack {
                                        HStack {
                                            
                                            Button {
                                                onContinue()
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    gameCenterManager.path = NavigationPath()
                                                }
                                                print("Current level: ", gameCenterManager.currentLevel.id)
                                                print("Achieved level: ", gameCenterManager.achievedLevel.id)
                                            } label: {
                                                RoundedRectangle(cornerRadius: 14)
                                                    .foregroundColor(Color("AnotherPause"))
                                                    .overlay {
                                                        Image("iconMap")
                                                    }
                                                    .frame(width: 94.5, height: 42)
                                            }
                                            if remainingHearts > 0 {
                                                Button {
                                                    onContinue()
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                        withAnimation {
                                                            board.reset()
                                                            isPaused.toggle()
                                                            currentPlayer = .player1
                                                            remainingTime = 15
                                                        }
                                                    }
                                                } label: {
                                                    RoundedRectangle(cornerRadius: 14)
                                                        .foregroundColor(Color("AnotherPause"))
                                                        .overlay {
                                                            Image("iconReplay")
                                                        }
                                                        .frame(width: 94.5, height: 42)
                                                }
                                            }
                                            
                                        }
                                        .offset(y: 80)
                                    }
                                    
                                    if winner == .player1 {
                                        //MARK: - Definitely fix this!!!!
                                        if gameCenterManager.currentLevel.id < 22 {
//                                            if let size = gameCenterManager.currentLevel.next?.boardSize {
//                                                if let obstacles = gameCenterManager.currentLevel.next?.obstacles {
//                                                    NextLevelNavigation(boardSize: size, obstacles: obstacles, onContinue: onContinue)
//                                                        .offset(y: 130)
//                                                }
//                                            }
                                            let size = gameCenterManager.currentLevel.boardSize
                                            let obstacles = gameCenterManager.currentLevel.obstacles
                                            NextLevelNavigation(boardSize: size, obstacles: obstacles, onContinue: onContinue)
                                                .offset(y: 130)
                                        }
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
                    .offset(y: -30)
                    Spacer()
                } else {
                    VStack {
                        Image("pauseMenuBackground")
                            .padding(.top, -200)
                            .overlay {
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
                                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.44999998807907104)), radius: 16, x: 0, y: 10)
                                    
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
                                        LottieView2()
                                            .frame(width: 250, height: 250)
                                            .padding(.bottom, 30)
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
                                    } else if winner == .draw {
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
                                    
                                    if gameType == .multiplayer {
                                        Button {
                                            onContinue()
//                                            self.showWinMenu.toggle()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                gameCenterManager.path = NavigationPath()
                                            }
                                        } label: {
                                            RoundedRectangle(cornerRadius: 14)
                                                .foregroundColor(Color("AnotherPause"))
                                                .overlay {
                                                    Image("iconHome")
                                                }
                                                .frame(width: 94.5, height: 42)
                                        }
                                        .offset(y: 80)
                                        
                                    } else {
                                        VStack {
                                            Spacer()
                                            Spacer()
                                            HStack {
                                                
                                                Button {
                                                    onContinue()
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                        withAnimation {
                                                            board.reset()
                                                            isPaused.toggle()
                                                            currentPlayer = .player1
                                                            remainingTime = 15
                                                        }
                                                    }

                                                } label: {
                                                    RoundedRectangle(cornerRadius: 14)
                                                        .foregroundColor(Color("AnotherPause"))
                                                        .overlay {
                                                            Image("iconReplay")
                                                        }
                                                        .frame(width: 94.5, height: 42)
                                                }
                                                
                                                
                                                Button {
                                                    onContinue()
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                        gameCenterManager.path = NavigationPath()
                                                    }
                                                    
                                                } label: {
                                                    RoundedRectangle(cornerRadius: 14)
                                                        .foregroundColor(Color("AnotherPause"))
                                                        .overlay {
                                                            Image("iconHome")
                                                        }
                                                        .frame(width: 94.5, height: 42)
                                                }
                                            }
                                            .offset(y: 20)
                                            Spacer()
                                        }
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
                    Spacer()
                }
                
            }
            
        }
    }
    
}




struct NextLevelNavigation: View {
    @EnvironmentObject var gameCenterController: GameCenterManager
    @State private var navigateToGame = false
    
    @EnvironmentObject var appLanguageManager: AppLanguageManager

    
    var continueButton: String {
        appLanguageManager.localizedStringForKey("CONTINUE", language: appLanguageManager.currentLanguage)
    }
    
    
    let boardSize: (rows: Int, cols: Int)
    let obstacles: [(Int, Int)]
    var onContinue: () -> Void
    var body: some View {
        NavigationLink(destination: GameView(gameType: .ai, gameSize: (row: boardSize.rows, col: boardSize.cols), obstacles: obstacles), isActive: $navigateToGame) {
            EmptyView()
        }
        .hidden()
        Button {
            onContinue()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                navigateToGame = true
            }
        } label: {
            HStack{
                Text(continueButton)
                    .font(Font.custom("TempleGemsRegular", size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.83, green: 0.85, blue: 1))
                    .frame(width: 122, height: 22, alignment: .center)
            }
            .frame(width: 199, height: 42)
            .background(Color(red: 0.48, green: 0.4, blue: 0.98))
            .cornerRadius(14)
        }
        .simultaneousGesture(TapGesture().onEnded({
                    gameCenterController.isPaused.toggle()
                    gameCenterController.isQuitGame = false
                    gameCenterController.isGameOver = false
                }))

//        NavigationLink {
//            withAnimation(.easeInOut(duration: 0.5)) {
//                GameView(gameType: .ai, gameSize: (row: boardSize.rows, col: boardSize.cols), obstacles: obstacles)
//            }
//        } label: {
//            HStack{
//                Text("Continue")
//                    .font(Font.custom("TempleGemsRegular", size: 24))
//                    .multilineTextAlignment(.center)
//                    .foregroundColor(Color(red: 0.83, green: 0.85, blue: 1))
//                    .frame(width: 122, height: 22, alignment: .center)
//            }
//            .frame(width: 199, height: 42)
//            .background(Color(red: 0.48, green: 0.4, blue: 0.98))
//            .cornerRadius(14)
//        }
//        .simultaneousGesture(TapGesture().onEnded({
//            gameCenterController.isPaused.toggle()
//            gameCenterController.isQuitGame = false
//            gameCenterController.isGameOver = false
//
//        }))
    }
}

struct WinView_Previews: PreviewProvider {
    static var previews: some View {
        @State var check = true
        @State var player: CellState = .player1
        @State var paused: Bool = true
        @State var remainingTime = 15
        @State var remainingHearts = 5
        WinView(showWinMenu: $check, isPaused: $paused, remainingTime: $remainingTime, gameType: .ai, winner: .player1, currentPlayer: $player, remainingHearts: $remainingHearts, onContinue: {}).environmentObject(GameCenterManager(currentPlayer: .player1))
    }
}
