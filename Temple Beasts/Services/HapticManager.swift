//
//  HapticManager.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 1.07.2023.
//

import SwiftUI

class HapticManager {
    static let shared = HapticManager()

    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        guard UserDefaults.standard.bool(forKey: "haptic") else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard UserDefaults.standard.bool(forKey: "haptic") else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
