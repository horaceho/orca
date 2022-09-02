//
//  GridView.swift
//  Orca
//
//  Created by Horace Ho on 2022/08/27.
//

import SwiftUI

struct GridView: View {
    @EnvironmentObject var match: Match

    var body: some View {
        GeometryReader { (geometry) in
            let fullSize = min(geometry.size.width, geometry.size.height)
            let gridSize = fullSize / CGFloat(match.size + 1)
            let gridFull = gridSize * CGFloat(match.size)

            ForEach(2..<19) { index in
                Path() { path in
                    path.move(to: CGPoint(x: gridSize, y: gridSize * CGFloat(index)))
                    path.addLine(to: CGPoint(x: gridFull, y: gridSize * CGFloat(index)))
                }
                .stroke(Color.black, lineWidth: 1.0)
            }

            ForEach(2..<19) { index in
                Path() { path in
                    path.move(to: CGPoint(x: gridSize * CGFloat(index), y: gridSize))
                    path.addLine(to: CGPoint(x: gridSize * CGFloat(index), y: gridFull))
                }
                .stroke(Color.black, lineWidth: 1.0)
            }

            Path() { path in
                path.move(to: CGPoint(x: gridSize, y: gridSize))
                path.addLine(to: CGPoint(x: gridFull, y: gridSize))
                path.addLine(to: CGPoint(x: gridFull, y: gridFull))
                path.addLine(to: CGPoint(x: gridSize, y: gridFull))
                path.addLine(to: CGPoint(x: gridSize, y: gridSize))
            }
            .stroke(Color.black, lineWidth: 3.0)

            Group {
                Circle().position(x: (gridSize *  4.0), y: (gridSize *  4.0)).frame(width: 5.0, height: 5.0)
                Circle().position(x: (gridSize *  4.0), y: (gridSize * 10.0)).frame(width: 5.0, height: 5.0)
                Circle().position(x: (gridSize *  4.0), y: (gridSize * 16.0)).frame(width: 5.0, height: 5.0)
            }
            Group {
                Circle().position(x: (gridSize * 10.0), y: (gridSize *  4.0)).frame(width: 5.0, height: 5.0)
                Circle().position(x: (gridSize * 10.0), y: (gridSize * 10.0)).frame(width: 5.0, height: 5.0)
                Circle().position(x: (gridSize * 10.0), y: (gridSize * 16.0)).frame(width: 5.0, height: 5.0)
            }
            Group {
                Circle().position(x: (gridSize * 16.0), y: (gridSize *  4.0)).frame(width: 5.0, height: 5.0)
                Circle().position(x: (gridSize * 16.0), y: (gridSize * 10.0)).frame(width: 5.0, height: 5.0)
                Circle().position(x: (gridSize * 16.0), y: (gridSize * 16.0)).frame(width: 5.0, height: 5.0)
            }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
            .environmentObject(Match())
    }
}
