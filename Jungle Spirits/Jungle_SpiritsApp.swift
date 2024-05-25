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
let REVENUECAT = "appl_rIynXzEHyTQFnjkLHVEvofZNVUc"


extension Amplitude {
    static let shared = Amplitude(configuration: Configuration(apiKey: "63de0cb932aea846edc6311602875225"))
}

@main
struct Jungle_SpiritsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appLanguageManager = AppLanguageManager()
    @StateObject var gameCenterManager = GameCenterManager(currentPlayer: .player1)
    @StateObject var heartManager = HeartManager.shared
    @StateObject var userViewModel = UserViewModel()
    @StateObject var rewardedAdManager = RewardedAdManager()
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
        
//        if UserDefaults.standard.value(forKey: "hearts") == nil {
//            UserDefaults.standard.set(100, forKey: "hearts") // Set default hearts to 5
//        }
    }
    
    var body: some Scene {
        WindowGroup {
            
            MenuView()
                .environmentObject(appLanguageManager)
                .environmentObject(gameCenterManager)
                .environmentObject(heartManager)
                .environmentObject(userViewModel)
                .environment(\.appLanguage, appLanguageManager.currentLanguage)
                .environmentObject(rewardedAdManager)
                .onAppear {
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                    rewardedAdManager.loadAd()
                }
        }
    }
    
    
    
    
    
//        func initMobileAds() {
//                GADMobileAds.sharedInstance().start(completionHandler: nil)
//                // comment this if you want SDK Crash Reporting:
//                GADMobileAds.sharedInstance().disableSDKCrashReporting()
//            }
    
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

//
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Any additional setup can be done here
//        return true
//    }
//}

class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    GADMobileAds.sharedInstance().start(completionHandler: nil)

    return true
  }
}
