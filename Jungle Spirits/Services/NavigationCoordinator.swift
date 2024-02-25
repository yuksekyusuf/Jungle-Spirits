//
//  NavigationCoordinator.swift
//  Jungle Spirits
//
//  Created by Ahmet Yusuf Yuksek on 24.02.2024.
//

import Foundation
import SwiftUI

enum Destination {
    case tutorialPage
    case gamePage
}

//class NavigationCoordinator: ObservableObject {
//    @Published var path = NavigationPath()
//    
//    func gotoHomePage() {
//        path.removeLast(path.count)
//    }
//    func tapOnEnter() {
//        path.append(Destination.tutorialPage)
//    }
//    
//    func tapOnFirstPage() {
//        path.append(Destination.gamePage)
//    }
//    func tapOnSecondPage() {
//        path.removeLast()
//    }
//    
//}
