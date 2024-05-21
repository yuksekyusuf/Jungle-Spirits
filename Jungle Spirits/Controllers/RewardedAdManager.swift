//
//  RewardedAdManager.swift
//  Jungle Spirits
//
//  Created by Ahmet Yusuf Yuksek on 17.05.2024.
//

import GoogleMobileAds
import SwiftUI


class RewardedAdManager: NSObject, GADFullScreenContentDelegate, ObservableObject {
    private var rewardedAd: GADRewardedAd?
    let myReward: String = "ca-app-pub-6611029765689882/1235710290"
    let testReward: String = "ca-app-pub-3940256099942544/1712485313"

    @Published var isAdLoaded = false
    
    func loadAd() {
        let adUnitID = "ca-app-pub-6611029765689882/1235710290"
        GADRewardedAd.load(withAdUnitID: adUnitID, request: GADRequest()) { ad, error in
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
    
    func showAd(from rootViewController: UIViewController, rewardFunction: @escaping () -> Void) {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: rootViewController) {
                let reward = ad.adReward
                print("Reward received with currency: \(reward.amount), amount \(reward.amount.doubleValue)")
                rewardFunction()
                self.isAdLoaded = false
                self.loadAd() // Load a new ad for the next time
            }
        } else {
            print("Ad wasn't ready")
        }
    }
    
    // MARK: - GADFullScreenContentDelegate methods
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        self.loadAd() // Load a new ad after one is dismissed
    }
}
