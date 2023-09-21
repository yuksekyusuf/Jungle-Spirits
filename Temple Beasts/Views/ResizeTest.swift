import SwiftUI

struct GameView1: View {
    let rows: Int
    let columns: Int

    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
    }

    var body: some View {
        GeometryReader { geometry in
            let cellSize = self.calculateCellSize(geometry: geometry)
            let boardWidth = cellSize * CGFloat(self.columns)
            
            VStack {
//                Rectangle()
//                    .fill(Color.red)
//                    .frame(width: 300)
                Spacer()
                HStack {
                    Spacer()
                    BoardView1(rows: self.rows, columns: self.columns, cellSize: cellSize)
                        .frame(maxWidth: boardWidth, minHeight: boardWidth, maxHeight: geometry.size.height * 0.7)
                    Spacer()
                }
                Spacer()
//                Rectangle()
//                    .fill(Color.blue)
//                    .frame(width: 300)
            }
        }
    }
    
    func calculateCellSize(geometry: GeometryProxy) -> CGFloat {
        let maxCellWidth = geometry.size.width * 0.175
        let availableWidth = geometry.size.width * 0.9
        let maxWidthBasedCellSize = min(maxCellWidth, availableWidth / CGFloat(columns))
        
        let maxBoardHeight = geometry.size.height * 0.85
        let maxHeightBasedCellSize = maxBoardHeight / CGFloat(rows)
        
        var cellWidth = max(maxWidthBasedCellSize, maxHeightBasedCellSize)
        
        if cellWidth * CGFloat(columns) > availableWidth {
            cellWidth = availableWidth / CGFloat(columns)
        } else if cellWidth * CGFloat(rows) > maxBoardHeight {
            cellWidth = maxBoardHeight / CGFloat(rows)
        }
        
        return cellWidth
    }
}




struct BoardView1: View {
    let rows: Int
    let columns: Int
    let cellSize: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<columns, id: \.self) { column in
                        CellView1()
                            .frame(width: cellSize, height: cellSize)
                    }
                }
            }
        }
    }
}



struct CellView1: View {
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .border(Color.black)
    }
}

struct GameView1_Previews: PreviewProvider {
    static var previews: some View {
        GameView1(rows: 8, columns: 4)
    }
}
