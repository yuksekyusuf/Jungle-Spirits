//
//  MenuView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/21/23.
//

import SwiftUI
import StoreKit
import Pow
import GoogleMobileAds




struct MenuView: View {
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var appLanguageManager: AppLanguageManager
    @EnvironmentObject var gameCenterController: GameCenterManager
    @EnvironmentObject var heartManager: HeartManager
    
    @State private var selectedMap = 1
    let numberOfMaps = 3
    
    @State private var showResetGameAlert = false

    
    @State private var isMatchmakingPresented = false
    @State var gameType: GameType?
    @AppStorage("music") var musicState: Bool = true
    @AppStorage("haptic") var hapticState: Bool = true
    @AppStorage("sound") var soundState: Bool = true
    
    
    @State var showStory: Bool = false
    @State private var isBackgroundShown: Bool = false
    
//    @State private var isFirstLaunch: Bool

    @State private var videoPlayerOpacity = 1.0

    
    @State private var isJungleButtonTapped = false
    @State private var hasUserBeenPromptedForReview: Bool = UserDefaults.standard.bool(forKey: "HasUserBeenPromptedForReview")
    
    //    @State private var remainingHearts: Int = UserDefaults.standard.integer(forKey: "hearts")
    
//    @AppStorage("hearts") var remainingHearts: Int?
    
    @State private var selectedLanguage: String = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
    @State private var currentLanguageIndex: Int = 0
    @State private var showMatchmakingPopup = false
    
    @Namespace private var animationNamespace
    @State private var showCreditScreen: Bool = false
    @State private var showLevelMap: Bool = false
    @State private var showHeartAlert: Bool = false
    @State private var remainingTime: String = ""
    
    @State private var showVideoPlayer = false
//    @State private var showFirstMapOne = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
//    @State private var showFirstMapTwo = false
//    @State private var showFirstMapThree = false
//    @State private var showFirstMapFour = false


    
    //Timer functionality
    
    //    @AppStorage("lastBackgroundTime") var lastBackgroundTime: TimeInterval = 0
    //    // To periodically check for heart updates
    //    @State var heartTimer: Timer?
    
    let availableLanguages = ["en", "tr", "de", "fr", "es", "zh-Hans"]
//    let languageNames = ["English", "Türkçe", "Deutsch", "Français", "Español", "Chinese"]
    
    
    var versusAI: String {
        appLanguageManager.localizedStringForKey("VERSUS_AI", language: appLanguageManager.currentLanguage)
    }
    
    var localDuel: String {
        appLanguageManager.localizedStringForKey("LOCAL_DUEL", language: appLanguageManager.currentLanguage)
    }
    
    var onlineBattle: String {
        appLanguageManager.localizedStringForKey("ONLINE_BATTLE", language: appLanguageManager.currentLanguage)
    }
    
    var howToPlay: String {
        appLanguageManager.localizedStringForKey("HOW_TO_PLAY", language: appLanguageManager.currentLanguage)

    }

    var rateUs: String {
        appLanguageManager.localizedStringForKey("RATE_US", language: appLanguageManager.currentLanguage)

    }
    
    var resetGame: String {
        appLanguageManager.localizedStringForKey("RESET_GAME", language: appLanguageManager.currentLanguage)

    }
    
    var onlyIf: String {
        appLanguageManager.localizedStringForKey("ONLY_IF", language: appLanguageManager.currentLanguage)

    }
    

    var findMaps: String {
        appLanguageManager.localizedStringForKey("FIND_MAPS", language: appLanguageManager.currentLanguage)

    }
    var beContinued: String {
        appLanguageManager.localizedStringForKey("BE_CONTINUED", language: appLanguageManager.currentLanguage)

    }
    
    
    var gettingHot: String {
        appLanguageManager.localizedStringForKey("GETTING_HOT", language: appLanguageManager.currentLanguage)

    }
    
    var crossRiver: String {
        appLanguageManager.localizedStringForKey("CROSS_RIVER", language: appLanguageManager.currentLanguage)

    }
    
    
    var intoValley: String {
        appLanguageManager.localizedStringForKey("INTO_VALLEY", language: appLanguageManager.currentLanguage)

    }
    
    
    var areYouSure: String {
        appLanguageManager.localizedStringForKey("YOU_SURE", language: appLanguageManager.currentLanguage)

    }
    
    var loseProgress: String {
        appLanguageManager.localizedStringForKey("LOSE_PROGRESS", language: appLanguageManager.currentLanguage)

    }
    
    var cancel: String {
        appLanguageManager.localizedStringForKey("CANCEL", language: appLanguageManager.currentLanguage)

    }
    var resetGame2: String {
        appLanguageManager.localizedStringForKey("RESET_GAME_2", language: appLanguageManager.currentLanguage)
    }
    

    let buttonWidth = UIScreen.main.bounds.width * 0.8
    let singleButtonWidth = UIScreen.main.bounds.width * 0.40
    let smallButtonWidth = UIScreen.main.bounds.width * 0.18
    
    var body: some View {
        NavigationStack(path: $gameCenterController.path) {
            ZStack {
                Color.black.ignoresSafeArea()

                if isBackgroundShown {
                    Image("Menu Screen")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.movingParts.iris(blurRadius: 10))

                    if showLevelMap {
                        Image("mapsTabBackground")
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }  
                VStack(spacing: 0) {
                    VStack {
                        HStack {
                            //                                Spacer()
                            if showLevelMap {
                                Button {
                                    withAnimation {
                                        showLevelMap.toggle()
                                    }
                                } label: {
                                    Image("Left Arrow")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 50)
                                        .padding(.trailing, 20)
                                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                                        .padding(.leading, 10)
                                    
                                }
                            } else {
                                Button {
                                    showCreditScreen.toggle()
                                } label: {
                                    Image("info")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 50)
                                        .padding(.trailing, 20)
                                        .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 4)
                                }
                                .padding(.leading, 10)
                            }
                            
                            
                            Spacer()
                            //                                if let remainingHearts = remainingHearts {
                            //                                    if remainingHearts > 0 {
                            //                                        ZStack {
                            //                                            Image(systemName: "heart.fill")
                            //                                                .resizable()
                            //                                                .foregroundColor(.red)
                            //                                                .frame(width: 32, height: 32)
                            //                                            Text("\(remainingHearts)")
                            //                                                .foregroundColor(.white)
                            //                                                .font(.headline)
                            //                                        }
                            //                                    }
                            //                                    else {
                            //                                        Image(systemName: "heart")
                            //                                            .resizable()
                            //                                            .foregroundColor(.red)
                            //                                            .frame(width: 32, height: 32)
                            //                                    }
                            //                                }
                            
                            
                                Button {
                                    showHeartAlert.toggle()
                                } label: {
                                    HeartView()
                                        .padding(.trailing, 20)
                                }
                            
                            //                                Button {
                            ////                                    if hasUserBeenPromptedForReview {
                            ////                                        withAnimation(.spring()) {
                            ////                                            self.showCreditScreen.toggle()
                            ////
                            ////                                        }
                            ////                                    } else {
                            ////                                        requestReview()
                            ////                                        UserDefaults.standard.set(true, forKey: "HasUserBeenPromptedForReview")
                            ////                                        hasUserBeenPromptedForReview = true
                            ////                                    }
                            //
                            //                                } label: {
                            //                                    Image("like")
                            //                                        .resizable()
                            //                                        .scaledToFit()
                            //                                        .frame(height: 50)
                            //                                        .padding(.leading, 20)
                            //                                }
                            //                                .onAppear {
                            //                                    print("review is present", hasUserBeenPromptedForReview)
                            //                                }
                            //                                Spacer()
                            
                            
                        }
                        .padding(.top, 70)
                        
                    }
                    if showLevelMap {
                        Spacer()
                        VStack {
                            VStack{
                                ZStack {
                                    
                                    ZStack {
                                        Image("ContinueImage")
                                            .resizable()
                                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.5)
                                            .scaledToFit()
                                            .offset(y: 25)
                                        
                                        if selectedMap == 4 {
                                            VStack(spacing: 0) {
                                                Text(onlyIf.capitalizedSentence)
                                                    .font(.custom("TempleGemsRegular", size: 24))
                                                    .foregroundColor(.white)
                                                    .stroke(color: .black, width: 1.0)
                                                    .shadow(color: .black, radius: 0, x: 0, y: 3)
                                                Text(findMaps.capitalizedSentence)
                                                    .font(.custom("TempleGemsRegular", size: 22))
                                                    .foregroundColor(Color(#colorLiteral(red: 0.63, green: 0.64, blue: 1, alpha: 1)))
                                                    .tracking(0.72)
                                                    .multilineTextAlignment(.center)
                                                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:0, x:0, y:1)
                                                    .padding(.bottom, 30)
//                                                Spacer()
                                            }
                                            .padding(.top, UIScreen.main.bounds.height * 0.3)
                                        }
                                        
                                        
                                    }
                                    
                                    
                                    
                                    TabView(selection: $selectedMap) {
                                        VStack {
                                            MapItemName(id: "1. ", title: intoValley)
                                            MapsTabView(mapNumber: 1, levelBundle: GameLevelBundle.bundle1, heartStatus: $showHeartAlert)
                                        }
                                        .tag(1)
                                        .padding(.bottom, 30)
                                        VStack {
                                            MapItemName(id: "2. ", title: crossRiver)
                                            MapsTabView(mapNumber: 2, levelBundle: GameLevelBundle.bundle2, heartStatus: $showHeartAlert)
                                            
                                        }
                                        .tag(2)
                                        .padding(.bottom, 30)
                                        
                                        VStack {
                                            MapItemName(id: "3. ", title: gettingHot)
                                            MapsTabView(mapNumber: 3, levelBundle: GameLevelBundle.bundle3,  heartStatus: $showHeartAlert)
                                            
                                        }
                                        .tag(3)
                                        .padding(.bottom, 30)
                                        VStack {
                                            MapItemName(id: "", title: beContinued)
                                            MapsTabView(mapNumber: 4, levelBundle: GameLevelBundle.bundle3,  heartStatus: $showHeartAlert)
                                                .opacity(0)
                                            
                                        }
                                        .tag(4)
                                        .padding(.bottom, 30)
                                    }
                                    .onChange(of: selectedMap) { _ in
                                        HapticManager.shared.impact(style: .soft)
                                    }
                                    .tabViewStyle(.page(indexDisplayMode: .never))
                                    
                                }
                                
                                
                                HStack {
                                    ForEach(1...(numberOfMaps+1), id: \.self) { index in
                                        if selectedMap == index {
                                            Image("SelectedTabAsset")
                                                .resizable()
                                                .frame(width: 32, height: 32)
                                                .onTapGesture {
                                                    withAnimation(.easeInOut(duration: 0.5)) {
                                                        selectedMap = index
                                                        
                                                    }
                                                }
                                        } else {
                                            Image("UnselectedTabAsset")
                                                .resizable()
                                                .frame(width: 8, height: 8)
                                                .onTapGesture {
                                                    withAnimation(.easeInOut(duration: 0.5)) {
                                                        selectedMap = index
                                                        
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, UIScreen.main.bounds.height * 0.1)
                        }
                        Spacer()
                    } else {
                        VStack {
                            Spacer()
                            LottieView(animationName: "logo2", ifActive: false, contentMode: true, isLoop: true)
                                .frame(width: UIScreen.main.bounds.width * 0.8)
                                .offset(y: -90)
                                .allowsHitTesting(false)
                            Spacer()
                            VStack(alignment: .center) {
                                
                                
                                HStack {
                                    Spacer()
                                    ZStack {
                                        NavigationLink(destination: GameView(gameType: .multiplayer, gameSize: (8, 5), obstacles: []), isActive: $gameCenterController.isMatched) {
                                            EmptyView()
                                        }
                                        Button {
                                            self.isMatchmakingPresented = true
                                        } label: {
                                            
                                            ButtonView(text: onlineBattle, width: buttonWidth, height: 48)
                                            
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
                                    Spacer()
                                }
                                HStack {
                                    JungleButtonView(text: versusAI, width: buttonWidth, height: 48)
                                        .conditionalEffect(.repeat(.glow(color: .blue, radius: 70), every: 1.5  ),
                                                            condition: isJungleButtonTapped)
                                        .animation(.default, value: isJungleButtonTapped)
                                        .onTapGesture {
                                            withAnimation {
                                                isJungleButtonTapped.toggle()
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") == false {
                                                    UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                                                    showVideoPlayer = true
                                                    SoundManager.shared.stopBackgroundMusic()
                                                } else {
                                                    withAnimation{
                                                        showLevelMap.toggle()
//                                                        showFirstMapOne.toggle()
                                                    }
                                                }
                                            }
                                            
                                        }
                                    
                                    //                                            NavigationLink(destination:
                                    ////                                                            LevelMapView()
                                    //        //                                                    GameView(gameType: .ai, gameSize: (row: GameLevel.level1.boardSize.rows, col: GameLevel.level1.boardSize.cols), obstacles: GameLevel.level1.obstacles)
                                    //        //                                                   ,
                                    //        //                                                   isActive: remainingHearts > 0 ? .constant(true) : .constant(false)
                                    //                                            ) {
                                    //                                                ButtonView(text: versusAI, width: singleButtonWidth, height: 50)
                                    //        //                                    }
                                    //        //                                    .opacity(remainingHearts > 0 ? 1.0 : 0.5) // Optionally make the button appear semi-transparent when disabled
                                    //        //                                    .disabled(remainingHearts <= 0)
                                    //
                                    //                                        }
                                    //                                            .simultaneousGesture(TapGesture().onEnded({
                                    //        //                                        if remainingHearts > 0 {
                                    //                                                    gameCenterController.path.append(2)
                                    //        //                                        }
                                    //                                            }))
                                    
                                    //MARK: - Local 1 vs 1 is here
                                    // 1 vs 1
                                    //                                        NavigationLink {
                                    //                                            GameView(gameType: .oneVone, gameSize: (4, 4), obstacles: [(2, 2)])
                                    //                                        } label: {
                                    //                                            ButtonView(text: localDuel, width: singleButtonWidth, height: 50)
                                    //                                        }
                                    //                                        .simultaneousGesture(TapGesture().onEnded({
                                    //                                            gameCenterController.path.append(3)
                                    //                                        }))
                                    //                                        Spacer()
                                }
                                .padding(.top, 20)
                                
                                HStack(spacing: 0) {
                                    Spacer()
                                    ButtonView(text: nil, width: smallButtonWidth, height: 44)
                                        .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 4)
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
                                    ButtonView(text: nil, width: smallButtonWidth, height: 44)
                                        .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 4)
                                        .overlay{
                                            Image(musicState ? "musicOn" : "musicOff" )
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 32)
                                        }
                                        .padding(.trailing, 11)
                                        .padding(.leading, 11)
                                        .onTapGesture {
                                            musicState.toggle()
                                            UserDefaults.standard.set(musicState, forKey: "music")
                                            if musicState {
                                                SoundManager.shared.playBackgroundMusic()
                                            } else {
                                                SoundManager.shared.stopBackgroundMusic()
                                            }
                                        }
                                    
                                    ButtonView(text: nil, width: smallButtonWidth, height: 44)
                                        .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 4)
                                        .overlay {
                                            Image(hapticState ? "vibrationOn" : "vibrationOff")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 32)
                                        }
                                        .padding(.trailing, 11)
                                        .onTapGesture {
                                            hapticState.toggle()
                                            UserDefaults.standard.set(hapticState, forKey: "haptic")
                                            if hapticState {
                                                HapticManager.shared.notification(type: .error)
                                            }
                                        }
                                    ButtonView(text: nil, width: smallButtonWidth, height: 44)
                                        .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 4)
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
                                .padding(.top, 12)
                                
                            }
                            
                            .id(appLanguageManager.id)
                            .padding(.bottom, 90)
                            
                        }
                        
                    }
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
                
                if showVideoPlayer {
                    VideoPlayerView {
                        // Fade out and then hide the video player
                        withAnimation {
                            videoPlayerOpacity = 0.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showVideoPlayer = false
                        }
                        withAnimation{
                            showLevelMap.toggle()
//                            showFirstMap = true
                        }
                        SoundManager.shared.playBackgroundMusic()
                    }
                    .opacity(videoPlayerOpacity)
                    .edgesIgnoringSafeArea(.all)
                }
                
                if showHeartAlert {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                showHeartAlert = false
                            }
                        }
                }
                HeartStatusView(nextHeartTime: $remainingTime, isPresent: $showHeartAlert)
                    .scaleEffect(showHeartAlert ? 1 : 0)
                    .allowsHitTesting(showHeartAlert)
                    .animation(showHeartAlert ? .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0) : .linear(duration: 0.001), value: showHeartAlert)
                
                
                //                    if showStory {
                //                        Color.black.opacity(0.8)
                //                            .ignoresSafeArea()
                //                            .onTapGesture {
                //                                withAnimation {
                //                                    showStory = false
                //                                }
                //                            }
                //                    }
                //                    CustomTestTabView()
                //                        .animation(showStory ? .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0) : .linear(duration: 0.001), value: !showStory)
                
                VStack {
                    Spacer()
                    if showCreditScreen {
                        CreditView(isPresent: $showCreditScreen)
                    }
                    
                    NavigationLink {
                        TutorialView(gameCenterManager: gameCenterController)
                            .environmentObject(gameCenterController)
                    } label: {
                        ButtonView(text: howToPlay, width: 200, height: 50)
                        //                                .offset(y: 40)
                    }
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded({gameCenterController.path.append(gameCenterController.currentLevel?.rawValue ?? 100 + 100)})
                    )
                    .padding(.top, 30)
                    
                    Button {
                        requestReview()
                        
                    } label: {
                        ButtonView(text: rateUs, width: 200, height: 50)
                            .padding(.top, 10)
                    }
                    
                    Button {
                        showResetGameAlert = true
                    } label: {
                        ButtonView(text: resetGame, width: 200, height: 50)
                            .padding(.top, 10)

                    }
                    .alert(areYouSure, isPresented: $showResetGameAlert) {
                        Button(resetGame2) {
                            UserDefaults.standard.setValue(1, forKey: "achievedLevel")
                            UserDefaults.standard.setValue(1, forKey: "currentBundle")
                            loadCurrentBundle()
                            loadAchievedLevel()
                        }
                        Button(cancel, role: .cancel) { }
                    } message: {
                        Text(loseProgress)
                    }
                    Spacer()

                }
                .scaleEffect(showCreditScreen ? 1 : 0)
                .allowsHitTesting(showCreditScreen)
                .animation(showCreditScreen ? .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0) : .linear(duration: 0.001), value: showCreditScreen)
            }
            .autotoggle($isBackgroundShown, with: .spring(dampingFraction: 1))
            .ignoresSafeArea()
            //                }
            //            } else {
            //                HowToPlayView()
            //                //                    .onAppear{
            //                //                        gameCenterController.path.append(20)
            //                //                    }
            //            }
            
        }
        .onChange(of: gameCenterController.currentPlayer) { newValue in
            print("Currently selected level: ", newValue)
        }
        .onAppear {
            
            loadAchievedLevel()
            loadCurrentBundle()
            selectedMap = gameCenterController.currentBundle.id
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
//            if remainingHearts == nil {
//                gameCenterController.remainingHearts = 5
//                UserDefaults.standard.set(5, forKey: "hearts")
//            }
            
//            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                self.updateRemainingTime()
//            }
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
        .onChange(of: gameCenterController.path, perform: { value in
//            print("Current paths :", value)
        })
        //        .alert(isPresented: $showHeartAlert) {
        //            Alert(
        //                    title: Text("\(remainingHearts ?? 0) hearts"),
        //                    message: Text("Next life in \(formatTimeForDisplay(seconds: timeUntilNextHeart()))."),
        //                    dismissButton: .default(Text("OK"), action: {
        //                        showHeartAlert.toggle()
        //                    })
        //                )
        //        }
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
    
//    func timeUntilNextHeart() -> TimeInterval {
//        let lastHeartTime = UserDefaults.standard.integer(forKey: "lastHeartTime")
//        let lastTime = Date(timeIntervalSinceReferenceDate: TimeInterval(lastHeartTime))
//        let elapsedTime = Date().timeIntervalSince(lastTime)
//        let remainingTime = 20 - (elapsedTime.truncatingRemainder(dividingBy: 900))
//        return max(0, remainingTime)
//    }
//    
//    func formatTimeForDisplay(seconds: TimeInterval) -> String {
//        let minutes = Int(seconds) / 60
//        let remainingSeconds = Int(seconds) % 60
//        return "\(minutes):\(String(format: "%02d", remainingSeconds))"
//    }
//    
//    func updateRemainingTime() {
//        let time = timeUntilNextHeart()
//        remainingTime = formatTimeForDisplay(seconds: time)
//    }
//    
//    func localizedStringForKey(_ key: String, language: String) -> String {
//        let path = Bundle.main.path(forResource: language, ofType: "lproj")
//        let bundle = Bundle(path: path!)
//        return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: "", comment: "")
//    }
//    
    private func loadAchievedLevel() {
        let savedLevelID = UserDefaults.standard.integer(forKey: "achievedLevel")
        gameCenterController.achievedLevel = GameLevel(rawValue: savedLevelID) ?? .level3_7
    }
    
    private func loadCurrentBundle(){
        let savedBundleID = UserDefaults.standard.integer(forKey: "currentBundle")
        gameCenterController.currentBundle = GameLevelBundle(rawValue: savedBundleID) ?? .bundle3
    }
}


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView().environmentObject(AppLanguageManager())
    }
}

struct MapItemName: View {
    let id: String
    let title: String
    var body: some View {
        
        Text(id + "\(title)")
            .font(.custom("TempleGemsRegular", size: 24))
            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).tracking(0.84).multilineTextAlignment(.center).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:0, x:0, y:1)                .tracking(0.72)
            .multilineTextAlignment(.center)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:0, x:0, y:1)
        
        
    }
}
