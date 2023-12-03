//
//  Level.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 10.11.2023.
//

import Foundation


enum GameLevel: Int, CaseIterable {
    case level1_1 = 1, level1_2, level1_3, level1_4, level1_5, level1_6, level1_7
    case level2_1 = 8, level2_2, level2_3, level2_4, level2_5, level2_6, level2_7
    case level3_1 = 15, level3_2, level3_3, level3_4, level3_5, level3_6, level3_7
    case level4_1 = 22, level4_2, level4_3, level4_4, level4_5, level4_6, level4_7
    
    var id: Int {
        return self.rawValue
    }

    var boardSize: (rows: Int, cols: Int) {
        switch self {
        case .level1_1: return (4, 3)
        case .level1_2: return (5, 5)
        case .level1_3:
            return (6, 4)
        case .level1_4:
            return (8, 5)
        case .level1_5:
            return (7, 5)
        case .level1_6:
            return (8, 6)
        case .level1_7:
            return (9, 6)
        case .level2_1:
            return (8, 5)
        case .level2_2:
            return (8, 5)
        case .level2_3:
            return (8, 5)
        case .level2_4:
            return (8, 5)
        case .level2_5:
            return (8, 5)
        case .level2_6:
            return (8, 5)
        case .level2_7:
            return (8, 5)
        case .level3_1:
            return (8, 5)
        case .level3_2:
            return (8, 5)
        case .level3_3:
            return (8, 5)
        case .level3_4:
            return (8, 5)
        case .level3_5:
            return (8, 5)
        case .level3_6:
            return (8, 5)
        case .level3_7:
            return (8, 5)
        case .level4_1:
            return (8, 5)
        case .level4_2:
            return (8, 5)
        case .level4_3:
            return (8, 5)
        case .level4_4:
            return (8, 5)
        case .level4_5:
            return (8, 5)
        case .level4_6:
            return (8, 5)
        case .level4_7:
            return (8, 5)
        }
    }

    var obstacles: [(Int, Int)] {
        switch self {
        case .level1_1:
            return []
        case .level1_2:
            return []
        case .level1_3:
            return []
        case .level1_4:
            return [(3, 1), (3, 3)]
        case .level1_5:
            return [(2, 1), (2, 4), (5, 1), (5, 4)]
        case .level1_6:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]
        case .level1_7:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level2_1:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level2_2:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level2_3:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level2_4:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level2_5:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level2_6:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level2_7:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level3_1:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level3_2:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level3_3:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level3_4:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level3_5:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level3_6:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level3_7:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level4_1:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level4_2:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level4_3:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level4_4:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level4_5:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level4_6:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        case .level4_7:
            return [(3, 2), (5, 3), (4, 1), (4, 4)]

        }
    }

    var next: GameLevel? {
        let allLevels = GameLevel.allCases
        guard let currentIndex = allLevels.firstIndex(of: self) else { return nil }
        let nextIndex = allLevels.index(after: currentIndex)
        return nextIndex < allLevels.endIndex ? allLevels[nextIndex] : nil
    }
}

enum GameLevelBundle: Int, CaseIterable {
    case bundle1 = 1
    case bundle2 = 2
    case bundle3 = 3
    case bundle4 = 4
    
    var levels: [GameLevel] {
        switch self {
        case .bundle1:
            return Array(GameLevel.level1_1.rawValue...GameLevel.level1_7.rawValue).compactMap(GameLevel.init)
        case .bundle2:
            return Array(GameLevel.level2_1.rawValue...GameLevel.level2_7.rawValue).compactMap(GameLevel.init)
        case .bundle3:
            return Array(GameLevel.level3_1.rawValue...GameLevel.level3_7.rawValue).compactMap(GameLevel.init)
        case .bundle4:
            return Array(GameLevel.level4_1.rawValue...GameLevel.level4_7.rawValue).compactMap(GameLevel.init)
        }
    }
    
    
    var id: Int {
        return self.rawValue
    }
}
