//
//  TutorialVIew.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 21.02.2024.
//

import SwiftUI

struct TutorialView: View {
    @StateObject private var board = Board(tutorialSize: (rows: 7, columns: 5), tutorialStep: .teleportPiece)

    @State private var selectedCell: (row: Int, col: Int)? = nil
    
    @State  var convertedCells: [(row: Int, col: Int, byPlayer: CellState)] = []
    @State  var previouslyConvertedCells: [(row: Int, col: Int, byPlayer: CellState)] = []
    @State private var moveMade: Bool = false
    
    var selectText: String {
        switch board.tutorialStep {
        case .clonePiece:
            return "Select the spirit"
        case .teleportPiece:
            return "Select the spirit"
        case .convertPiece:
            return "You’re getting it!"
        case .complextConvert:
            return "One more time!"
        case .none:
            return ""
        }
    }
    
    var taskText: String {
        switch board.tutorialStep {
        case .clonePiece:
            return "Then clone yourself"
        case .teleportPiece:
            return "Then teleport yourself"
        case .convertPiece:
            return "Convert the blue to red"
        case .complextConvert:
            return "Convert the blue to red"
        case .none:
            return ""
        }
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            let cellSize = self.calculateCellSize(geometry: geometry)
            let boardWidth = cellSize * CGFloat(self.board.size.columns)
            ZStack{
                Image("tutorialBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(height: geometry.size.height)
                VStack {
                    //Select the spirit
                    Spacer()
                    Spacer()

                    VStack {
                        Text(selectText).font(.custom("Watermelon", size: 28)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                        //Then teleport yourself
                        Text("Then teleport yourself").font(.custom("Watermelon", size: 24)).foregroundColor(Color(#colorLiteral(red: 1, green: 0.91, blue: 0.44, alpha: 1))).multilineTextAlignment(.center)
                            .padding(
                                .top, 1)
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 0) {
                            ForEach(0..<board.size.rows, id: \.self) { row in
                                HStack(spacing: 0) {
                                    ForEach(0..<board.size.columns, id: \.self) { col in
                                        CellView(state: board.cellState(at: (row: row, col: col)), isSelected: selectedCell != nil && selectedCell! == (row: row, col: col), highlighted: selectedCell != nil && isAdjacentToSelectedCell(row: row, col: col), outerHighlighted: selectedCell != nil && isOuterToSelectedCell(row: row, col: col), width: cellSize, isPressed: isCellPressed(row: row, col: col), convertedCells:  $convertedCells, previouslyConvertedCells: $previouslyConvertedCells, cellPosition: (row: row, col: col), moveMade: $moveMade)
                                            .frame(width: cellSize, height: cellSize)

                                    }
                                    
                                }
                            }
                        }.frame(maxWidth: boardWidth, minHeight: boardWidth, maxHeight: geometry.size.height * 0.7)
                        Spacer()
                    }
                    Spacer()
                    Button("NEXT") {
                        //
                    }
                    .frame(width: 178, height: 28)

                    Spacer()
                }
                
                

            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onAppear {
            board.setupTutorialBoard(for: .teleportPiece)
        }
    }
    private func onMoveCompleted(move: Move) {
        print("Do sth")
    }
    
    private func isAdjacentToSelectedCell(row: Int, col: Int) -> Bool {
            // Implement logic to determine if the cell is adjacent to the selected cell for highlighting purposes.
            // This depends on your game's logic.\
        return false
        }
        
        private func isOuterToSelectedCell(row: Int, col: Int) -> Bool {
            // Implement logic to determine if the cell is in the outer range from the selected cell for highlighting purposes.
            // This depends on your game's logic.
            return false

        }
        
        private func isCellPressed(row: Int, col: Int) -> Bool {
            // Implement logic to determine if the cell is pressed.
            // This depends on your game's logic.
            return false

        }
        
        private func handleCellTap(row: Int, col: Int) {
            // Implement what should happen when a cell is tapped.
            // This could include selecting the cell, performing a move, or showing an error.
            
        }
    private func calculateCellSize(geometry: GeometryProxy) -> CGFloat {
        let maxCellWidth = geometry.size.width * 0.175
        let availableWidth = geometry.size.width * 0.90
        let maxWidthBasedCellSize = min(maxCellWidth, availableWidth / CGFloat(board.size.columns))

        let maxBoardHeight = geometry.size.height * 0.75
        let maxHeightBasedCellSize = maxBoardHeight / CGFloat(board.size.rows)

        var cellWidth = max(maxWidthBasedCellSize, maxHeightBasedCellSize)

        if cellWidth * CGFloat(board.size.columns) > availableWidth {
            cellWidth = availableWidth / CGFloat(board.size.columns)
        } else if cellWidth * CGFloat(board.size.rows) > maxBoardHeight {
            cellWidth = maxBoardHeight / CGFloat(board.size.rows)
        }

        return cellWidth
    }
}

#Preview {
    TutorialView()
}
