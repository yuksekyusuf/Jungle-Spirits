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

        var body: some Scene {
            WindowGroup {
                MenuView()
                    .environmentObject(appLanguageManager)
                    .environment(\.appLanguage, appLanguageManager.currentLanguage)
//                CreditView()
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
