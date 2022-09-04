//
//  Smart.swift
//  Orca
//
//  Created by Horace Ho on 2/9/2022.
//

import SwiftUI

class Node: Identifiable {
    let id = UUID()
    var props: [String: [String]]?
    var nodes: [Node] = []
    weak var parent: Node?

    init(props: [String: [String]]) {
      self.props = props
    }

    func add(child: Node) {
        nodes.append(child)
        child.parent = self
    }
}

class Smart: ObservableObject {
    @Published var game: Node?

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
        let temp = Node(props: sgf.props())
        sgf.gotoChild()
        while (sgf.isNode()) {
            if (sgf.isMove()) {
                count += 1
            }
            let node = Node(props: sgf.props())
            temp.add(child: node)
            sgf.gotoChild()
        }
        game = temp
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
