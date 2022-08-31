//
//  ClickView.swift
//  Orca
//
//  Created by Horace Ho on 29/8/2022.
//

import SwiftUI

struct ClickView: View {
    @EnvironmentObject var match: Match
    @State private var location = CGSize.zero

    var body: some View {
        GeometryReader { (geometry) in
            let fullSize = min(geometry.size.width, geometry.size.height)
            let gridSize = fullSize / 20.0
            let halfGrid = gridSize / 2.0

            Rectangle()
                .fill(.red.opacity(0.25))
                .frame(width: gridSize * 19.0, height: gridSize * 19.0)
                .padding(halfGrid)
//                .onTapGesture { location in
//                    print("onTapGesture \(location)")
//                }
        }
    }
}

struct ClickView_Previews: PreviewProvider {
    static var previews: some View {
        ClickView()
            .environmentObject(Match())
    }
}
