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

struct BoardView: View {
    @EnvironmentObject var match: Match

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
                    Rectangle()
                        .fill(.yellow)
                        .frame(width: halfGrid, height: halfGrid)
                    Rectangle().fill(.orange).frame(width: gridSize * 19.0, height: halfGrid)
                        .onTapGesture {
                            print("Horizontal Tapped \(match.count)");
                        }
                    Rectangle()
                        .fill(.yellow)
                        .frame(width: halfGrid, height: halfGrid)
                }
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(.orange)
                        .frame(width: halfGrid, height: gridSize * 19.0)
                        .onTapGesture {
                            print("Vertical Tapped \(match.count)");
                        }
                    LazyVGrid(columns: columns, spacing: gridSpace) {
                        ForEach(0..<361) { index in
                            Image(systemName: symbols[match.stones[index]])
                                .font(.system(size: gridSize-1.0))
                                .opacity(match.stones[index] > 0 ? 1.0 : 0.05)
                                .frame(minWidth: gridSize, maxWidth: gridSize, minHeight: gridSize, maxHeight: gridSize)
                                .onTapGesture {
                                    match.click(index: index)
                                    print("Board Tapped \(index)");
                                }
                        }
                    }.frame(width: fullSize-gridSize, height: fullSize-gridSize, alignment: .center)
                    Rectangle()
                        .fill(.orange)
                        .frame(width: halfGrid, height: gridSize * 19.0)
                        .onTapGesture {
                            print("Vertical Tapped \(match.count)");
                        }
                }
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(.yellow)
                        .frame(width: halfGrid, height: halfGrid)
                    Rectangle().fill(.orange).frame(width: gridSize * 19.0, height: halfGrid)
                        .onTapGesture {
                            print("Horizontal Tapped \(match.count)");
                        }
                    Rectangle()
                        .fill(.yellow)
                        .frame(width: halfGrid, height: halfGrid)
                }
            }
        }.onTapGesture {
            print("Outer Tapped \(match.count)");
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .previewInterfaceOrientation(.portrait)
    }
}
