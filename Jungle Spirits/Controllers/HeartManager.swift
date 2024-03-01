////
////  HeartManager.swift
////  Temple Beasts
////
////  Created by Ahmet Yusuf Yuksek on 22.02.2024.
////
//
//import SwiftUI
//
//class HeartManager: ObservableObject {
//    @Published var remainingHeartTime: String = "0:00"
//    @Published var remainingHearts: Int = UserDefaults.standard.integer(forKey: "hearts") == 0 ? 5 : UserDefaults.standard.integer(forKey: "hearts")
//    private var timer: Timer?
//    private let heartTimeInterval: TimeInterval = 900 // 15 minutes
//    private var lastHeartTime: TimeInterval {
//        get { UserDefaults.standard.double(forKey: "lastHeartTime") }
//        set { UserDefaults.standard.set(newValue, forKey: "lastHeartTime") }
//    }
//    
//    init() {
//        updateRemainingTime()
//    }
//    func startHeartTimer() {
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
//            self?.updateRemainingTime()
//            self?.updateHeartsBasedOnTimeElapsed()
//        }
//    }
//    
//    private func timeUntilNextHeart() -> TimeInterval {
//        let lastTime = Date(timeIntervalSinceReferenceDate: lastHeartTime)
//        let elapsedTime = Date().timeIntervalSince(lastTime)
//        let remainingTime = heartTimeInterval - (elapsedTime.truncatingRemainder(dividingBy: heartTimeInterval))
//        return max(0, remainingTime)
//    }
//    
//    func updateHeartsBasedOnTimeElapsed() {
//        let lastTime = Date(timeIntervalSinceReferenceDate: lastHeartTime)
//        let elapsedTime = Date().timeIntervalSince(lastTime)
//        
//        let heartIntervals = Int(elapsedTime / heartTimeInterval)
//        
//        if heartIntervals > 0 {
//            let newHearts = min(remainingHearts + heartIntervals, 5)
//            self.remainingHearts = newHearts
//            UserDefaults.standard.set(newHearts, forKey: "hearts")
//            lastHeartTime = Date().timeIntervalSinceReferenceDate // Update lastHeartTime
//        }
//    }
//    
//    private func formatTimeForDisplay(seconds: TimeInterval) -> String {
//        let minutes = Int(seconds) / 60
//        let remainingSeconds = Int(seconds) % 60
//        return "\(minutes):\(String(format: "%02d", remainingSeconds))"
//    }
//    
//    private func updateRemainingTime() {
//        let time = timeUntilNextHeart()
//        remainingHeartTime = formatTimeForDisplay(seconds: time)
//    }
//    
//    deinit {
//        timer?.invalidate()
//    }
//
//}
