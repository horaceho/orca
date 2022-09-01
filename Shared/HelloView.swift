//
//  HelloView.swift
//  Orca
//
//  Created by Horace Ho on 26/8/2022.
//

import SwiftUI

struct HelloView: View {
    @EnvironmentObject var match: Match

    var body: some View {
        VStack {
            if let title = match.sgfUrl {
                Text(title.lastPathComponent)
            } else {
                Text("Hello, Orca!")
                    .font(.title)
            }
            Text("Clicks \(match.clicks.count) B \(match.blackDead) W \(match.whiteDead)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }.padding()
    }
}

struct HelloView_Previews: PreviewProvider {
    static var previews: some View {
        HelloView()
    }
}
