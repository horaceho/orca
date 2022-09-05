//
//  NodeView.swift
//  Orca
//
//  Created by Horace Ho on 2022/09/04.
//

import SwiftUI

struct NodeView: View {
    @EnvironmentObject var match: Match
    @EnvironmentObject var smart: Smart

    var body: some View {
        ScrollView {
            VStack {
                if let node = smart.node {
                    if let props = node.props {
                        if let values = props["GN"] {
                            if let first = values.first {
                                Text("\(first)").padding()
                            }
                            let _ = print("\(values)")
                        }
                        if let values = props["C"] {
                            if let first = values.first {
                                Text("\(first)").padding()
                            }
                            let _ = print("\(values)")
                        }
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture(count: 2) {
                //
            }
            .onTapGesture(count: 1) {
                //
            }
        }
        .onTapGesture(count: 2) {
            //
        }
        .onTapGesture(count: 1) {
            //
        }
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView()
            .environmentObject(Match())
            .environmentObject(Smart())
    }
}
