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
struct Temple_BeastsApp: App {
    @StateObject var appLanguageManager = AppLanguageManager()
    @AppStorage("remainingHearts") var remainingHearts: Int?
    @AppStorage("lastHeartTime") var lastHeartTime: TimeInterval = 0
    @State var heartTimer: Timer?
    @Environment(\.scenePhase) private var scenePhase
    private var sessionStartTime: Date?

    let event = BaseEvent(
        eventType: "Button Clicked",
        eventProperties: ["my event prop key": "my event prop value"]
    )
    
    init() {
        let _ = Amplitude.shared
        initMobileAds()
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: REVENUECAT)
    }
    
    var body: some Scene {
        WindowGroup {
            MenuView()
                .environmentObject(appLanguageManager)
                .environment(\.appLanguage, appLanguageManager.currentLanguage)
                .onAppear {
                    startHeartTimer()

                }
                .onDisappear(perform: {
                    heartTimer?.invalidate()
                })
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    updateHeartsBasedOnTimeElapsed()
                }
                .onChange(of: scenePhase) { newScene in
                    switch newScene {
                    case .active:
                        initMobileAds()
                        SessionManager.shared.logSessionStart()
                    case .background:
                        SessionManager.shared.logSessionEnd()
                    case .inactive:
                        break
                    @unknown default:
                        break
                    }
                    
                }
//            AdView()
//              
            
//            ShareButtonView()
        }
        
    }
    
    func startHeartTimer() {
        heartTimer?.invalidate()
        
        // Check if a heart should be given right away
        updateHeartsBasedOnTimeElapsed()
        
        heartTimer = Timer.scheduledTimer(withTimeInterval: 900, repeats: true) { _ in
            let hearts = UserDefaults.standard.integer(forKey: "hearts")
            if hearts < 5 {
                let heart = UserDefaults.standard.integer(forKey: "hearts") + 1
                UserDefaults.standard.set(heart, forKey: "hearts")
                
            }
            
        }
    }
    
    func updateHeartsBasedOnTimeElapsed() {
        let lastTime = Date(timeIntervalSinceReferenceDate: lastHeartTime)
        let elapsedTime = Date().timeIntervalSince(lastTime)
        
        let heartIntervals = Int(elapsedTime / 900)
        
        if heartIntervals > 0 {
            let hearts = min((UserDefaults.standard.integer(forKey: "hearts")) + heartIntervals, 5)
            UserDefaults.standard.set(hearts, forKey: "hearts")
            lastHeartTime = Date().timeIntervalSinceReferenceDate
        }
    }
    
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


class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    @Published var sessionStartTime: Date?

    private init() {} // Make it a singleton

    func logSessionStart() {
        sessionStartTime = Date()
        Amplitude.shared.track(eventType: "Session_Start", eventProperties: ["start_time": sessionStartTime ?? Date()])
        // Optionally log "Session Start" event to Amplitude here
    }

    func logSessionEnd() {
        guard let startTime = sessionStartTime else { return }
        let sessionDuration = Date().timeIntervalSince(startTime)
        Amplitude.shared.track(eventType: "Session_End", eventProperties: ["end_time": sessionDuration])
        // Log "Session End" event with duration to Amplitude here
        // Reset session start time
        sessionStartTime = nil
    }
}
