//
//  CellState.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 12.09.2023.
//

import Foundation

enum CellState: Int, Codable, Equatable {
    case empty
    case player1
    case player2
    case draw
    case initial
    func opposite() -> CellState {
        switch self {
        case .player1:
            return .player2
        case .player2:
            return .player1
        default:
            return .empty
        }
    }
}
