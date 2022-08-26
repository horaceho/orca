//
//  ContentView.swift
//  Shared
//
//  Created by Horace Ho on 26/8/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { (geometry) in
            if (geometry.size.width > geometry.size.height) {
                HStack {
                    BoardView()
                    HelloView()
                }
            } else {
                VStack {
                    BoardView()
                    HelloView()
                }
            }
            let _ = print("W:\(geometry.size.width) H:\(geometry.size.height) ")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
