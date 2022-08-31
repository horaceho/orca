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
