//
//  MenuView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/21/23.
//

import SwiftUI
import StoreKit




struct MenuView: View {
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var appLanguageManager: AppLanguageManager

    
    @StateObject var gameCenterController: GameCenterManager = GameCenterManager(currentPlayer: .player1)
    @State private var isMatchmakingPresented = false
    @State var gameType: GameType?
    @AppStorage("music") var musicState: Bool = true
    @AppStorage("haptic") var hapticState: Bool = true
    @AppStorage("sound") var soundState: Bool = true
    @State private var hasUserBeenPromptedForReview: Bool = UserDefaults.standard.bool(forKey: "HasUserBeenPromptedForReview")
    
//    @State private var remainingHearts: Int = UserDefaults.standard.integer(forKey: "hearts")
    
    @AppStorage("hearts") var remainingHearts: Int?
    
    @State private var selectedLanguage: String = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
    @State private var currentLanguageIndex: Int = 0
    @State private var showMatchmakingPopup = false
    
    @Namespace private var animationNamespace
    @State private var showCreditScreen: Bool = false
    
    //Timer functionality
    
//    @AppStorage("lastBackgroundTime") var lastBackgroundTime: TimeInterval = 0
//    // To periodically check for heart updates
//    @State var heartTimer: Timer?

    let availableLanguages = ["en", "tr", "de", "fr", "es"]
    let languageNames = ["English", "Türkçe", "Deutsch", "Français", "Español"]

    
    var versusAI: String {
        localizedStringForKey("VERSUS_AI", language: appLanguageManager.currentLanguage)
    }
    
    var localDuel: String {
        localizedStringForKey("LOCAL_DUEL", language: appLanguageManager.currentLanguage)
    }
    
    var onlineBattle: String {
        localizedStringForKey("ONLINE_BATTLE", language: appLanguageManager.currentLanguage)
    }
    
    
    let buttonWidth = UIScreen.main.bounds.width * 0.8
    let singleButtonWidth = UIScreen.main.bounds.width * 0.40
    let smallButtonWidth = UIScreen.main.bounds.width * 0.16
    
    var body: some View {
        NavigationStack(path: $gameCenterController.path) {
            if UserDefaults.standard.howToPlayShown {
                ZStack {
                    Image("Menu Screen")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    VStack(spacing: 0) {
                        HStack {
                            Button {
                                if hasUserBeenPromptedForReview {
                                   
                                    withAnimation(.spring()) {
                                        self.showCreditScreen.toggle()

                                    }
//                                    withAnimation{
//                                        self.showCreditScreen.toggle()
//
//                                    }

                                    
                                
                                } else {
                                    requestReview()
                                    UserDefaults.standard.set(true, forKey: "HasUserBeenPromptedForReview")
                                    hasUserBeenPromptedForReview = true
                                }
                                
                            } label: {
                                Image("like")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                    .padding(.leading, 20)
                            }
                            .onAppear {
                                print("review is present", hasUserBeenPromptedForReview)
                            }
                            Spacer()
                            if let remainingHearts = remainingHearts {
                                if remainingHearts > 0 {
                                    ZStack {
                                        Image(systemName: "heart.fill")
                                            .resizable()
                                            .foregroundColor(.red)
                                            .frame(width: 32, height: 32)
                                        Text("\(remainingHearts)")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                    }
                                }
                                else {
                                    Image(systemName: "heart")
                                        .resizable()
                                        .foregroundColor(.red)
                                        .frame(width: 32, height: 32)
                                }
                            }
                            
                            Spacer()
                            NavigationLink {
                                HowToPlayView()
                            } label: {
                                Image("info")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                    .padding(.trailing, 20)
                            }
                            .simultaneousGesture(
                                TapGesture()
                                    .onEnded({gameCenterController.path.append(1)})
                            )
                            
                        }
                        .padding(.top, 70)
                        Spacer()
                        //                        Image("menuLogo")
                        //                            .resizable()
                        //                            .scaledToFit()
                        //                            .frame(width: UIScreen.main.bounds.width * 0.8)
                        //                            .offset(y: -110)
                        
                        
                        LottieView(animationName: "logo", ifActive: false, contentMode: true, isLoop: true)
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                            .offset(y: -90)
                            .allowsHitTesting(false)
                        
                        Spacer()
                        VStack(alignment: .leading) {
                            HStack {
                                Spacer()
//                                NavigationLink {
//                                    GameView(gameType: .ai, gameSize: (8, 5))
//                                } label: {
//                                    ButtonView(text: versusAI, width: singleButtonWidth, height: 50)
//                                }
//                                .simultaneousGesture(TapGesture().onEnded({
//                                        gameCenterController.path.append(2)
//
//                                }))
                                if let remainingHearts = remainingHearts {
                                    NavigationLink(destination: GameView(gameType: .ai, gameSize: (4, 4)), isActive: remainingHearts > 0 ? .constant(true) : .constant(false)) {
                                        ButtonView(text: versusAI, width: singleButtonWidth, height: 50)
                                    }
                                    .opacity(remainingHearts > 0 ? 1.0 : 0.5) // Optionally make the button appear semi-transparent when disabled
                                    .disabled(remainingHearts <= 0)
                                    .simultaneousGesture(TapGesture().onEnded({
                                        if remainingHearts > 0 {
                                            gameCenterController.path.append(2)
                                        }
                                    }))
                                }
                                
                                
                                // 1 vs 1
                                NavigationLink {
                                    GameView(gameType: .oneVone, gameSize: (4, 4))
                                } label: {
                                    //                                    Image("1 vs 1")
                                    //                                        .resizable()
                                    //                                        .scaledToFit()
                                    //                                        .frame(width: singleButtonWidth)
                                    ButtonView(text: localDuel, width: singleButtonWidth, height: 50)
                                }
                                .simultaneousGesture(TapGesture().onEnded({
                                    gameCenterController.path.append(3)
                                }))
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                ZStack {
                                    NavigationLink(destination: GameView(gameType: .multiplayer, gameSize: (4, 4)), isActive: $gameCenterController.isMatched) {
                                        EmptyView()
                                    }
                                    Button {
                                        self.isMatchmakingPresented = true
                                    } label: {
    
                                        ButtonView(text: onlineBattle, width: buttonWidth, height: 50)
                                    }
                                    .sheet(isPresented: $isMatchmakingPresented) {
                                        GameCenterView().environmentObject(gameCenterController)
                                    }
                                    
//                                    Button(action: {
//                                        print("Is matched? ", gameCenterController.isMatchFound)
//                                        self.showMatchmakingPopup = true
//                                        gameCenterController.startQuickMatch()
//
//                                    }) {
//                                        ButtonView(text: onlineBattle, width: buttonWidth, height: 50)
//                                    }
//
//                                    NavigationLink(
//                                        destination: GameView(gameType: .multiplayer, gameSize: (8, 5)),
//                                        isActive: $gameCenterController.isMatchFound
//                                    ) {
//                                        EmptyView()
//                                    }
    //
                                }
                                .padding(.top, 10)
                                Spacer()
                            }
                            
                            
                            HStack(spacing: 0) {
                                Spacer()
                                ButtonView(text: nil, width: smallButtonWidth, height: 50)
                                    .overlay{
                                        Image(soundState ? "soundOn" : "soundOff")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 32)
                                    }
                                    .onTapGesture {
                                        soundState.toggle()
                                        UserDefaults.standard.set(soundState, forKey: "sound")
                                    }
                                ButtonView(text: nil, width: smallButtonWidth, height: 50)
                                    .overlay{
                                        Image(musicState ? "musicOn" : "musicOff" )
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 32)
                                    }
                                    .padding(.trailing, 16)
                                    .padding(.leading, 16)
                                    .onTapGesture {
                                        musicState.toggle()
                                        UserDefaults.standard.set(musicState, forKey: "music")
                                        if musicState {
                                            SoundManager.shared.playBackgroundMusic()
                                        } else {
                                            SoundManager.shared.stopBackgroundMusic()
                                        }
                                    }
                                
                                ButtonView(text: nil, width: smallButtonWidth, height: 50)
                                    .overlay {
                                        Image(hapticState ? "vibrationOn" : "vibrationOff")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 32)
                                    }
                                    .padding(.trailing, 16)
                                    .onTapGesture {
                                        hapticState.toggle()
                                        UserDefaults.standard.set(hapticState, forKey: "haptic")
                                        if hapticState {
                                            HapticManager.shared.notification(type: .error)
                                        }
                                    }
                                ButtonView(text: nil, width: smallButtonWidth, height: 50)
                                    .overlay {
                                        Image("Language")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 32)
                                    }
                                    .onTapGesture {
                                        currentLanguageIndex += 1
                                            if currentLanguageIndex >= availableLanguages.count {
                                                currentLanguageIndex = 0
                                            }
                                            let newLanguage = availableLanguages[currentLanguageIndex]
                                            appLanguageManager.setLanguage(newLanguage)
                                    }
                                Spacer()
                                
                            }
                            .padding(.top, 16)
                        }
                        .id(appLanguageManager.id)
                        .padding(.bottom, 90)
                    }
                    LottieView(animationName: "particles", ifActive: false, contentMode: true, isLoop: true)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .edgesIgnoringSafeArea(.all)
                        .allowsHitTesting(false)
                    
                    if showMatchmakingPopup {
                        MatchmakingPopupView(isSearching: $gameCenterController.isSearchingForMatch)
                                .background(Color.black.opacity(0.4)) // Optional: for darkening background
                                .onTapGesture {
                                    self.showMatchmakingPopup = false
                                }
                                .edgesIgnoringSafeArea(.all)
                    }
                    
//                    if showCreditScreen {
//                        CreditView(isPresent: $showCreditScreen)
//                            .scaleEffect(showCreditScreen ? 1 : 0.1)
//                            .animation(.easeInOut(duration: 0.3), value: showCreditScreen)
//
//                    }
                    if showCreditScreen {
                                    Color.black.opacity(0.8)
                                        .ignoresSafeArea()
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 0.1)) {
                                                showCreditScreen = false
                                            }
                                        }
                                }
                                
                                CreditView(isPresent: $showCreditScreen)
                                    .scaleEffect(showCreditScreen ? 1 : 0)
                                    .allowsHitTesting(showCreditScreen)
                                    .animation(showCreditScreen ? .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0) : .linear(duration: 0.001), value: showCreditScreen)
//                                    .animation(.spring(), value: showCreditScreen)
                                
                    

                }
                .ignoresSafeArea()
            } else {
                HowToPlayView()
                //                    .onAppear{
                //                        gameCenterController.path.append(20)
                //                    }
            }
        }
        .onAppear {
//            startHeartTimer()
            print("Initial remaining hearts: ", remainingHearts)
            UserDefaults.standard.set(soundState, forKey: "sound")
            UserDefaults.standard.set(musicState, forKey: "music")
            UserDefaults.standard.set(hapticState, forKey: "haptic")
            currentLanguageIndex = availableLanguages.firstIndex(of: selectedLanguage) ?? 0
            SoundManager.shared.startPlayingIfNeeded()
            if !gameCenterController.isUserAuthenticated {
                    gameCenterController.onAuthenticated = {
                        self.gameCenterController.fetchLocalPlayerImage()
                    }
                    gameCenterController.authenticateUser()
                } else {
                    gameCenterController.fetchLocalPlayerImage()
                }
            if remainingHearts == nil {
                remainingHearts = 5
                UserDefaults.standard.set(remainingHearts, forKey: "hearts")
                print("Hearts when menu appears: ", remainingHearts)

            }
        }
        .onChange(of: gameCenterController.isMatchFound) { matchFound in
            if matchFound {
                // Here, you could update the MatchmakingPopupView to show the remote player's details
                // But for simplicity, we'll dismiss the popup and navigate to the game after a delay:

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // 1 second delay
                    self.showMatchmakingPopup = false
//                    gameCenterController.isMatched = true
                }
            }
        }
//        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
//            // App going to background
//            self.lastBackgroundTime = Date().timeIntervalSinceReferenceDate
//        }
//        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
//            // App coming to foreground
//            self.updateHeartsBasedOnTimeElapsed()
//        }
        .environmentObject(gameCenterController)
//        .onDisappear() {
//            heartTimer?.invalidate()
//        }
        
    }
    
//    func updateHeartsBasedOnTimeElapsed() {
//        let lastTime = Date(timeIntervalSinceReferenceDate: lastBackgroundTime)
//        let elapsedTime = Date().timeIntervalSince(lastTime)
//
//        let heartIntervals = Int(elapsedTime / 10)
//
//        if heartIntervals > 0 {
//            if let hearts = remainingHearts {
//                remainingHearts = min(hearts + heartIntervals, 5)
//            }
//            startHeartTimer()
//        }
//    }
    
//    func startHeartTimer() {
//        heartTimer?.invalidate()
//        updateHeartsBasedOnTimeElapsed()
//        heartTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
//            if remainingHearts ?? 0 < 5 {
//                let newHeart = remainingHearts ?? 0 + 1
//                UserDefaults.standard.set(newHeart, forKey: "hearts")
//            }
//        }
//    }
    
    func localizedStringForKey(_ key: String, language: String) -> String {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView().environmentObject(AppLanguageManager())
    }
}
