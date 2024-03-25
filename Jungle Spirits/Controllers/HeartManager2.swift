//
//  HeartManager2.swift
//  Jungle Spirits
//
//  Created by Ahmet Yusuf Yuksek on 24.03.2024.
//

import Foundation
import Combine

class HeartManager: ObservableObject {
    static let shared = HeartManager()
    
    @Published var currentHeartCount: Int {
        didSet {
            UserDefaults.standard.set(currentHeartCount, forKey: heartCountKey)
        }
    }
    
    @Published var timeUntilNextHeart: TimeInterval = 0
    
    var timeUntilNextHeartString: String {
        let time = Int(timeUntilNextHeart)
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private let defaults = UserDefaults.standard
    private let heartCountKey = "hearts"
    private let lastHeartLostTimeKey = "lastHeartLostTimeKey"
    private let firstLaunchKey = "isFirstLaunch"
    private let maxHearts = 50
    private let heartReplenishTime: TimeInterval = 15 * 60 // 15 mins in secs
    
    private var timer: Timer?
    
    
    
    private init() {
        // Try to fetch the current heart count from UserDefaults
        let storedHeartCount = defaults.integer(forKey: heartCountKey)
        
        if storedHeartCount == 0 {
            // UserDefaults doesn't have a stored value, could be first launch or reinstall
            // Optionally, check a value from Keychain here if you decide to use it for more persistence
            
            // Initialize with maxHearts
            self.currentHeartCount = maxHearts
            defaults.set(maxHearts, forKey: heartCountKey) // Ensure this is saved for future launches
        } else {
            // A value was found, use it
            self.currentHeartCount = storedHeartCount
        }
        
        // Start the replenishment timer if below max hearts
        if self.currentHeartCount < maxHearts {
            startHeartReplenishmentTimer()
        }
    }
    
    
    func loseHeart() {
        guard currentHeartCount > 0 else { return }
        currentHeartCount -= 1
        defaults.set(Date(), forKey: lastHeartLostTimeKey)
        if currentHeartCount < maxHearts {
            startHeartReplenishmentTimer()
        }
    }
    
    private func startHeartReplenishmentTimer() {
        timer?.invalidate() // Invalidate any existing timer.
        
        updateTimeUntilNextHeart() // Initial update
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimeUntilNextHeart()
        }
    }
    
    private func updateTimeUntilNextHeart() {
        guard let lastLost = defaults.object(forKey: lastHeartLostTimeKey) as? Date else {
            timeUntilNextHeart = heartReplenishTime
            print("Until the next heart: ", timeUntilNextHeart)
            return
        }
        
        let elapsed = Date().timeIntervalSince(lastLost)
        let remaining = max(0, heartReplenishTime - elapsed)
        timeUntilNextHeart = remaining
        print("Until the next heart 2: ", timeUntilNextHeart)
        if remaining <= 0 {
            replenishHeart()
        }
    }
    
    private func replenishHeart() {
        currentHeartCount = min(maxHearts, currentHeartCount + 1)
        if currentHeartCount < maxHearts {
            defaults.set(Date(), forKey: lastHeartLostTimeKey)
            updateTimeUntilNextHeart() // Ensure timer continues if not at max hearts.
        } else {
            timer?.invalidate() // No need for the timer if hearts are full.
        }
    }
}
