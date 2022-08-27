//
//  ContentView.swift
//  Shared
//
//  Created by Horace Ho on 26/8/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var match = Match()

    var body: some View {
        GeometryReader { (geometry) in
            if (geometry.size.width > geometry.size.height) {
                HStack {
                    ZStack {
                        GridsView()
                        BoardView()
                    }
                    HelloView()
                }
            } else {
                VStack {
                    ZStack {
                        GridsView()
                        BoardView()
                    }
                    HelloView()
                }
            }
            let _ = print("W:\(geometry.size.width) H:\(geometry.size.height) ")
        }.environmentObject(match)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Match())
    }
}
