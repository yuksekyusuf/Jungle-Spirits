//
//  UserViewModel.swift
//  Jungle Spirits
//
//  Created by Ahmet Yusuf Yuksek on 16.05.2024.
//

import SwiftUI
import RevenueCat

enum SubscriptionType {
    case weekly
    case yearly
}

class UserViewModel: ObservableObject {
    
    @Published var isSubscriptionActive = false
    @Published var subscriptionType: SubscriptionType? = nil
    
    init() {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            self.isSubscriptionActive = customerInfo?.entitlements.all["Unlimited"]?.isActive == true
            let subscription =  customerInfo?.entitlements.all["Unlimited"]?.productIdentifier
            
            if subscription == "js_099_1w" {
                self.subscriptionType = .weekly
            } else if subscription == "js_999_1y_1w0" {
                self.subscriptionType = .yearly
            }
        }
    }
}
