//
//  NodeView.swift
//  Orca
//
//  Created by Horace Ho on 2022/09/04.
//

import SwiftUI

struct NodeView: View {
    @EnvironmentObject var smart: Smart

    var body: some View {
        if let node = smart.node {
            if let props = node.props {
                if let values = props["GN"] {
                    if let first = values.first {
                        Text("\(first)")
                    }
                    let _ = print("\(values)")
                }
            }
        }
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView()
            .environmentObject(Smart())
    }
}
