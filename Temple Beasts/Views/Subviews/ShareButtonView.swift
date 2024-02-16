//
//  TestLink.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 16.02.2024.
//

import SwiftUI
import UIKit

struct ShareButtonView: View {
    @EnvironmentObject var gameCenterManager: GameCenterManager
    @EnvironmentObject var appLanguageManager: AppLanguageManager
    var share: String {
        appLanguageManager.localizedStringForKey("SHARE", language: appLanguageManager.currentLanguage)
    }

    var body: some View {
        Button(action: {
                    shareApp()
                }) {
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(Color(red: 0.48, green: 0.4, blue: 0.98))
                            .frame(width: 221, height: 44, alignment: .center)
                            .cornerRadius(14)
                            .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
                        
                        Text(share)
                            .font(Font.custom("TempleGemsRegular", size: 24))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.83, green: 0.85, blue: 1))
                            .frame(width: 148, height: 42, alignment: .center)
                            .offset(y: 2)
                        Image("plusTwoHearts")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .offset(x: 80)
                    }
                }
    }
    
    private func shareApp() {
        guard let appStoreURL = URL(string: "https://apps.apple.com/us/app/temple-gems/id6450963181") else { return }
                
                let activityViewController = UIActivityViewController(activityItems: [appStoreURL], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                
        activityViewController.completionWithItemsHandler = { activityType, completed, _, error in
                    if completed && error == nil {
                        // Share completed successfully, grant the reward
//                        self.grantReward()
                        if gameCenterManager.remainingHearts <= 3 {
                            self.gameCenterManager.remainingHearts += 2
                        } else {
                            self.gameCenterManager.remainingHearts += 1
                            
                        }
                        let hearts = gameCenterManager.remainingHearts
                        UserDefaults.standard.setValue(hearts, forKey: "hearts")
                    } else {
                        // Handle share cancellation or error
                        if let activityType = activityType {
                            print("Share cancelled by user for activity type: \(activityType)")
                        }
                        if let error = error {
                            print("Share error: \(error.localizedDescription)")
                        }
                    }
                }
        
        }
}

#Preview {
    ShareButtonView()
}
