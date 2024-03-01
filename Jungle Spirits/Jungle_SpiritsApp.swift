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
//    @StateObject var heartManager = HeartManager()
    
   
    
    @AppStorage("hearts") var remainingHearts: Int = 0
        @AppStorage("lastHeartTime") var lastHeartTime: TimeInterval = 0
//    @AppStorage("remainingHearts") var remainingHearts: Int?
//    @AppStorage("lastHeartTime") var lastHeartTime: TimeInterval = 0
    @State var heartTimer: Timer?
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
        
        if UserDefaults.standard.value(forKey: "hearts") == nil {
            UserDefaults.standard.set(5, forKey: "hearts") // Set default hearts to 5
        }
        
        // Initialize lastHeartTime if it hasn't been set
        if UserDefaults.standard.value(forKey: "lastHeartTime") == nil {
            UserDefaults.standard.set(Date().timeIntervalSinceReferenceDate, forKey: "lastHeartTime") // Set to current time
        }
    }
    
    var body: some Scene {
        WindowGroup {

            MenuView()
                .environmentObject(appLanguageManager)
                .environmentObject(gameCenterManager)
//                .environmentObject(heartManager)
                .environment(\.appLanguage, appLanguageManager.currentLanguage)
            
//                .onAppear {
////                    startHeartTimer()
////                    heartManager.startHeartTimer()
//
//                }
//                .onDisappear(perform: {
//                    gameCenterManager.heartTimer?.invalidate()
//                })
//                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
//                    updateHeartsBasedOnTimeElapsed()
//                }
                
                .onChange(of: scenePhase) { newScene in
                    switch newScene {
                       case .active:
                        print("something")
//                        if gameCenterManager.remainingHearts < 5 {
//                               startHeartTimer()
//                           }
                       case .background:
                           UserDefaults.standard.set(Date().timeIntervalSinceReferenceDate, forKey: "lastHeartTime")
                           stopHeartTimer()
                       case .inactive:
                           break
                       @unknown default:
                           break
                       }
                    
                }

        }
        
    }
    
    private func startHeartTimer() {
        heartTimer?.invalidate() // Invalidate any existing timer
            heartTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in

                let remainingTime = self.timeUntilNextHeart()
                let formattedTime = self.formatTimeForDisplay(seconds: remainingTime)
                
                // Update GameCenterManager with the remaining time
                DispatchQueue.main.async {
                    self.gameCenterManager.remainingHeartTime = formattedTime
                
                }

                self.updateHeartsBasedOnTimeElapsed()
            }
    }
    private func updateHeartsBasedOnTimeElapsed() {
        let elapsedTime = Date().timeIntervalSince(Date(timeIntervalSinceReferenceDate: lastHeartTime))
        let heartTimeInterval: TimeInterval = 900 // 15 minutes
        let heartIntervals = Int(elapsedTime / heartTimeInterval)
        
        if heartIntervals > 0 {
            let newHearts = min(remainingHearts + heartIntervals, 5)
            remainingHearts = newHearts // Update the heart count
            lastHeartTime += TimeInterval(heartIntervals) * heartTimeInterval // Update the last heart time
        }
    }
    
    private func timeUntilNextHeart() -> TimeInterval {
        let elapsedTime = Date().timeIntervalSince(Date(timeIntervalSinceReferenceDate: lastHeartTime))
        let heartTimeInterval: TimeInterval = 900 // 15 minutes
        let remainingTime = heartTimeInterval - elapsedTime.truncatingRemainder(dividingBy: heartTimeInterval)
        return max(0, remainingTime)
    }
    
    private func formatTimeForDisplay(seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return "\(minutes):\(String(format: "%02d", remainingSeconds))"
    }
    
    private func stopHeartTimer() {
            heartTimer?.invalidate()
        }
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
