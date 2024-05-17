//
//  HeartStatusView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 2.12.2023.
//

import SwiftUI
import RevenueCat

struct HeartStatusView: View {
    //    var heartCount: Int
    @EnvironmentObject var appLanguageManager: AppLanguageManager
    @EnvironmentObject var gameCenterManager: GameCenterManager
    @EnvironmentObject var heartManager: HeartManager
    @EnvironmentObject var userViewModel: UserViewModel
    
    @Binding var nextHeartTime: String
    @Binding var isPresent: Bool
    @State var newHeart = 0
    
    
    @State var currentOffering: Offering?
    
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
    
//    var rewardAd: RewardedAd
    
    init(nextHeartTime: Binding<String>, isPresent: Binding<Bool>) {
        //        self.heartCount = gameCenterManager.
        self._nextHeartTime = nextHeartTime // Use underscore to directly initialize @Binding properties
        self._isPresent = isPresent
//        self.rewardAd = RewardedAd()
//        rewardAd.load()
    }
    
    var body: some View {
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
            //            Button {
            //                withAnimation {
            //                    self.isPresent.toggle()
            //                }
            //            } label: {
            //                ZStack(alignment: .center) {
            //                    Rectangle()
            //                        .fill(Color(red: 0.48, green: 0.4, blue: 0.98))
            //                        .frame(width: 148, height: 42, alignment: .center)
            //                        .cornerRadius(14)
            //                        .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
            //                    Text(okay)
            //                        .font(Font.custom("TempleGemsRegular", size: 24))
            //                        .multilineTextAlignment(.center)
            //                        .foregroundColor(Color(red: 0.83, green: 0.85, blue: 1))
            //                        .frame(width: 148, height: 42, alignment: .center)
            //                        .offset(y: 2)
            //                }
            //
            //
            //            }
            //            .offset(y: 80)
            
            
            
            
            
            
            
            VStack(spacing: 6) {
                Text("\(heartManager.currentHeartCount) \(hearts.capitalizedSentence)")
                    .font(Font.custom("Watermelon", size: 32))
                    .kerning(0.96)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                if heartManager.currentHeartCount == 5 {
                    Text(fullHeart)
                        .font(Font.custom("Temple Gems", size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.84, green: 0.82, blue: 1))
                        .frame(width: 168, alignment: .center)
                } else {
                    Text("\(next_hearts) \(heartManager.timeUntilNextHeartString)")
                        .font(Font.custom("Temple Gems", size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.84, green: 0.82, blue: 1))
                        .frame(width: 168, alignment: .center)
                        .onAppear {
                            
                        }
                
                }
            
        
                
            }
            .offset(y: 2)
            .frame(width: 253, alignment: .center)
            if !(heartManager.currentHeartCount > 0) {
                Image("noHeart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 116)
                    .offset(y: -69)
            } else {
                Image("heartRemains")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 116)
                    .offset(y: -69)
            }
            
            VStack {
                if heartManager.currentHeartCount < 5 {
                    VStack(spacing: 0) {
                        Button {
                            SoundManager.shared.stopBackgroundMusic()
//                            self.rewardAd.showAd(rewardFunction: {
//                                gameCenterManager.remainingHearts += 1
//                            })
                        } label: {
                            ZStack(alignment: .center) {
                                Rectangle()
                                    .fill(Color(red: 0.48, green: 0.4, blue: 0.98))
                                    .frame(width: 221, height: 44, alignment: .center)
                                    .cornerRadius(14)
                                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
                                
                                Text("FREE LIFE")
                                    .font(Font.custom("TempleGemsRegular", size: 24))
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
                        
                        ShareButtonView()
                            .padding(.top, 10)
                        
                        
                    }
                    
                                        
                }
                
                
                if userViewModel.isSubscriptionActive == false {
                    if currentOffering != nil {
                        VStack(spacing: 0) {
                            HStack {
                                ForEach(currentOffering!.availablePackages) { pkg in
                                    Button(action: {
                                        Purchases.shared.purchase(package: pkg) { (transaction, customerInfo, error, userCancelled) in
                                          if customerInfo?.entitlements["Unlimited"]?.isActive == true {
                                              userViewModel.isSubscriptionActive = true
                                          }
                                        }
                                    }, label: {
                                        if pkg.identifier == "$rc_annual" {
                                            Image("lifeTime")
                                        } else if pkg.identifier == "$rc_weekly" {
                                            Image("oneWeekLife")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 48)
                                        }
                                        
                                    })
                                    
                                }
                          
                                    
                            }
                        }
                    }
                }
                

                Button(action: {
                    self.isPresent.toggle()
                }, label: {
                    Image("closeTab")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75)
                })
//                .offset(y: -90)

            }
            .offset(y: 170)
            
            
        }
        .onAppear {
            Purchases.shared.getOfferings { offerings, error in
                if let offer = offerings?.current, error == nil {
                    currentOffering = offer
                }
            }
        }
        
    }
    
    //    func localizedStringForKey(_ key: String, language: String) -> String {
    //        let path = Bundle.main.path(forResource: language, ofType: "lproj")
    //        let bundle = Bundle(path: path!)
    //        return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: "", comment: "")
    //    }
}
//
struct HeartStatusView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPresentTrue = true
        @State var remainingTime = "9:27"
        HeartStatusView(nextHeartTime: $remainingTime, isPresent: $isPresentTrue).environmentObject(AppLanguageManager()).environmentObject(GameCenterManager(currentPlayer: .player1))
//            .environmentObject(HeartManager())
        
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
        // Update code here if needed
    }
}