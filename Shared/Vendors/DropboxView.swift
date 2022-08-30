//
//  DropboxView.swift
//  Orca (iOS)
//
//  Created by Horace Ho on 30/8/2022.
//

import SwiftUI
import SwiftyDropbox

struct DropboxView: View {
    var body: some View {
        Button(role: .none, action: {
            // ..
        }) {
            Text("Connect to Dropbox")
                .padding()
        }
    }
}

struct DropboxView_Previews: PreviewProvider {
    static var previews: some View {
        DropboxView()
    }
}
