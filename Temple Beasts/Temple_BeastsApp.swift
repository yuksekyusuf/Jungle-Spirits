//
//  Temple_BeastsApp.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 5/5/23.
//

import SwiftUI

@main
struct Temple_BeastsApp: App {
    init() {
        print("Screen height: ", UIScreen.main.bounds.height)
        print("Screen width: ", UIScreen.main.bounds.width)
    }
    
    var body: some Scene {
        WindowGroup {
            MenuView()
        }
    }
}
