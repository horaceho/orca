//
//  ContentView.swift
//  Shared
//
//  Created by Horace Ho on 26/8/2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
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
                        NodeView()
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
                    }.frame(width: geometry.size.width, height:geometry.size.width)
                    NodeView()
                    Spacer()
                    TreeView()
                    ControlView()
                }
            }
            let _ = print("Geometry width: \(geometry.size.width) height: \(geometry.size.height)")
        }
        .environmentObject(match)
        .environmentObject(smart)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                match.active()
            } else if newPhase == .inactive {
                match.inactive()
            } else if newPhase == .background {
                match.background()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Match()).previewInterfaceOrientation(.portrait)
    }
}
