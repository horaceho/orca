//
//  ControlView.swift
//  Orca
//
//  Created by Horace Ho on 2022/08/28.
//

import SwiftUI

struct ControlView: View {
    @EnvironmentObject var match: Match

    var body: some View {
        HStack {
            Button(role: .none, action: {
                // ...
            }) {
                Image(systemName: match.turnImageName())
                    .imageScale(.large)
                    .foregroundColor(.black)
            }.padding(.horizontal)
            Button(role: .none, action: {
                // ...
            }) {
                Image(systemName: "brain.head.profile")
            }.padding(.horizontal)
            Button(role: .none, action: {
                match.clickDelete()
            }) {
                Image(systemName: "delete.left")
            }.padding(.horizontal)
            Button(role: .none, action: {
                // ...
            }) {
                Image(systemName: "icloud")
            }.padding(.horizontal)
            Button(role: .none, action: {
                // ...
            }) {
                Image(systemName: "square.and.arrow.up")
            }.padding(.horizontal)
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
