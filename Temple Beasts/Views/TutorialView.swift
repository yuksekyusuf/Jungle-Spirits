//
//  TutorialVIew.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 21.02.2024.
//

import SwiftUI

struct TutorialView: View {
    @StateObject private var board = Board(tutorialSize: (rows: 7, columns: 5), tutorialStep: .clonePiece)
    @State private var selectedCell: (row: Int, col: Int)? = nil
    @State  var convertedCells: [(row: Int, col: Int, byPlayer: CellState)] = []
    @State  var previouslyConvertedCells: [(row: Int, col: Int, byPlayer: CellState)] = []
    @State private var moveMade: Bool = false
    @State private var currentlyPressedCell: (row: Int, col: Int)? = nil
    
    
    private var selectText: String {
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
    
    private var taskText: String {
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
                    //                    Spacer()
                    //                    Spacer()
                    
                    
                    //                    Spacer()
                    VStack(spacing: 0) {
                        VStack {
                            Text(selectText).font(.custom("Watermelon", size: 28)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                            Text(taskText).font(.custom("Watermelon", size: 24)).foregroundColor(Color(#colorLiteral(red: 1, green: 0.91, blue: 0.44, alpha: 1))).multilineTextAlignment(.center)
                                .padding(
                                    .top, 1)
                        }
                        .padding(.bottom, 30)
                        HStack {
                            Spacer()
                            VStack(spacing: 0) {
                                ForEach(0..<board.size.rows, id: \.self) { row in
                                    HStack(spacing: 0) {
                                        ForEach(0..<board.size.columns, id: \.self) { col in
                                            CellView(state: board.cellState(at: (row: row, col: col)), isSelected: selectedCell != nil && selectedCell! == (row: row, col: col), highlighted: selectedCell != nil && isAdjacentToSelectedCell(row: row, col: col), outerHighlighted: selectedCell != nil && isOuterToSelectedCell(row: row, col: col), width: cellSize, isPressed: isCellPressed(row: row, col: col), convertedCells:  $convertedCells, previouslyConvertedCells: $previouslyConvertedCells, cellPosition: (row: row, col: col), moveMade: $moveMade)
                                                .frame(width: cellSize, height: cellSize)
                                                .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                                                    if pressing {
                                                        self.currentlyPressedCell = (row, col)
                                                    } else {
                                                        self.handleCellTap(at: (row: row, col: col))
                                                        HapticManager.shared.impact(style: .soft)
                                                        self.currentlyPressedCell = nil
                                                    }
                                                }, perform: { })
                                            
                                        }
                                        
                                    }
                                }
                            }
                            //                            .frame(maxWidth: boardWidth, minHeight: boardWidth, maxHeight: geometry.size.height * 0.7)
                            Spacer()
                        }
                    }
                    
                    //                    Spacer()
                    Button {
                        //                        requestReview()
                        
                    } label: {
                        ButtonView(text: "NEXT", width: 200, height: 50)
                            .padding(.top, 25)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onAppear {
            board.setupTutorialBoard(for: .clonePiece)
        }
    }

    
    private func isAdjacentToSelectedCell(row: Int, col: Int) -> Bool {
        guard let selected = selectedCell else { return false }
        let deltaRow = abs(selected.row - row)
        let deltaCol = abs(selected.col - col)
        return (deltaRow <= 1 && deltaCol <= 1) && !(deltaRow == 0 && deltaCol == 0)
    }
    
    private func isOuterToSelectedCell(row: Int, col: Int) -> Bool {
        guard let selected = selectedCell else { return false }
        let deltaRow = abs(selected.row - row)
        let deltaCol = abs(selected.col - col)
        
        if (deltaRow == 2 && deltaCol == 0) || (deltaRow == 0 && deltaCol == 2) {
            return true
        }
        if (deltaRow == 1 && deltaCol == 2) || (deltaRow == 2 && deltaCol == 1) {
            return true
        }
        return false
    }
    
    private func isCellPressed(row: Int, col: Int) -> Bool {
        if let pressedCell = currentlyPressedCell, pressedCell == (row, col) {
            return true
        }
        return false
    }
    
    private func handleCellTap(at destionation: (row: Int, col: Int)) {
        if let source = selectedCell, source == destionation {
            selectedCell = nil
            return
        }
        guard let source = selectedCell else {
            if board.cellState(at: destionation) == .player1 {
                selectedCell = destionation
            }
            return
        }
        
        let moveSuccessful = board.performTutorialMove(from: source, to: destionation)
        if moveSuccessful {
            selectedCell = nil
            moveToNextTutorialStep()
            self.moveMade.toggle()
        } else {
            // If the move wasn't successful, provide feedback.
                    // SoundManager.shared.playErrorSound() // Uncomment or modify if you have a sound manager.
                    // HapticManager.shared.triggerErrorFeedback() // Uncomment or modify if you have a haptic manager.
                    
                    // Keep the current cell selected for a possible retry.
                    // You can also handle this differently, for example by resetting the selected cell or showing an error message.
        }
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
    private func moveToNextTutorialStep() {
        switch board.tutorialStep {
        case .clonePiece:
            board.setupTutorialBoard(for: .teleportPiece)
        case .teleportPiece:
            board.setupTutorialBoard(for: .convertPiece)
        case .convertPiece:
            board.setupTutorialBoard(for: .complextConvert)
        case .complextConvert:
            print("DONE")
        case .none:
            break
            
            
            
            // This function should determine what the next step is and set up the board for that step.
            // For instance, it could increment an index and call `board.setupTutorialStep` with the new step.
            // If it's the last step of the tutorial, it could perform cleanup or navigate to the main menu.
            // Implement this based on your tutorial steps and game logic.
        }
        
    }
}

#Preview {
    TutorialView()
}
