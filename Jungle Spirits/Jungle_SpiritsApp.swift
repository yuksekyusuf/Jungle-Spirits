//
//  Temple_BeastsApp.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/5/23.
//

import SwiftUI
import AmplitudeSwift
import Combine
import GoogleMobileAds
import RevenueCat

let REVENUECATID = "app69847db565"
let REVENUECAT = "sk_WYLEPTQfDUDEiMFPflKTwwfsowkoV"


extension Amplitude {
    static let shared = Amplitude(configuration: Configuration(apiKey: "63de0cb932aea846edc6311602875225"))
}

@main
struct Jungle_SpiritsApp: App {
//    @StateObject var navigationCoordinator = NavigationCoordinator()
    @StateObject var appLanguageManager = AppLanguageManager()
    @StateObject var gameCenterManager = GameCenterManager(currentPlayer: .player1)
    @StateObject var heartManager = HeartManager()
//    @AppStorage("remainingHearts") var remainingHearts: Int?
//    @AppStorage("lastHeartTime") var lastHeartTime: TimeInterval = 0
//    @State var heartTimer: Timer?
//    @State var lastHeartTime: TimeInterval = UserDefaults.standard.double(forKey: "lastHeartTime")
    @Environment(\.scenePhase) private var scenePhase
    private var sessionStartTime: Date?

    let event = BaseEvent(
        eventType: "Button Clicked",
        eventProperties: ["my event prop key": "my event prop value"]
    )
    
    init() {
        
        let _ = Amplitude.shared
//        initMobileAds()
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: REVENUECAT)
    }
    
    var body: some Scene {
        WindowGroup {
//            MainDatabaseView()
//                .environmentObject(gameCenterManager)
//                .environmentObject(navigationCoordinator)
//                            .environmentObject(appLanguageManager)

            MenuView()
                .environmentObject(appLanguageManager)
                .environmentObject(gameCenterManager)
                .environmentObject(heartManager)
                .environment(\.appLanguage, appLanguageManager.currentLanguage)
            
                .onAppear {
//                    startHeartTimer()
//                    heartManager.startHeartTimer()

                }
                .onDisappear(perform: {
                    gameCenterManager.heartTimer?.invalidate()
                })
//                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
//                    updateHeartsBasedOnTimeElapsed()
//                }
                .onChange(of: scenePhase) { newScene in
                    switch newScene {
                    case .active:
                        //MARK: - YOU NEED TO FIX THIS ERROR!!!!!!!
//                        if heartManager.remainingHearts != 5 {
                           heartManager.startHeartTimer()
//                        }
//                        initMobileAds()
//                        SessionManager.shared.logSessionStart()
                    case .background:
//                        SessionManager.shared.logSessionEnd()
                        UserDefaults.standard.set(Date().timeIntervalSinceReferenceDate, forKey: "lastHeartTime")
                    case .inactive:
                        break
                    @unknown default:
                        break
                    }
                    
                }

        }
        
    }
    
//    func startHeartTimer() {
//        gameCenterManager.heartTimer?.invalidate()
//        
//        // Check if a heart should be given right away
//        updateHeartsBasedOnTimeElapsed()
//        
//        gameCenterManager.heartTimer = Timer.scheduledTimer(withTimeInterval: 900, repeats: true) { _ in
//            let hearts = UserDefaults.standard.integer(forKey: "hearts")
//            if hearts < 5 {
//                gameCenterManager.remainingHearts = UserDefaults.standard.integer(forKey: "hearts") + 1
//                UserDefaults.standard.set(gameCenterManager.remainingHearts, forKey: "hearts")
//                
//            }
//            
//        }
//    }
////    
//    func updateHeartsBasedOnTimeElapsed() {
//        let lastTime = Date(timeIntervalSinceReferenceDate: lastHeartTime)
//        let elapsedTime = Date().timeIntervalSince(lastTime)
//        
//        let heartIntervals = Int(elapsedTime / 900)
//        
//        if heartIntervals > 0 {
//            heartManager.remainingHearts = min((UserDefaults.standard.integer(forKey: "hearts")) + heartIntervals, 5)
//            UserDefaults.standard.set(heartManager.remainingHearts, forKey: "hearts")
//            lastHeartTime = Date().timeIntervalSinceReferenceDate
//            UserDefaults.standard.set(lastHeartTime, forKey: "lastHeartTime") // Persist the new lastHeartTime
//        }
//    }
    
    func initMobileAds() {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
            // comment this if you want SDK Crash Reporting:
            GADMobileAds.sharedInstance().disableSDKCrashReporting()
        }
        
}


struct LanguageKey: EnvironmentKey {
    static let defaultValue: String = "en"  // default to English
}

extension EnvironmentValues {
    var appLanguage: String {
        get { self[LanguageKey.self] }
        set { self[LanguageKey.self] = newValue }
    }
}


//class SessionManager: ObservableObject {
//    static let shared = SessionManager()
//    
//    @Published var sessionStartTime: Date?
//
//    private init() {} // Make it a singleton
//
//    func logSessionStart() {
//        sessionStartTime = Date()
//        Amplitude.shared.track(eventType: "Session_Start", eventProperties: ["start_time": sessionStartTime ?? Date()])
//        // Optionally log "Session Start" event to Amplitude here
//    }
//
//    func logSessionEnd() {
//        guard let startTime = sessionStartTime else { return }
//        let sessionDuration = Date().timeIntervalSince(startTime)
//        Amplitude.shared.track(eventType: "Session_End", eventProperties: ["end_time": sessionDuration])
//        // Log "Session End" event with duration to Amplitude here
//        // Reset session start time
//        sessionStartTime = nil
//    }
//}
