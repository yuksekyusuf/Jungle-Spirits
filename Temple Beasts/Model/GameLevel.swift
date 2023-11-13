//
//  Level.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 10.11.2023.
//

import Foundation


enum GameLevel: Int {
    case level1 = 1
    case level2 = 2
    case level3 = 3
    case level4 = 4
    case level5 = 5
    case level6 = 6
    case level7 = 7
    
    var id: Int {
            switch self {
            case .level1: return 1
            case .level2: return 2
            case .level3: return 3
            case .level4: return 4
            case .level5: return 5
            case .level6: return 6
            case .level7: return 7
            }
        }

    var boardSize: (rows: Int, cols: Int) {
        switch self {
        case .level1: return (4, 3)
        case .level2: return (5, 4)
        case .level3: return (6, 4)
        case .level4: return (8, 5)
        case .level5: return (7, 5)
        case .level6: return (8, 6)
        case .level7: return (9, 6)
        }
    }

    var obstacles: [(Int, Int)] {
        switch self {
        case .level1: return []
        case .level2: return []
        case .level3: return []
        case .level4: return []
        case .level5: return [(3, 1), (3, 3)]
        case .level6: return [(2, 1), (2, 4), (5, 1), (5, 4)]
        case .level7: return [(3, 2), (5, 3), (4, 1), (4, 4)]
        }
    }
    
    var next: GameLevel? {
           return GameLevel(rawValue: self.rawValue + 1)
       }
}
