//
//  ConfigView.swift
//  Orca (iOS)
//
//  Created by Horace Ho on 2022/08/29.
//

import SwiftUI

struct ConfigView: View {
    @Binding var showConfig: Bool
    @EnvironmentObject var match: Match

    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 10) {
                Button(role: .none, action: {
                    match.clickBoard(index: 0)
                }) {
                    Image("Board-Darker")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .border(.gray.opacity(match.board == 0 ? 100.0 : 0.0), width: 2)
                }.padding(3)
                Button(role: .none, action: {
                    match.clickBoard(index: 1)
                }) {
                    Image("Board-Lighter")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .border(.gray.opacity(match.board == 1 ? 100.0 : 0.0), width: 2)
                }.padding(3)
            }.padding()
            Spacer()
            Button(role: .none, action: {
                showConfig = false
            }) {
                Image(systemName: "arrow.uturn.backward.circle")
                    .imageScale(.large)
            }.padding()
        }.frame(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height))
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView(showConfig: .constant(true))
            .environmentObject(Match())
    }
}
