//
//  Move.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 12.09.2023.
//

import Foundation


struct Move {
    let source: (row: Int, col: Int)
    let destination: (row: Int, col: Int)
    static func == (lhs: Move, rhs: Move) -> Bool {
        return lhs.source == rhs.source && lhs.destination == rhs.destination
    }
    
    static func fromCodable(_ codableMove: CodableMove) -> Move {
        return Move(source: (row: codableMove.source.row, col: codableMove.source.col),
                    destination: (row: codableMove.destination.row, col: codableMove.destination.col))
    }
}

struct CodableMove: Codable {
    let source: Coordinate
    let destination: Coordinate
    static func fromMove(_ move: Move) -> CodableMove {
        return CodableMove(source: Coordinate(row: move.source.row, col: move.source.col),
                           destination: Coordinate(row: move.destination.row, col: move.destination.col))
    }
}

struct Coordinate: Codable {
    var row: Int
    var col: Int
}




