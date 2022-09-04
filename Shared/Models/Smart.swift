//
//  Smart.swift
//  Orca
//
//  Created by Horace Ho on 2/9/2022.
//

import SwiftUI

class Node: Equatable, Identifiable {
    let id = UUID()
    var props: [String: [String]]?
    var nodes: [Node] = []
    var index: Int = 0
    weak var parent: Node?

    weak static var cursor: Node?

    init(props: [String: [String]]) {
        self.props = props
    }

    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }

    func add(child: Node) {
        nodes.append(child)
        child.parent = self
    }

    func text() -> String {
        return index > 0 ? "\(index)" : "·"
    }

    func setCursor() {
        Node.cursor = self
    }

//    func gotoHere() {
//        Node.cursor = self
//    }
//
//    func gotoHead() {
//        Node.cursor = nodes.first
//    }
//
//    func gotoTail() {
//        Node.cursor = nodes.last
//    }

    func properties() -> [String: [String]]? {
        if let props = props {
            return props
        }
        return nil
    }
}

class Smart: ObservableObject {
    @Published var game: Node?
    @Published var node: Node?

    func alphabet() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let letter = String((0..<1).map{ _ in letters.randomElement()! })
        return letter
    }

    func random() {
//        let node = Node(value: alphabet())
//        game.add(child: node)
    }

    func walk(filename: String, encoding: String) {
        var count = 0
        let sgf = GoSGF()
        sgf.setupInfo()
        sgf.parseArgs()
        sgf.encoding(encoding)
        sgf.openFile(filename)
        sgf.parseSgf()
        sgf.gotoRoot()
        let root = Node(props: sgf.props())
        sgf.gotoChild()
        while (sgf.isNode()) {
            let temp = Node(props: sgf.props())
            if (sgf.isMove()) {
                count += 1
                temp.index = count
            }
            root.add(child: temp)
            sgf.gotoChild()
        }
        game = root
        node = game

        print("Moves: \(count)")
    }

    func list()
    {
        var roots = [String: Int]()
        var codes = [String: Int]()
        var nodes = 0
        if let root = game {
            if let props = root.props {
                for (key, values) in props {
                    print("\(key)", terminator: ":")
                    roots[key] = (roots[key] ?? 0) + 1
                    for value in values {
                        print(" \(value)", terminator: "")
                    }
                    print("")
                }
            }
            for node in root.nodes {
                nodes += 1
                if let props = node.props {
                    for (key, values) in props {
                        print("\(key)", terminator: ":")
                        codes[key] = (codes[key] ?? 0) + 1
                        for value in values {
                            print(" \(value)", terminator: "")
                        }
                        print("")
                    }
                }
            }
        }
        for root in roots {
            print("Root: \(root.key): \(root.value)")
        }
        for code in codes {
            print("Node: \(code.key): \(code.value)")
        }
    }

    func test(filename: String, encoding: String) {
        let sgf = GoSGF()
        sgf.setupInfo()
        sgf.parseArgs()
        sgf.encoding(encoding)
        sgf.openFile(filename)
        sgf.parseSgf()
        sgf.printAll()
    }
}
