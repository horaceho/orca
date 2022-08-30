//
//  BoardView.swift
//  Orca
//
//  Created by Horace Ho on 29/8/2022.
//

import SwiftUI

struct BoardView: View {
    @EnvironmentObject var match: Match

    var body: some View {
        GeometryReader { (geometry) in
            let fullSize = min(geometry.size.width, geometry.size.height)
            Image(match.boardImage())
                .resizable()
                .frame(width: fullSize, height: fullSize, alignment: .center)
                .rotationEffect(.degrees(match.angle))
                .shadow(color: .black.opacity(0.5), radius: 1.75, x: -1.5, y: 1.25)
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .environmentObject(Match())
    }
}
