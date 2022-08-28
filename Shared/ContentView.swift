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
                    }.frame(maxWidth: geometry.size.height, maxHeight:geometry.size.height)
                    Spacer()
                    VStack() {
                        HelloView()
                        Spacer()
                        ControlView()
                    }
                    Spacer()
                }
            } else {
                VStack {
                    ZStack {
                        GridsView()
                        BoardView()
                    }.frame(maxWidth: geometry.size.width, maxHeight:geometry.size.width)
                    HelloView()
                    Spacer()
                    ControlView()
                }
            }
            let _ = print("W:\(geometry.size.width) H:\(geometry.size.height) ")
        }.environmentObject(match)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Match()).previewInterfaceOrientation(.portrait)
    }
}
