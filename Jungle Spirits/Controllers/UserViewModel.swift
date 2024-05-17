//
//  UserViewModel.swift
//  Jungle Spirits
//
//  Created by Ahmet Yusuf Yuksek on 16.05.2024.
//

import SwiftUI
import RevenueCat

class UserViewModel: ObservableObject {
    
    @Published var isSubscriptionActive = false
    
    init() {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            self.isSubscriptionActive = customerInfo?.entitlements.all["Unlimited"]?.isActive == true
        }
    }
    
    
}
