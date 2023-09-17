//
//  HowToPlayView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 2.08.2023.
//

import SwiftUI

struct HowToPlayView: View {
    @EnvironmentObject var gameCenterManager: GameCenterManager
    @EnvironmentObject var appLanguageManager: AppLanguageManager
    @State var selectedTab = 0
    @AppStorage("shownHowToPlay") var howToPlayShown: Bool = false
    
    func localizedStringForKey(_ key: String, language: String) -> String {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    
    var howToPlay: String {
        localizedStringForKey("HOW_TO_PLAY_TITLE", language: appLanguageManager.currentLanguage)
    }
    
    var next: String {
        localizedStringForKey("NEXT", language: appLanguageManager.currentLanguage)
    }
    
    var gotIt: String {
        localizedStringForKey("GOT_IT", language: appLanguageManager.currentLanguage)
    }
    
    var selectAGemTitle: String {
        localizedStringForKey("SELECTING_A_GEM_TITLE", language: appLanguageManager.currentLanguage)
    }
    
    
    var selectAGemDesc: String {
        localizedStringForKey("SELECTING_A_GEM_DESC", language: appLanguageManager.currentLanguage)
    }
    
    var cloninTitle: String {
        localizedStringForKey("CLONING_TITLE", language: appLanguageManager.currentLanguage)
    }
    
    var cloninDesc: String {
        localizedStringForKey("CLONING_DESC", language: appLanguageManager.currentLanguage)
    }
    
    var teleTitle: String {
        localizedStringForKey("TELEPORTATION_TITLE", language: appLanguageManager.currentLanguage)
    }
    
    var teleDesc: String {
        localizedStringForKey("TELEPORTATION_DESC", language: appLanguageManager.currentLanguage)
    }
    
    var convTitle: String {
        localizedStringForKey("CONVERTING_ENEMIES_TITLE", language: appLanguageManager.currentLanguage)
    }
    
    var convDesc: String {
        localizedStringForKey("CONVERTING_ENEMIES_DESC", language: appLanguageManager.currentLanguage)
    }
    
    var objTitle: String {
        localizedStringForKey("OBJECTIVE_TITLE", language: appLanguageManager.currentLanguage)
    }
 
    var objDesc: String {
        localizedStringForKey("OBJECTIVE_DESC", language: appLanguageManager.currentLanguage)
    }
    
    
    var body: some View {
            VStack {
                if UserDefaults.standard.howToPlayShown {
                    HStack(alignment: .center) {
                        Button {
                            gameCenterManager.path.removeAll()
                        } label: {
                            Image("Left Arrow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 55)
                        }
                        Text(howToPlay)
                            .foregroundColor(.white)
                            .font(Font.custom("TempleGemsRegular", size: 28))
                            .padding(.leading, 30)
                    }
                    .padding(.trailing, 80)
                    .padding(.top, 20)
                } else {
                    Text(howToPlay)
                        .foregroundColor(.white)
                        .font(Font.custom("TempleGemsRegular", size: 28))
                        .padding(.top, 20)
                }
                Spacer()
                TabView(selection: $selectedTab) {
                    InfoTabView(title: selectAGemTitle, description: selectAGemDesc, image1: "SelectAGem 1", image2: "SelectAGem 2")
                        .tag(0)

                    InfoTabView(
                            title: cloninTitle,
                            description: cloninDesc,
                            image1: "Cloning 1", image2: "Cloning 2")
                        .tag(1)
                    
                    InfoTabView(
                            title: teleTitle,
                            description: teleDesc,
                            image1: "Teleport 1", image2: "Teleport 2")
                        .tag(2)
                    
                    InfoTabView(
                            title: convTitle,
                            description: convDesc,
                            image1: "Converting 1", image2: "Converting 2")
                        .tag(3)
                    
                    InfoTabView(
                           title: objTitle,
                           description: objDesc,
                           image1: "Objective 1", image2: "Objective 2")
                       .tag(4)
                }
                .frame(height: UIScreen.main.bounds.height * 0.6)
                .padding(.bottom, 30)
                .tabViewStyle(PageTabViewStyle())
                if selectedTab < 4 {
                    Button {
                        withAnimation(.easeInOut) {
                            selectedTab+=1
                        }
                    } label: {
//                        Image("NextButton")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 167)
                        
                        ButtonView(text: next, width: 167, height: 50)
                            .padding(.bottom, 20)
                    }
                } else {
                    Button {
                        withAnimation {
                            UserDefaults.standard.howToPlayShown = true

                            gameCenterManager.path.removeAll()
                        }
                    } label: {
                        ButtonView(text: gotIt, width: 167, height: 50)
//                        Image("GotIt")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 167)
                            .padding(.bottom, 20)
                    }
                }
            }
            .background {
                Image("purebackground")
                    .resizable()
                    .scaledToFill()
                    .frame(height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            }
            .navigationBarHidden(true)
    }
    
//    func localizedAssetName(baseName: String, index: Int) -> String {
//           return "\(baseName) \(appLanguageManager.currentLanguage) \(index)"
//       }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
    }
}

extension UserDefaults {
    var howToPlayShown: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "shownHowToPlay") as? Bool) ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "shownHowToPlay")
        }
    }
}
