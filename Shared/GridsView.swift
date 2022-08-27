//
//  GridsView.swift
//  Orca
//
//  Created by Horace Ho on 2022/08/27.
//

import SwiftUI

struct GridsView: View {
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
            .stroke(Color.black, lineWidth: 2.5)

            Group {
                Circle().position(x: (gridSize *  4.0), y: (gridSize *  4.0)).frame(width: 5.0, height: 5.0)
                Circle().position(x: (gridSize *  4.0), y: (gridSize *  9.0)).frame(width: 5.0, height: 5.0)
                Circle().position(x: (gridSize *  4.0), y: (gridSize * 15.0)).frame(width: 5.0, height: 5.0)
            }
            Group {
                Circle().position(x: (gridSize *  9.0), y: (gridSize *  4.0)).frame(width: 5.0, height: 5.0)
                Circle().position(x: (gridSize *  9.0), y: (gridSize *  9.0)).frame(width: 5.0, height: 5.0)
                Circle().position(x: (gridSize *  9.0), y: (gridSize * 15.0)).frame(width: 5.0, height: 5.0)
            }
            Group {
                Circle().position(x: (gridSize * 15.0), y: (gridSize *  4.0)).frame(width: 5.0, height: 5.0)
                Circle().position(x: (gridSize * 15.0), y: (gridSize *  9.0)).frame(width: 5.0, height: 5.0)
                Circle().position(x: (gridSize * 15.0), y: (gridSize * 15.0)).frame(width: 5.0, height: 5.0)
            }
        }
    }
}

struct GridsView_Previews: PreviewProvider {
    static var previews: some View {
        GridsView()
            .environmentObject(Match())
    }
}
