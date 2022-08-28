//
//  NavigationView.swift
//  Orca
//
//  Created by Horace Ho on 2022/08/28.
//

import SwiftUI

struct NavigationView: View {
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
                Image(systemName: "backward.end")
                    .imageScale(.small)
            }.padding(.horizontal)
            Button(role: .none, action: {
                // ...
            }) {
                Image(systemName: "backward.frame")
                    .imageScale(.small)
            }.padding(.horizontal)
            Button(role: .none, action: {
                // ...
            }) {
                Image(systemName: "play.fill")
                    .imageScale(.large)
            }.padding(.horizontal)
            Button(role: .none, action: {
                // ...
            }) {
                Image(systemName: "forward.frame")
                    .imageScale(.small)
            }.padding(.horizontal)
            Button(role: .none, action: {
                // ...
            }) {
                Image(systemName: "forward.end")
                    .imageScale(.small)
            }.padding(.horizontal)
        }.padding()
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView().environmentObject(Match())
    }
}
