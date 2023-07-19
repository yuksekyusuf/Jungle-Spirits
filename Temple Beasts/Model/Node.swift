//
//  Node.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 24.06.2023.
//

import Foundation

class Node {
    var move: Move // The move that got us to this node
    var parent: Node?
    var children: [Node] = []
    var wins: Int = 0
    var simulations: Int = 0
    var untriedMoves: [Move]
    var player: CellState // The player who just played

    init(move: Move, parent: Node? = nil, untriedMoves: [Move], player: CellState) {
        self.move = move
        self.parent = parent
        self.untriedMoves = untriedMoves
        self.player = player
    }

    // Use this function to select a child node
    func UCTSelectChild() -> Node? {
        var bestScore = -1.0
        var bestChild: Node?

        for child in children {
            var uctValue = 0.0
            if child.simulations > 0 {
                let winRate = Double(child.wins) / Double(child.simulations)
                let exploration = sqrt(2.0 * log(Double(self.simulations)) / Double(child.simulations))
                uctValue = winRate + exploration
            }

            // Update best score and child if this node's uctValue is larger
            if uctValue > bestScore {
                bestScore = uctValue
                bestChild = child
            }
        }
        return bestChild
    }

    // Use this function to add a new child node to this node
    func addChild(move: Move, state: Board) -> Node {
        let node = Node(move: move, parent: self, untriedMoves: state.getMoves(), player: state.currentPlayerForAi)
        self.untriedMoves.removeAll(where: { $0 == move })
        self.children.append(node)
        return node
    }

    // Use this func to update the node's stats after a simulation
    func update(result: Int) {
        self.simulations += 1
        self.wins += result
    }
}

