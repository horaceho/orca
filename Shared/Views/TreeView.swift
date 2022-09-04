//
//  TreeView.swift
//  Orca
//
//  Created by Horace Ho on 2/9/2022.
//

import SwiftUI

struct TreeView: View {
    @EnvironmentObject var smart: Smart

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack() {
                if let game = smart.game {
                    ForEach(game.nodes, id: \.id) { node in
                        Button(role: .none, action: {
                            // ...
                        }) {
                            Text(node.text())
                                .padding()
                        }
                        .background(.red.opacity(0.1))
                    }
                }
            }
        }.background(.yellow.opacity(0.1))
    }
}

struct TreeView_Previews: PreviewProvider {
    static var previews: some View {
        TreeView()
            .environmentObject(Smart())
    }
}
