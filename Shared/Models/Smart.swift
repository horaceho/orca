//
//  Smart.swift
//  Orca
//
//  Created by Horace Ho on 2/9/2022.
//

import SwiftUI

struct Prop: Identifiable {
    let id = UUID()
    var code: String
    var type: String
    var vars: [String]?
}

struct Node: Identifiable {
    let id = UUID()
    let index: String
    var props: [String]?
}

class Smart: ObservableObject {
    @Published var nodes: [Node] = []
    let sgf = GoSGF()

    func alphabet() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let letter = String((0..<1).map{ _ in letters.randomElement()! })
        return letter
    }

    func random() {

        nodes.append(Node(
            index: alphabet()
        ))
    }

    func walk(filename: String, encoding: String) {
        var count = 0
        sgf.setupInfo()
        sgf.parseArgs()
        sgf.encoding(encoding)
        sgf.openFile(filename)
        sgf.parseSgf()
        sgf.gotoRoot()
        while (sgf.isNode()) {
            if (sgf.isMove()) {
                count += 1
            }
            sgf.gotoChild()
        }
        print("Moves: \(count)")
    }

    func test(filename: String, encoding: String) {
        sgf.setupInfo()
        sgf.parseArgs()
        sgf.encoding(encoding)
        sgf.openFile(filename)
        sgf.parseSgf()
        sgf.printAll()
    }
}
