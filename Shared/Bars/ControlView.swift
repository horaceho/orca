//
//  ControlView.swift
//  Orca
//
//  Created by Horace Ho on 2022/08/28.
//

import SwiftUI

struct ControlView: View {
    @EnvironmentObject var match: Match
    @State private var showiCloud = false
    @State private var showConfig = false

    var body: some View {
        HStack {
            Button(role: .none, action: {
                // ...
            }) {
                Image(systemName: match.turnImageName())
                    .imageScale(.large)
            }.padding(.horizontal)
            Button(role: .none, action: {
                // ...
            }) {
                Image(systemName: "brain.head.profile")
            }.padding(.horizontal)
            Button(role: .none, action: {
                print("9 + 1 = \(addOneGetAnswer(9))");
                if let url = match.sgfUrl {
                    print(url.path)
                    sgfInit()
                    var ok = sgfArgs("encoding", "GB18030")
                    if (ok) { sgfLoad(url.path) }
                    if (ok) { ok = sgfParse() }
                    if (ok) { sgfDump() }
                    sgfFree()
                }
            }) {
                Image(systemName: "number")
            }.padding(.horizontal)
            Button(role: .none, action: {
                showiCloud = true
            }) {
                Image(systemName: "icloud")
            }.padding(.horizontal)
                .popover(isPresented: $showiCloud) {
                    CloudView(showiCloud: $showiCloud)
                        .frame(minWidth: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                               minHeight: 360.0,
                               idealHeight: 720.0)
                }
            Button(role: .none, action: {
                showConfig = true
            }) {
                Image(systemName: "gearshape")
            }.padding(.horizontal)
                .popover(isPresented: $showConfig) {
                    ConfigView(showConfig: $showConfig)
                }
            Button(role: match.trashRole(), action: {
                match.clickTrash()
            }) {
                Image(systemName: "trash")
            }.padding(.horizontal)
        }.padding()
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView().environmentObject(Match())
    }
}
