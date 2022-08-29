//
//  ConfigView.swift
//  Orca (iOS)
//
//  Created by Horace Ho on 2022/08/29.
//

import SwiftUI

struct ConfigView: View {
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
                }.padding(2)
                Button(role: .none, action: {
                    match.clickBoard(index: 1)
                }) {
                    Image("Board-Lighter")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .border(.gray.opacity(match.board == 1 ? 100.0 : 0.0), width: 2)
                }.padding(2)
            }.padding()
            Spacer()
        }.frame(width: 480)
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView()
            .environmentObject(Match())
    }
}
