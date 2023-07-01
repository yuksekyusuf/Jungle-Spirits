//
//  GameType.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 7.06.2023.
//

import Foundation

enum GameType: Identifiable {
    case ai
    case oneVone
    
    var id: Int {
        switch self {
        case .ai:
            return 1
        case .oneVone:
            return 2
        }
    }
}