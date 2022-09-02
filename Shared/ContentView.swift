//
//  ContentView.swift
//  Shared
//
//  Created by Horace Ho on 26/8/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var match = Match()
    @StateObject var smart = Smart()

    var body: some View {
        GeometryReader { (geometry) in
            if (geometry.size.width > geometry.size.height) {
                HStack {
                    ZStack {
                        BoardView()
                     // GridView()
                        StoneView()
                    }.frame(width: geometry.size.height, height:geometry.size.height)
                    Spacer()
                    VStack() {
                        HelloView()
                        Spacer()
                        TreeView()
                        ControlView()
                    }
                    Spacer()
                }
            } else {
                VStack {
                    ZStack {
                        BoardView()
                     // GridView()
                        StoneView()
                    }.frame(maxWidth: geometry.size.width, maxHeight:geometry.size.width)
                    HelloView()
                    Spacer()
                    TreeView()
                    ControlView()
                }
            }
            let _ = print("W:\(geometry.size.width) H:\(geometry.size.height) ")
        }
        .environmentObject(match)
        .environmentObject(smart)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Match()).previewInterfaceOrientation(.portrait)
    }
}
