//
//  AdBanner.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 10.02.2024.
//

//import SwiftUI
//import GoogleMobileAds
//
//
//struct AdBannerView: UIViewRepresentable {
//        
//    let adUnitID: String
//    
//    func makeUIView(context: Context) -> GADBannerView {
//        let bannerView = GADBannerView(adSize: GADAdSizeFromCGSize(CGSize(width: 320, height: 50))) // Set your desired banner ad size
//        bannerView.adUnitID = adUnitID
//        bannerView.rootViewController = UIApplication.shared.getRootViewController()
//        bannerView.load(GADRequest())
//        return bannerView
//    }
//    
//    func updateUIView(_ uiView: GADBannerView, context: Context) {}
//}
//
//extension UIApplication {
//    func getRootViewController() -> UIViewController {
//        guard let screen = self.connectedScenes.first as? UIWindowScene else {
//            return .init()
//        }
//        
//        guard let root = screen.windows.first?.rootViewController else {
//            return .init()
//        }
//        return root
//    }
//}
//
//
//final class RewardedAd {
//    
//    let myReward: String = "ca-app-pub-6611029765689882/1173559792"
//    let testReward: String = "ca-app-pub-3940256099942544/1712485313"
////    private let rewardId = "ca-app-pub-6611029765689882/1173559792" // TODO: replace this with your own Ad ID
//    
//    private let rewardId = "ca-app-pub-3940256099942544/1712485313"
//    // TODO: replace this with your own Ad ID
//    
//  
//    
//    var rewardedAd: GADRewardedAd?
//    
//    init() {
//        load()
//    }
//    
//    func load(){
//        let request = GADRequest()
//        // add extras here to the request, for example, for not presonalized Ads
//
//        GADRewardedAd.load(withAdUnitID: rewardId, request: request, completionHandler: {rewardedAd, error in
//            if error != nil {
//                // loading the rewarded Ad failed :(
//                return
//            }
//            self.rewardedAd = rewardedAd
//        })
//    }
//    
//    func showAd(rewardFunction: @escaping () -> Void) -> Bool {
//        guard let rewardedAd = rewardedAd else {
//            return false
//        }
//        
//        guard let root = UIApplication.shared.keyWindowPresentedController else {
//            return false
//        }
//        rewardedAd.present(fromRootViewController: root, userDidEarnRewardHandler: rewardFunction)
//        return true
//    }
//}
//
//// just an extension to make our life easier to receive the root view controller
//extension UIApplication {
//    
//    var keyWindow: UIWindow? {
//        return UIApplication.shared.connectedScenes
//            .filter { $0.activationState == .foregroundActive }
//            .first(where: { $0 is UIWindowScene })
//            .flatMap({ $0 as? UIWindowScene })?.windows
//            .first(where: \.isKeyWindow)
//    }
//    
//    var keyWindowPresentedController: UIViewController? {
//        var viewController = self.keyWindow?.rootViewController
//        
//        if let presentedController = viewController as? UITabBarController {
//            viewController = presentedController.selectedViewController
//        }
//        
//        while let presentedController = viewController?.presentedViewController {
//            if let presentedController = presentedController as? UITabBarController {
//                viewController = presentedController.selectedViewController
//            } else {
//                viewController = presentedController
//            }
//        }
//        return viewController
//    }
//}


import GoogleMobileAds
import SwiftUI


    class RewardedAdManager: NSObject, GADFullScreenContentDelegate, ObservableObject {
        private var rewardedAd: GADRewardedAd?
        @Published var isAdLoaded = false

        func loadAd() {
            let adUnitID = "ca-app-pub-3940256099942544/1712485313"
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
