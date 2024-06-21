////
////  UserViewModel.swift
////  Jungle Spirits
////
////  Created by Ahmet Yusuf Yuksek on 16.05.2024.
////
//

import SwiftUI
import RevenueCat

enum SubscriptionType {
    case weekly
    case lifetime
}

class UserViewModel: ObservableObject {
    
    @Published var isSubscriptionActive = false
    @Published var subscriptionType: SubscriptionType? = nil
    
    init() {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            print("Customer Info: ", customerInfo?.entitlements["Unlimited"]?.description)

            self.isSubscriptionActive = customerInfo?.entitlements.all["Unlimited"]?.isActive == true
            let subscription =  customerInfo?.entitlements.all["Unlimited"]?.productIdentifier
            
            if subscription == "js_099_1w" {
                self.subscriptionType = .weekly
            } else if subscription == "js_1999_lt" {
                self.subscriptionType = .lifetime
            }
        }
    }
}


//import SwiftUI
//import RevenueCat
//
//enum SubscriptionType {
//    case weekly
//    case lifetime
//}
//
//class UserViewModel: ObservableObject, PurchasesDelegate {
//    
//    @Published var isSubscriptionActive = false
//    @Published var subscriptionType: SubscriptionType? = nil
//    
//    init() {
//        Purchases.shared.delegate = self
//        fetchCustomerInfo()
//
//        
//        Purchases.shared.getCustomerInfo { customerInfo, error in
//            self.isSubscriptionActive = customerInfo?.entitlements.all["Unlimited"]?.isActive == true
//            let subscription =  customerInfo?.entitlements.all["Unlimited"]?.productIdentifier
//            
//            if subscription == "js_099_1w" {
//                self.subscriptionType = .weekly
//            } else if subscription == "js_1999_lt" {
//                self.subscriptionType = .lifetime
//            }
//        }
//    }
//    
//    func fetchCustomerInfo() {
//            Purchases.shared.getCustomerInfo { customerInfo, error in
//                if let error = error {
//                    // Handle the error here if necessary
//                    print("Failed to fetch customer info: \(error.localizedDescription)")
//                }
//                self.updateSubscriptionStatus(customerInfo: customerInfo)
//            }
//        }
//    
//    func updateSubscriptionStatus(customerInfo: CustomerInfo?) {
//            DispatchQueue.main.async {
//                self.isSubscriptionActive = customerInfo?.entitlements.all["Unlimited"]?.isActive == true
//                let subscription = customerInfo?.entitlements.all["Unlimited"]?.productIdentifier
//                
//                if subscription == "js_099_1w" {
//                    self.subscriptionType = .weekly
//                } else if subscription == "js_1999_lt" {
//                    self.subscriptionType = .lifetime
//                }
//            }
//        }
//    
//    // PurchasesDelegate method to handle updates
//    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
//            updateSubscriptionStatus(customerInfo: customerInfo)
//        }
//}


//import SwiftUI
//import RevenueCat
//
//enum SubscriptionType {
//    case weekly
//    case lifetime
//}
//
//class UserViewModel: NSObject, ObservableObject, PurchasesDelegate {
//    
//    @Published var isSubscriptionActive = false
//    @Published var subscriptionType: SubscriptionType? = nil
//    
//    override init() {
//        super.init()
//        Purchases.shared.delegate = self
//        fetchCustomerInfo()
//    }
//    
//    func fetchCustomerInfo() {
//        Purchases.shared.getCustomerInfo { customerInfo, error in
//            if let error = error {
//                // Handle the error here if necessary
//                print("Failed to fetch customer info: \(error.localizedDescription)")
//            }
//            self.updateSubscriptionStatus(customerInfo: customerInfo)
//        }
//    }
//    
//    func updateSubscriptionStatus(customerInfo: CustomerInfo?) {
//        DispatchQueue.main.async {
//            self.isSubscriptionActive = customerInfo?.entitlements.all["Unlimited"]?.isActive == true
//            let subscription = customerInfo?.entitlements.all["Unlimited"]?.productIdentifier
//            
//            if subscription == "js_099_1w" {
//                self.subscriptionType = .weekly
//            } else if subscription == "js_1999_lt" {
//                self.subscriptionType = .lifetime
//            }
//        }
//    }
//    
//    // PurchasesDelegate method to handle updates
//    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
//        updateSubscriptionStatus(customerInfo: customerInfo)
//    }
//}

//
//import SuperwallKit
//import RevenueCat
//import StoreKit
//
//final class RCPurchaseController: PurchaseController {
//  // MARK: Sync Subscription Status
//  /// Makes sure that Superwall knows the customers subscription status by
//  /// changing `Superwall.shared.subscriptionStatus`
//  func syncSubscriptionStatus() {
//    assert(Purchases.isConfigured, "You must configure RevenueCat before calling this method.")
//    Task {
//      for await customerInfo in Purchases.shared.customerInfoStream {
//        // Gets called whenever new CustomerInfo is available
//        let hasActiveSubscription = !customerInfo.entitlements.active.isEmpty // Why? -> https://www.revenuecat.com/docs/entitlements#entitlements
//        if hasActiveSubscription {
//          Superwall.shared.subscriptionStatus = .active
//        } else {
//          Superwall.shared.subscriptionStatus = .inactive
//        }
//      }
//    }
//  }
//
//  // MARK: Handle Purchases
//  /// Makes a purchase with RevenueCat and returns its result. This gets called when
//  /// someone tries to purchase a product on one of your paywalls.
//  func purchase(product: SKProduct) async -> PurchaseResult {
//    do {
//      // This must be initialized before initiating the purchase.
//      let purchaseDate = Date()
//
//      let storeProduct = RevenueCat.StoreProduct(sk1Product: product)
//      let revenueCatResult = try await Purchases.shared.purchase(product: storeProduct)
//      if revenueCatResult.userCancelled {
//        return .cancelled
//      } else {
//        if let transaction = revenueCatResult.transaction,
//           purchaseDate > transaction.purchaseDate {
//          return .restored
//        } else {
//          return .purchased
//        }
//      }
//    } catch let error as ErrorCode {
//      if error == .paymentPendingError {
//        return .pending
//      } else {
//        return .failed(error)
//      }
//    } catch {
//      return .failed(error)
//    }
//  }
//
//  // MARK: Handle Restores
//  /// Makes a restore with RevenueCat and returns `.restored`, unless an error is thrown.
//  /// This gets called when someone tries to restore purchases on one of your paywalls.
//  func restorePurchases() async -> RestorationResult {
//    do {
//      _ = try await Purchases.shared.restorePurchases()
//      return .restored
//    } catch let error {
//      return .failed(error)
//    }
//  }
//}
//
//
//import SwiftUI
//import RevenueCat
//import SuperwallKit
//
//enum SubscriptionType {
//    case weekly
//    case lifetime
//}
//
//class UserViewModel: ObservableObject {
//    
//    @Published var isSubscriptionActive = false
//        @Published var subscriptionType: SubscriptionType? = nil
//        
//        init() {
//            configureSuperwall()
//            fetchAndSyncSubscriptionStatus()
//        }
//        
//        private func configureSuperwall() {
//            let controller = RCPurchaseController() // Assuming RCPurchaseController is already defined
//            Superwall.configure(apiKey: "pk_85df30eeac6cb8adf1c65fbccabe2e087dfc7bc80c33e7e0", purchaseController: controller)
//        }
//        
//        private func fetchAndSyncSubscriptionStatus() {
//            Purchases.shared.getCustomerInfo { [weak self] customerInfo, error in
//                guard let self = self else { return }
//                if let error = error {
//                    print("Error fetching customer info: \(error.localizedDescription)")
//                    return
//                }
//                self.updateSubscriptionStatus(customerInfo: customerInfo)
//                // Sync Superwall's subscription status
//                let hasActiveSubscription = ((customerInfo?.entitlements.active.isEmpty) == nil)
//                Superwall.shared.subscriptionStatus = hasActiveSubscription ? .active : .inactive
//            }
//        }
//        
//        private func updateSubscriptionStatus(customerInfo: CustomerInfo?) {
//            DispatchQueue.main.async {
//                self.isSubscriptionActive = customerInfo?.entitlements.all["Unlimited"]?.isActive == true
//                let subscription = customerInfo?.entitlements.all["Unlimited"]?.productIdentifier
//                
//                print("Subscription: ", subscription)
//                if subscription == "js_099_1w" {
//                    self.subscriptionType = .weekly
//                } else if subscription == "js_1999_lt" {
//                    self.subscriptionType = .lifetime
//                }
//            }
//        }
//}
