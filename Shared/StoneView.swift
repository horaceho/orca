//
//  StoneView.swift
//  Orca
//
//  Created by Horace Ho on 26/8/2022.
//

import SwiftUI

let boardSize: Int = 19
let gridCount: Int = 361
let gridSpace: CGFloat = 0.0

struct StoneView: View {
    @EnvironmentObject var match: Match

    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: gridSpace), count: boardSize)

    var body: some View {
        GeometryReader { (geometry) in
            let fullSize = min(geometry.size.width, geometry.size.height)
            let gridSize = fullSize / 20.0
            let halfGrid = gridSize / 2.0

            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(.yellow)
                        .opacity(0.0)
                        .frame(width: halfGrid, height: halfGrid)
                    Rectangle()
                        .fill(.orange)
                        .opacity(0.0)
                        .frame(width: gridSize * 19.0, height: halfGrid)
                        .onTapGesture {
                            print("Horizontal Tapped \(match.count)");
                        }
                    Rectangle()
                        .fill(.yellow)
                        .opacity(0.0)
                        .frame(width: halfGrid, height: halfGrid)
                }
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(.orange)
                        .opacity(0.0)
                        .frame(width: halfGrid, height: gridSize * 19.0)
                        .onTapGesture {
                            print("Vertical Tapped \(match.count)");
                        }
                    LazyVGrid(columns: columns, spacing: gridSpace) {
                        ForEach(0..<361) { index in
                            Image(match.images[match.stones[index]])
                                .resizable()
                                .shadow(color: .black.opacity(0.5), radius: 1.75, x: -1.5, y: 1.25)
                                .frame(minWidth: gridSize, maxWidth: gridSize, minHeight: gridSize, maxHeight: gridSize)
                                .onTapGesture {
                                    print("gridSize \(gridSize)")
                                    match.clickStone(index: index)
                                }
                        }
                    }.frame(width: fullSize-gridSize, height: fullSize-gridSize, alignment: .center)
                    Rectangle()
                        .fill(.orange)
                        .opacity(0.0)
                        .frame(width: halfGrid, height: gridSize * 19.0)
                        .onTapGesture {
                            print("Vertical Tapped \(match.count)");
                        }
                }
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(.yellow)
                        .opacity(0.0)
                        .frame(width: halfGrid, height: halfGrid)
                    Rectangle()
                        .fill(.orange)
                        .opacity(0.0)
                        .frame(width: gridSize * 19.0, height: halfGrid)
                        .onTapGesture {
                            print("Horizontal Tapped \(match.count)");
                        }
                    Rectangle()
                        .fill(.yellow)
                        .opacity(0.0)
                        .frame(width: halfGrid, height: halfGrid)
                }
            }
        }.onTapGesture {
            print("Outer Tapped \(match.count)");
        }
    }
}

struct StoneView_Previews: PreviewProvider {
    static var previews: some View {
        StoneView()
            .environmentObject(Match())
            .previewInterfaceOrientation(.portrait)
    }
}
