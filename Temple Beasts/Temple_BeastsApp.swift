//
//  Temple_BeastsApp.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/5/23.
//

import SwiftUI



@main
struct Temple_BeastsApp: App {
    @StateObject var appLanguageManager = AppLanguageManager()
    @AppStorage("remainingHearts") var remainingHearts: Int?
    @AppStorage("lastHeartTime") var lastHeartTime: TimeInterval = 0
    @State var heartTimer: Timer?

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
