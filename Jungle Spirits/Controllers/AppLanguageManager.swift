//
//  AppLanguageManager.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 15.09.2023.
//

import Foundation


class AppLanguageManager: ObservableObject {
    @Published var currentLanguage: String = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en" {
        didSet {
            self.id = UUID()  // Change ID every time the language changes
        }
    }
    var id = UUID()
    
    func setLanguage(_ language: String) {
        UserDefaults.standard.set(language, forKey: "AppLanguage")
        currentLanguage = language
    }
    
//    func localizedStringForKey(_ key: String, language: String) -> String {
//        let path = Bundle.main.path(forResource: language, ofType: "lproj")
//        let bundle = Bundle(path: path!)
//        return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: "", comment: "")
//    }
    func localizedStringForKey(_ key: String, language: String) -> String {
        // Safely unwrap the optional path
        if let path = Bundle.main.path(forResource: language, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            // Use the found bundle for localization
            return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
        } else {
            // Fallback behavior if the path or bundle could not be found
            // You can choose to return the key itself or any other default string
            return key // or "Translation not found"
        }
    }
}
