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
            Text("Hello, Orca!")
                .font(.title)
            Text("Count \(match.count)")
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
