//
//  HelloView.swift
//  Orca
//
//  Created by Horace Ho on 26/8/2022.
//

import SwiftUI

struct HelloView: View {
    var body: some View {
        VStack {
            Text("Hello, Orca!")
                .font(.title)
            Text("I am your friend.")
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
