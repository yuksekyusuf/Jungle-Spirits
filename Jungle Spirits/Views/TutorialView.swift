//
//  TutorialVIew.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 21.02.2024.
//

import SwiftUI
class TutorialViewModel: ObservableObject {
    @Published var board: Board
    @Published var selectedCell: (row: Int, col: Int)? = nil
    @Published var convertedPieces: [(row: Int, col: Int, byPlayer: CellState)] = []
    @Published var previouslyConvertedPieces: [(row: Int, col: Int, byPlayer: CellState)] = []
    @Published var currentlyPressedCell: (row: Int, col: Int)? = nil
    @Published var taskDone: Bool = false
    @Published var invalidMove: Bool = false
    @Published var navigateToGame: Bool = false
    @Published var version = UUID()
    @Published var tutorialGuide: Bool = true

    private var gameCenterManager: GameCenterManager
    
    init(gameCenterManager: GameCenterManager) {
        self.board = Board(tutorialSize: (rows: 7, columns: 5), tutorialStep: .clonePiece)
        self.gameCenterManager = gameCenterManager
    }
    
    func setupBoard(for step: TutorialStep) {
        board.setupTutorialBoard(for: step)
        self.objectWillChange.send()
    }
    
    func refreshView() {
            version = UUID() // Changing this will force SwiftUI to update the view
        }
    
    func handleCellTap(at destination: (row: Int, col: Int)) {
        if let source = selectedCell, source == destination {
            selectedCell = nil
            return
        }
        guard let source = selectedCell else {
            if board.cellState(at: destination) == .player1 {
                selectedCell = destination
            }
            return
        }

            let moveSuccessful = board.performTutorialMove(from: source, to: destination)

            if moveSuccessful {
                SoundManager.shared.playMoveSound()

                    HapticManager.shared.notification(type: .success)
                if board.tutorialStep == .complextConvert {
                    tutorialGuide = true
                }
                taskDone = true
                selectedCell = nil
                invalidMove = false
            } else {
                guard let tutorialStep = board.tutorialStep else { return }
                let convertedCells = board.convertedCells
//                if !convertedCells.isEmpty {
//                    SoundManager.shared.playConvertSound()
//                    HapticManager.shared.notification(type: .success)
//                    for piece in convertedCells {
//                        self.convertedPieces.append((row: piece.row, col: piece.col, byPlayer: .player1))
//                        self.previouslyConvertedPieces.append((row: piece.row, col: piece.col, byPlayer: .player1))
//                    }
//                }
                if tutorialStep != .complextConvert {
                    HapticManager.shared.notification(type: .error)
                    withAnimation(.default.repeatCount(3, autoreverses: true)) {
                        invalidMove = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.selectedCell = nil
                        self.board.setupTutorialBoard(for: tutorialStep)
                        self.invalidMove = false
                    }
                } else {
                    SoundManager.shared.playMoveSound()
                    selectedCell = nil
                }
                
            }
        let convertedCells = board.convertedCells
        for piece in convertedCells {
            self.convertedPieces.append((row: piece.row, col: piece.col, byPlayer: .player1))
            self.previouslyConvertedPieces.append((row: piece.row, col: piece.col, byPlayer: .player1))
        }
        if !previouslyConvertedPieces.isEmpty {
            SoundManager.shared.playConvertSound()
            HapticManager.shared.notification(type: .success)

        }
    }
    
    func moveToNextTutorialStep(storyMode: Bool) {
        switch board.tutorialStep {
        case .clonePiece:
            taskDone = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation {
                    self.setupBoard(for: .teleportPiece)
                }
            }
        case .teleportPiece:
            taskDone = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation {
                    self.setupBoard(for: .convertPiece)
                }            }
        case .convertPiece:
            taskDone = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation {
                    self.setupBoard(for: .complextConvert)
//                    self.previouslyConvertedPieces.removeAll()
                    self.board.convertedCells.removeAll()
                }            }
        case .complextConvert:
            break
//            if storyMode {
//                if gameCenterManager.currentLevel == gameCenterManager.achievedLevel {
//                    guard let nextLevel = gameCenterManager.currentLevel else { return }
//                    let nextLevelId = nextLevel.id + 1
//                    gameCenterManager.achievedLevel = GameLevel(rawValue: nextLevelId) ?? gameCenterManager.achievedLevel
//                    UserDefaults.standard.setValue(nextLevelId, forKey: "achievedLevel")
//                }
//                self.navigateToGame = true
//            } else {
////                navCoordinator.gotoHomePage()
//                gameCenterManager.path = NavigationPath()
//            }
        case .none:
            break
        }
    }
    //MARK: - HELPER METHODS
    func isAdjacentToSelectedCell(row: Int, col: Int) -> Bool {
        guard let selected = selectedCell else { return false }
        let deltaRow = abs(selected.row - row)
        let deltaCol = abs(selected.col - col)
        return (deltaRow <= 1 && deltaCol <= 1) && !(deltaRow == 0 && deltaCol == 0)
    }
    
    func isOuterToSelectedCell(row: Int, col: Int) -> Bool {
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
    func isCellPressed(row: Int, col: Int) -> Bool {
        if let pressedCell = currentlyPressedCell, pressedCell == (row, col) {
            return true
        }
        return false
    }
    
    func calculateCellSize(geometry: GeometryProxy) -> CGFloat {
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


struct TutorialView: View {
    @EnvironmentObject var appLanguageManager: AppLanguageManager
    @EnvironmentObject var gameCenterManager: GameCenterManager
    @StateObject var tutorialViewModel: TutorialViewModel
    
    let storyMode: Bool
    
    init(gameCenterManager: GameCenterManager, storyMode: Bool) {
        _tutorialViewModel = StateObject(wrappedValue: TutorialViewModel(gameCenterManager: gameCenterManager))
        self.storyMode = storyMode
    }
    
    var body: some View {
        GeometryReader { geometry in
            let cellSize = tutorialViewModel.calculateCellSize(geometry: geometry)
            ZStack{
                Image("tutorialBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(height: geometry.size.height)
               
                VStack {
                    VStack(spacing: 0) {
                        VStack {
                            Text(selectText).font(.custom("Watermelon", size: 28)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                            Text(taskText).font(.custom("Watermelon", size: 24)).foregroundColor(Color(taskColor)).multilineTextAlignment(.center)
                                .padding(
                                    .top, 1)
                        }
                        .padding(.bottom, 30)
                        .opacity(tutorialViewModel.tutorialGuide ? 0 : 1)
                        HStack {
                            Spacer()
                            VStack(spacing: 0) {
                                ForEach(0..<tutorialViewModel.board.size.rows, id: \.self) { row in
                                    HStack(spacing: 0) {
                                        ForEach(0..<tutorialViewModel.board.size.columns, id: \.self) { col in
                                            CellView(state: tutorialViewModel.board.cellState(at: (row: row, col: col)), isSelected: tutorialViewModel.selectedCell != nil && tutorialViewModel.selectedCell! == (row: row, col: col), highlighted: tutorialViewModel.selectedCell != nil && tutorialViewModel.isAdjacentToSelectedCell(row: row, col: col), outerHighlighted: tutorialViewModel.selectedCell != nil && tutorialViewModel.isOuterToSelectedCell(row: row, col: col), width: cellSize, isPressed: tutorialViewModel.isCellPressed(row: row, col: col), convertedCells:  $tutorialViewModel.convertedPieces, previouslyConvertedCells: $tutorialViewModel.previouslyConvertedPieces, isShaking: $tutorialViewModel.invalidMove, cellPosition: (row: row, col: col))
                                                .frame(width: cellSize, height: cellSize)
                                                .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                                                    if pressing {
                                                        tutorialViewModel.currentlyPressedCell = (row, col)
                                                    } else {
                                                        tutorialViewModel.handleCellTap(at: (row: row, col: col))
                                                        HapticManager.shared.impact(style: .soft)
                                                        tutorialViewModel.currentlyPressedCell = nil
                                                    }
                                                }, perform: {})
//                                                .disabled(tutorialViewModel.taskDone)

                                            
                                        }
                                        
                                    }
                                }
                            }
                            .id(tutorialViewModel.version)
                            Spacer()
                        }
                        
                    }
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            if tutorialViewModel.board.tutorialStep != .convertPiece{
                                tutorialViewModel.moveToNextTutorialStep(storyMode: storyMode)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        tutorialViewModel.tutorialGuide.toggle()

                                    }
                                }
                            } else {
                                tutorialViewModel.moveToNextTutorialStep(storyMode: storyMode)
                            }
                            
                            
                        }
                        
                    } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 50)
                                    .fill(LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: Color("ButtonColor"), location: 0),
                                            .init(color: Color("ButtonColor"), location: 1)]),
                                        startPoint: UnitPoint(x: 1.001960580351438, y: 0.4999984904828132),
                                        endPoint: UnitPoint(x: 0.001960653828999348, y: 0.4999989975336838)).shadow(.inner(color: Color("ShadowColor"), radius: 0, x: 0, y: -3)))
                                    .background(
                                        RoundedRectangle(cornerRadius: 50)
                                            .stroke(.black, lineWidth: 8)
                                    )
                                    .shadow(color: .black, radius: 0, x: 0, y: 4)
                                    .frame(width: 200, height: 50)
                                ZStack {
                                    if tutorialViewModel.taskDone {
                                        TextView(text: "NEXT")
                                    } else {
                                        Text("NEXT")
                                            .font(.custom("TempleGemsRegular", size: 24))
                                            .foregroundColor(.white).opacity(0.25)
                                    }
                                }
                            }
                            .padding(.top, 25)
                            .opacity(tutorialViewModel.taskDone ? 1 : 0.3)
                            .opacity(tutorialViewModel.tutorialGuide ? 0 : 1)
                            .opacity((tutorialViewModel.board.tutorialStep == .complextConvert) ? 0 : 1)
//                            .opacity((tutorialViewMode))
                    }
                    .disabled(!tutorialViewModel.taskDone)
                }
                if tutorialViewModel.board.tutorialStep != .complextConvert {
                    
                    VStack {
                        Spacer()
                        HStack {
                            Image("redTutorial")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.4)
    //
                            Spacer()
                            //Hey there!
                            VStack {
                                Text(tutorialTitle)
                                    .font(.custom("TempleGemsRegular", size: 18))
                                    .textCase(.uppercase)
                                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                                Text(tutorialText).font(.custom("Yasir -Speech Bubble", size: 16)).foregroundColor(Color(#colorLiteral(red: 0.79, green: 0.76, blue: 1, alpha: 1))).multilineTextAlignment(.center).padding(.bottom, 2)
                                    .lineSpacing(5)
                                Button {
                                    tutorialViewModel.tutorialGuide.toggle()
                                } label: {
                                    ZStack {
                                        Rectangle()
                                        .fill(Color("ButtonColor4"))
                                        .frame(width: 169, height: 42)
                                        .cornerRadius(14)
                                        Text("CONTINUE")
                                            .font(.custom("TempleGemsRegular", size: 20))
                                            .textCase(.uppercase)
                                            .foregroundColor(Color(#colorLiteral(red: 0.83, green: 0.85, blue: 1, alpha: 1)))
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding(.bottom, geometry.size.height * 0.1)
                        .padding([.leading, .trailing], 10)
                        .opacity(tutorialViewModel.tutorialGuide ? 1 : 0)
                        
                        
                    }
                    .zIndex(1)
//                    Color.black
                    Rectangle()
                        .fill(LinearGradient(
                                gradient: Gradient(stops: [
                            .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)), location: 0),
                            .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), location: 1)]),
                                startPoint: UnitPoint(x: 0.5, y: -3.0616171314629196e-17),
                                endPoint: UnitPoint(x: 0.5, y: 0.9999999999999999)))
                        .opacity(tutorialViewModel.tutorialGuide ? 1 : 0)
//                        .allowsHitTesting(false)
                    Image("shadowTutorial")
                        .resizable()
                        .scaledToFit()
                        .blendMode(.destinationOut)
                        .opacity(tutorialViewModel.tutorialGuide ? 0.6 : 0)
//                        .allowsHitTesting(false)
                        

                }
                if tutorialViewModel.board.tutorialStep == .complextConvert && tutorialViewModel.taskDone == true {
                    VStack {
                        Spacer()
                        HStack {
                            Image("redTutorial")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.4)
    //
                            Spacer()
                            VStack {
                                Text(tutorialTitle)
                                    .font(.custom("TempleGemsRegular", size: 18))
                                    .textCase(.uppercase)
                                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                                Text(tutorialText).font(.custom("Yasir -Speech Bubble", size: 16)).foregroundColor(Color(#colorLiteral(red: 0.79, green: 0.76, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                                Button {
                                    if tutorialViewModel.board.tutorialStep != .complextConvert {
                                        tutorialViewModel.tutorialGuide.toggle()
                                    } else {
                                        if storyMode {
                                            tutorialViewModel.navigateToGame = true
                                        } else {
                                            gameCenterManager.path = NavigationPath()
                                        }
                                    }
                                } label: {
                                    ZStack {
                                        Rectangle()
                                        .fill(Color("ButtonColor4"))
                                        .frame(width: 169, height: 42)
                                        .cornerRadius(14)
                                        Text("CONTINUE")
                                            .font(.custom("TempleGemsRegular", size: 20))
                                            .textCase(.uppercase)
                                            .foregroundColor(Color(#colorLiteral(red: 0.83, green: 0.85, blue: 1, alpha: 1)))
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding(.bottom, geometry.size.height * 0.1)
                        .padding([.leading, .trailing], 10)
                        .opacity(tutorialViewModel.tutorialGuide ? 1 : 0)
                        
                    }
                    .zIndex(1)
                    Rectangle()
                        .fill(LinearGradient(
                                gradient: Gradient(stops: [
                            .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)), location: 0),
                            .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), location: 1)]),
                                startPoint: UnitPoint(x: 0.5, y: -3.0616171314629196e-17),
                                endPoint: UnitPoint(x: 0.5, y: 0.9999999999999999)))
                        .opacity(tutorialViewModel.tutorialGuide ? 1 : 0)
                    Image("shadowTutorial")
                        .resizable()
                        .scaledToFit()
                        .blendMode(.destinationOut)
                        .opacity(tutorialViewModel.tutorialGuide ? 0.6 : 0)
                        
                }
                                
            }
            
            if let level = gameCenterManager.currentLevel {
                NavigationLink(destination: GameView(gameType: .ai, gameSize: (row: level.boardSize.rows, col: level.boardSize.cols), obstacles: level.obstacles), isActive: $tutorialViewModel.navigateToGame) {
                    EmptyView()
                }
                .hidden()
            }
            
            
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onChange(of: tutorialViewModel.board.convertedCells.count, perform: { value in
            print("Converted cells: ", value)
        })
        .onAppear {
            if storyMode {
                gameCenterManager.currentLevel = GameLevel(rawValue: 1)
            }
            tutorialViewModel.board.setupTutorialBoard(for: .clonePiece)
        }
//        .onDisappear {
//            if storyMode {
//                gameCenterManager.currentLevel = gameCenterManager.currentLevel?.next
//            }
//        }
       
    }
    
    //MARK: - HELPER VARIABLES
    
    private var tutorialText: String {
        switch tutorialViewModel.board.tutorialStep {
        case .clonePiece:
            return "I'm Reddy, your jungle sidekick! Ready to master the spirits?"
        case .teleportPiece:
            return "Next up: Teleporting"
        case .convertPiece:
            return "Let’s convert some spirits!"
        case .complextConvert:
            return "Now the real adventure begins..."
        case .none:
            return ""
        }
    }
    
    private var tutorialTitle: String {
        switch tutorialViewModel.board.tutorialStep {
        case .clonePiece:
            return "Hey There!"
        case .teleportPiece:
            return "Awesome work!"
        case .convertPiece:
            return "Ready for more?"
        case .complextConvert:
            return "Great work!"
        case .none:
            return ""
        }
    }
    
    
    private var selectText: String {
        switch tutorialViewModel.board.tutorialStep {
        case .clonePiece:
            return appLanguageManager.localizedStringForKey("SELECT_PIECE", language: appLanguageManager.currentLanguage)
        case .teleportPiece:
            return appLanguageManager.localizedStringForKey("SELECT_PIECE", language: appLanguageManager.currentLanguage)
        case .convertPiece:
            return appLanguageManager.localizedStringForKey("GETTING_IT", language: appLanguageManager.currentLanguage)
        case .complextConvert:
            return appLanguageManager.localizedStringForKey("ONE_MORE", language: appLanguageManager.currentLanguage)
        case .none:
            return ""
        }
    }
    
    private var taskText: String {
        switch tutorialViewModel.board.tutorialStep {
        case .clonePiece:
            return appLanguageManager.localizedStringForKey("CLONE_YOURSELF", language: appLanguageManager.currentLanguage)
        case .teleportPiece:
            return appLanguageManager.localizedStringForKey("TELEPORT_YOURSELF", language: appLanguageManager.currentLanguage)
        case .convertPiece:
            return appLanguageManager.localizedStringForKey("COVERT_BLUE_RED", language: appLanguageManager.currentLanguage)
        case .complextConvert:
            return appLanguageManager.localizedStringForKey("COVERT_BLUE_RED", language: appLanguageManager.currentLanguage)
        case .none:
            return ""
        }
    }
    
    private var taskColor: String {
        switch tutorialViewModel.board.tutorialStep {
        case .clonePiece:
            return "tutorialGreen"
        case .teleportPiece:
            return "tutorialYellow"
        case .convertPiece:
            return "tutorialBlue"
        case .complextConvert:
            return "tutorialBlue"
        case .none:
            return ""
        }
    }
}

#Preview {
    TutorialView(gameCenterManager: GameCenterManager(currentPlayer: .player1), storyMode: false)
        .environmentObject(AppLanguageManager())
        .environmentObject(GameCenterManager(currentPlayer: .player1))
}


struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)), y: 0))
    }
}
