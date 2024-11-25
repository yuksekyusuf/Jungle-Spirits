//
//  HeartStatusView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 2.12.2023.
//

import SwiftUI
import RevenueCat
import GoogleMobileAds
import SuperwallKit
import RevenueCatUI



struct HeartStatusView: View {
    //    var heartCount: Int
    @EnvironmentObject var appLanguageManager: AppLanguageManager
    @EnvironmentObject var gameCenterManager: GameCenterManager
    @EnvironmentObject var heartManager: HeartManager
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject private var networkMonitor = NetworkMonitor.shared

    @EnvironmentObject private var rewardedAdManager: RewardedAdManager

//    var rewardAd: RewardedAd

//    @Binding var nextHeartTime: String
    @Binding var isPresent: Bool
    @State var newHeart = 0
    
    
    @State var currentOffering: Offering?
    
    @State private var showAlert = false
    
    @State private var paywallPresented = false
//    var rewardAd: RewardedAd
    
    init(isPresent: Binding<Bool>) {
//        self._nextHeartTime = nextHeartTime // Use underscore to directly initialize @Binding properties
        self._isPresent = isPresent
//        self.rewardAd = RewardedAd()
//        rewardAd.load()
    }
    
    var body: some View {
        ZStack {
            //Background
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 272, height: 166)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.73, green: 0.76, blue: 1), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.54, green: 0.48, blue: 0.91), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 1, y: 0),
                            endPoint: UnitPoint(x: 0, y: 1)
                        )
                    )
                    .cornerRadius(44)
                    .shadow(color: .black.opacity(0.45), radius: 20, x: 0, y: 32)
                Image("HeartBackground")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 252)
            }
            //Top Heart
            VStack {
                Spacer()
                ZStack {
                    if userViewModel.isSubscriptionActive {
                        
                        if userViewModel.subscriptionType == .weekly {
                            Image("weeklyHearts")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 116)
                            
                        } else if userViewModel.subscriptionType == .lifetime {
                            Image("yearlyHearts")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 116)
                        }
                        

                    } else if !(heartManager.currentHeartCount > 0) {
                        Image("noHeart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 116)
                    } else {
                        Image("heartRemains")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 116)
                    }
                }
                .padding(.top, 50)
                Spacer()
                Spacer()
            }
            //Text
            VStack {
                

                VStack(spacing: 6) {
                    if userViewModel.isSubscriptionActive {
                        Text("∞ \(hearts.capitalizedSentence)")
                            .font(Font.custom("TempleGemsRegular", size: 32))
                            .kerning(0.96)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        
                        if userViewModel.subscriptionType == .weekly {
                            Text(weekHeart)
                                .font(Font.custom("TempleGemsRegular", size: 20))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.84, green: 0.82, blue: 1))
                                .frame(width: 168, alignment: .center)
                        } else if userViewModel.subscriptionType == .lifetime {
                            Text(lifetimeHearts)
                                .font(Font.custom("TempleGemsRegular", size: 20))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.84, green: 0.82, blue: 1))
                                .frame(width: 168, alignment: .center)
                        }
                        
                    } else {
                        Text("\(heartManager.currentHeartCount) \(hearts.capitalizedSentence)")
                            .font(Font.custom("TempleGemsRegular", size: 32))
                            .kerning(0.96)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        if heartManager.currentHeartCount == 5 {
                            Text(fullHeart)
                                .font(Font.custom("TempleGemsRegular", size: 24))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.84, green: 0.82, blue: 1))
                                .frame(width: 168, alignment: .center)
                        } else {
                            Text("\(next_hearts) \(heartManager.timeUntilNextHeartString)")
                                .font(Font.custom("TempleGemsRegular", size: 20))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.84, green: 0.82, blue: 1))
                                .frame(width: 168, alignment: .center)
                        }
                    }
                    
                }
                .frame(width: 253, alignment: .center)

            }
            
            //Buttons
            VStack {
                
                VStack(spacing: 0) {
                    if !userViewModel.isSubscriptionActive {
                        if heartManager.currentHeartCount < 5 {
                            //Ads button
                            if networkMonitor.isConnected {
                                Button {
                                    
                                    Task {
                                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                            if let rootViewController = scene.windows.first?.rootViewController {
                                                SoundManager.shared.stopBackgroundMusic()
                                                await rewardedAdManager.showAd(from: rootViewController) {
                                                    self.heartManager.currentHeartCount += 1
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    WatchVideo(text: freeHeart)
                                }
                            }
                            

                            //Share button
                            ShareButtonView()
                                .padding(.top, 10)
                        }
                        if currentOffering != nil {
                            
                            Button(action: {
                                
                                paywallPresented = true
                            }, label: {
                                UnlimitedHeartsButton(text: unlimitedHearts)
                            })
                            .padding(.top, 10)

                            
//                            VStack(spacing: 0) {
//                                HStack {
//                                    ForEach(currentOffering!.availablePackages) { pkg in
//                                        Button(action: {
////                                            Purchases.shared.purchase(package: pkg) { (transaction, customerInfo, error, userCancelled) in
////                                                if customerInfo?.entitlements["Unlimited"]?.isActive == true {
////                                                    userViewModel.isSubscriptionActive = true
////
////                                                }
////                                                print("Purchased Info: ", customerInfo?.entitlements["Unlimited"]?.description)
////
////                                                
////                                                
////                                            }
//                                            Purchases.shared.purchase(package: pkg) { (transaction, customerInfo, error, userCancelled) in
//                                                print("Transaction: \(String(describing: transaction))")
//                                                print("CustomerInfo: \(String(describing: customerInfo))")
//                                                print("Error: \(String(describing: error))")
//                                                print("User Cancelled: \(userCancelled)")
//
//                                                if let entitlements = customerInfo?.entitlements["Unlimited"] {
//                                                    print("Entitlement isActive: \(entitlements.isActive)")
//                                                    print("Entitlement Product Identifier: \(entitlements.productIdentifier)")
//                                                    userViewModel.isSubscriptionActive = entitlements.isActive
//                                                    if entitlements.productIdentifier == "js_099_1w" {
//                                                        userViewModel.subscriptionType = .weekly
//                                                    } else if entitlements.productIdentifier == "js_1999_lt" {
//                                                        userViewModel.subscriptionType = .lifetime
//                                                    }
//                                                }
//                                            }
//                                        }, label: {
//                                            if pkg.identifier == "$rc_lifetime" {
//                                                PurchaseButtonView(type: .lifetime)
//
//                                            } else if pkg.identifier == "$rc_weekly" {
//                                                PurchaseButtonView(type: .weekly)
//                                            }
//                                            
//                                        })
//                                        .padding(.top, 10)
//                                        
//                                        
//                                    }
//                                    
//                                    
//                                }
//                            }
                        }
                    }
                    
                    //close button
                    Button(action: {
                        self.isPresent.toggle()
                    }, label: {
                        Image("closeTab")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75)
                    })
                    
                }
                .padding(.top, UIScreen.main.bounds.height * 0.5)
                Spacer()
            }
        }
        .sheet(isPresented: $paywallPresented,
               onDismiss: {
            Task {
                do {
                    let customerInfo = try await Purchases.shared.customerInfo()
                    userViewModel.isSubscriptionActive = customerInfo.entitlements.all["Unlimited"]?.isActive == true
                    let subscription =  customerInfo.entitlements.all["Unlimited"]?.productIdentifier
                    print("!!!!Subscription type: ", subscription)
                    if subscription == "js_099_1w" {
                        userViewModel.subscriptionType = .weekly
                    } else if subscription == "js_1999_lt" {
                        userViewModel.subscriptionType = .lifetime
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }) {
            PaywallView(displayCloseButton: true)
        }
        .onAppear {
            Purchases.shared.getOfferings { offerings, error in
                if let offer = offerings?.current, error == nil {
                    currentOffering = offer
                }
            }
            
            print("Subscription type: ", userViewModel.subscriptionType)
        }
        .onChange(of: userViewModel.subscriptionType, perform: { new in
            print("Subscription type changed: ", new)
        })
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("No Internet Connection"),
                message: Text("Please check your internet connection and try again."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: userViewModel.subscriptionType, perform: { value in
            Purchases.shared.getCustomerInfo { customerInfo, error in
                userViewModel.isSubscriptionActive = customerInfo?.entitlements.all["Unlimited"]?.isActive == true
                let subscription =  customerInfo?.entitlements.all["Unlimited"]?.productIdentifier
                
                if subscription == "js_099_1w" {
                    userViewModel.subscriptionType = .weekly
                } else if subscription == "js_1999_lt" {
                    userViewModel.subscriptionType = .lifetime
                }
            }
        })
    }
}
//
struct HeartStatusView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPresentTrue = true
        HeartStatusView(isPresent: $isPresentTrue)
            .environmentObject(AppLanguageManager())
            .environmentObject(GameCenterManager(currentPlayer: .player1))
            .environmentObject(HeartManager.shared)
            .environmentObject(UserViewModel())
        
    }
}



struct ActivityViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController
    
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}

struct WatchVideo: View {
    let text: String
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color(red: 0.48, green: 0.4, blue: 0.98))
                .frame(width: 221, height: 44, alignment: .center)
                .cornerRadius(14)
                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
            
            Text(text)
                .font(Font.custom("TempleGemsRegular", size: 20))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.83, green: 0.85, blue: 1))
                .frame(width: 148, height: 42, alignment: .center)
                .offset(y: 2)
            Image("plusOneHeart")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
                .offset(x: 80)
        }
    }
}


struct UnlimitedHeartsButton: View {
    let text: String
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color(red: 0.48, green: 0.4, blue: 0.98))
                .frame(width: 221, height: 44, alignment: .center)
                .cornerRadius(14)
                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
            
            Image("yearlyHeartIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
                .offset(x: -65)
            
            Text(text)
                .font(Font.custom("TempleGemsRegular", size: 20))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.83, green: 0.85, blue: 1))
                .frame(width: 148, height: 42, alignment: .center)
                .offset(y: 2)
            
        }
    }
}

//MARK: Localization
extension HeartStatusView {
    var hearts: String {
        appLanguageManager.localizedStringForKey("HEARTS", language: appLanguageManager.currentLanguage)
    }
    
    var next_hearts: String {
        appLanguageManager.localizedStringForKey("NEXT_HEARTS", language: appLanguageManager.currentLanguage)
    }
    
    var okay: String {
        appLanguageManager.localizedStringForKey("OK", language: appLanguageManager.currentLanguage)
    }
    
    var fullHeart: String {
        appLanguageManager.localizedStringForKey("FULL", language: appLanguageManager.currentLanguage)
    }
    
    var lifetimeHearts: String {
        appLanguageManager.localizedStringForKey("LIFETIME_HEARTS", language: appLanguageManager.currentLanguage)
    }
    
    var weekHeart: String {
        appLanguageManager.localizedStringForKey("NEXT_WEEK", language: appLanguageManager.currentLanguage)
    }
    
    var freeHeart: String {
        appLanguageManager.localizedStringForKey("FREE_HEART", language: appLanguageManager.currentLanguage)
    }
    
    var unlimitedHearts: String {
        appLanguageManager.localizedStringForKey("UNLIMITED_HEARTS", language: appLanguageManager.currentLanguage)
    }

}

struct PurchaseButtonView: View {
    @EnvironmentObject var appLanguageManager: AppLanguageManager

    let type: SubscriptionType
    var body: some View {
        ZStack {
            Image("purchaseFrame")
                .resizable()
                .scaledToFit()
            
            subscriptionHStack()
        }
        .frame(width: 105)
        
    }
    @ViewBuilder
       private func subscriptionHStack() -> some View {
           HStack {
               icon
                   .padding(.leading, 10)
               
               text
                   .font(Font.custom("TempleGemsRegular", size: 12))
                   .lineSpacing(1)
                   .lineLimit(2)
                   .multilineTextAlignment(.leading)
                   .foregroundColor(textColor)
               
               Spacer()
           }
       }
       
       private var icon: Image {
           switch type {
           case .weekly:
               return Image("weeklyHeartIcon")
           case .lifetime:
               return Image("yearlyHeartIcon")
           }
       }
       
       private var text: Text {
           switch type {
           case .weekly:
               return Text(oneWeek)
           case .lifetime:
               return Text(lifeTime)
           }
       }
       
       private var textColor: Color {
           switch type {
           case .weekly:
               return Color(#colorLiteral(red: 0.68, green: 1, blue: 1, alpha: 1))
           case .lifetime:
               return Color(#colorLiteral(red: 1, green: 0.93, blue: 0.67, alpha: 1))
           }
       }
    
    var oneWeek: String {
        appLanguageManager.localizedStringForKey("ONE_WEEK", language: appLanguageManager.currentLanguage)
    }
    
    var lifeTime: String {
        appLanguageManager.localizedStringForKey("LIFE_TIME", language: appLanguageManager.currentLanguage)
    }
}
