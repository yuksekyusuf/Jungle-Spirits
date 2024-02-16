////
////  SubsTest.swift
////  Temple Beasts
////
////  Created by Ahmet Yusuf Yuksek on 16.02.2024.
////
//
//import SwiftUI
//import RevenueCat
//
//struct SubsTest: View {
//    var body: some View {
//        Button("Subscribe for One Week") {
//                        purchaseSubscription("weekly_subscription_id")
//                    }
//    }
//    private func purchaseSubscription(_ subscriptionId: String) {
//            Purchases.shared.purchasePackage(subscriptionId) { (transaction, purchaserInfo, error, userCancelled) in
//                if let error = error {
//                    // Handle purchase error
//                    print("Purchase failed: \(error.localizedDescription)")
//                } else if let purchaserInfo = purchaserInfo {
//                    // Purchase successful, check subscription status and grant benefits
//                    if purchaserInfo.entitlements.all["subscription_entitlement_id"]?.isActive == true {
//                        // User has an active subscription, grant benefits
////                        grantBenefits()
//                    }
//                }
//            }
//        }
//}
//
//#Preview {
//    SubsTest()
//}
