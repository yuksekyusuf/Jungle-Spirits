//
//  RewardedAdManager.swift
//  Jungle Spirits
//
//  Created by Ahmet Yusuf Yuksek on 17.05.2024.
//

import GoogleMobileAds
import SwiftUI
//


@MainActor
class RewardedAdManager: NSObject, GADFullScreenContentDelegate, ObservableObject, NetworkMonitorDelegate {
    
    
    private var rewardedAd: GADRewardedAd?
    let myReward: String = "ca-app-pub-6611029765689882/1235710290"
    let testReward: String = "ca-app-pub-3940256099942544/1712485313"

    @Published var isAdLoaded = false

    override init() {
        super.init()
        NetworkMonitor.shared.delegate = self
        loadAd()
    }
    
    func loadAd() {
        let adUnitID = myReward // Use testReward for testing
        GADRewardedAd.load(withAdUnitID: adUnitID, request: GADRequest()) { [weak self] ad, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                self.isAdLoaded = false
                return
            }
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
            self.isAdLoaded = true
        }
    }
    
    func showAd(from rootViewController: UIViewController, rewardFunction: @escaping () -> Void) async {
        guard let ad = rewardedAd else {
            print("Ad wasn't ready")
            return
        }
        
        let rewardedAd = await presentAd(ad, from: rootViewController)
        if let reward = rewardedAd?.adReward {
            print("Reward received with currency: \(reward.amount), amount \(reward.amount.doubleValue)")
            rewardFunction()
        }
        
        self.isAdLoaded = false
        self.loadAd() // Load a new ad for the next time
    }
    
    private func presentAd(_ ad: GADRewardedAd, from rootViewController: UIViewController) async -> GADRewardedAd? {
        return await withCheckedContinuation { continuation in
            ad.present(fromRootViewController: rootViewController) {
                continuation.resume(returning: ad)
            }
        }
    }
    
    // MARK: - GADFullScreenContentDelegate methods
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
        self.isAdLoaded = false
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        self.loadAd() // Load a new ad after one is dismissed
    }
    func didRestoreConnection() {
        loadAd()
    }
}
