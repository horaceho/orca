//
//  BoardView.swift
//  Orca
//
//  Created by Horace Ho on 26/8/2022.
//

import SwiftUI

let boardSize: Int = 19
let gridCount: Int = 361
let gridSpace: CGFloat = 0.0

var stones: [Int] = // Array(repeating: 0, count: 361)
[
//  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //  1
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //  2
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, //  3
    0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //  4
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //  5
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //  6
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //  7
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //  8
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //  9
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 10
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 11
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 12
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 13
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, // 14
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 15
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, // 16
    0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, // 17
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 18
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 19
]

struct BoardView: View {

    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: gridSpace), count: boardSize)

    private var symbols = ["plus", "circle.fill", "circle"]

    private var colors: [Color] = [.yellow, .purple, .green, .brown, .blue, .pink, .gray, .white]

    var body: some View {
        GeometryReader { (geometry) in
            let fullSize = min(geometry.size.width, geometry.size.height)
            let gridSize = fullSize / 20.0;
            let halfGrid = gridSize / 2.0;
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Rectangle().fill(.yellow).frame(width: halfGrid, height: halfGrid)
                    Rectangle().fill(.orange).frame(width: gridSize * 19.0, height: halfGrid)
                    Rectangle().fill(.yellow).frame(width: halfGrid, height: halfGrid)
                }
                HStack(spacing: 0) {
                    Rectangle().fill(.orange).frame(width: halfGrid, height: gridSize * 19.0)
                    LazyVGrid(columns: columns, spacing: gridSpace) {
                        ForEach(0..<361) { index in
                            Image(systemName: symbols[stones[index]])
                                .font(.system(size: gridSize-1.0))
                                .opacity(stones[index] > 0 ? 1.0 : 0.05)
                                .frame(minWidth: gridSize, maxWidth: gridSize, minHeight: gridSize, maxHeight: gridSize)
                        }
                    }.frame(width: fullSize-gridSize, height: fullSize-gridSize, alignment: .center)
                    Rectangle().fill(.orange).frame(width: halfGrid, height: gridSize * 19.0)
                }
                HStack(spacing: 0) {
                    Rectangle().fill(.yellow).frame(width: halfGrid, height: halfGrid)
                    Rectangle().fill(.orange).frame(width: gridSize * 19.0, height: halfGrid)
                    Rectangle().fill(.yellow).frame(width: halfGrid, height: halfGrid)
                }
            }
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .previewInterfaceOrientation(.portrait)
    }
}
