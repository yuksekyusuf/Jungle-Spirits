//
//  TestPlayerView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 19.10.2023.
//

import SwiftUI

struct TestPlayerView: View {
//    var player: CellState // Assuming you have a player enum or similar
    @Binding var startingCell: (row: Int, col: Int)?
    @Binding var endingCell: (row: Int, col: Int)?
    let cellWidth: CGFloat
    var currentCell: (row: Int, col: Int)

    var body: some View {
        Circle()
            .fill(.red) // Assuming you have a color for each player
            .scaleEffect(isMoving ? 0.5 : 1) // Shrinking effect
            .offset(isMoving ? getOffset() : CGSize(width: 0, height: 0)) // Moving effect
            .animation(.easeInOut(duration: 0.5), value: isMoving)
    }

    var isMoving: Bool {
        if let startingCell = startingCell {
            return startingCell == currentCell
        } else {
            return false
        }
    }

    func getOffset() -> CGSize {
        // Calculate the offset based on the difference between the startingCell and endingCell
        // This is just a rough idea. You might need to adjust this based on your actual cell sizes and spacings.
        guard let start = startingCell, let end = endingCell else { return CGSize(width: 0, height: 0) }
        let dx = CGFloat(end.col - start.col) * (cellWidth + 1.0)
        let dy = CGFloat(end.row - start.row) * (cellWidth + 1.0)
        return CGSize(width: dx, height: dy)
    }
}

//struct TestPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestPlayerView()
//    }
//}
