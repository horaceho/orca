//
//  Smart.swift
//  Orca
//
//  Created by Horace Ho on 2/9/2022.
//

import SwiftUI

struct Node: Identifiable {
    let id = UUID()
    let index: String
}

class Smart: ObservableObject {
    @Published var nodes: [Node] = []

    func random() {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let letter = String((0..<1).map{ _ in letters.randomElement()! })
        nodes.append(Node(
            index: letter
        ))
    }

    func test(filename: String, encoding: String) {
        let sgf = GoSGF()
        sgf.setupInfo()
        sgf.parseArgs()
        sgf.encoding(encoding)
        sgf.openFile(filename)
        sgf.parseSgf()
        sgf.printAll()
        print("Ready: \(sgf.isReady())")
    }
}
