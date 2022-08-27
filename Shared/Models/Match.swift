//
//  Match.swift
//  Orca
//
//  Created by Horace Ho on 2022/08/27.
//

import SwiftUI

class Match: ObservableObject {
    @Published var count: Int = 0
    @Published var color: Int = Orca.BLACK
    @Published var always: Int = Orca.TOGGLE

    @Published var size: Int = 19

    @Published var images = [
        "Stone-Book-Blank",
        "Stone-Book-Black",
        "Stone-Book-White",
    ]

    @Published var stones: [Int] = // Array(repeating: 0, count: 361)
    [
    //  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //  1
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //  2
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //  3
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //  4
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //  5
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //  6
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //  7
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //  8
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //  9
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 10
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 11
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 12
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 13
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 14
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 15
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 16
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 17
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 18
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 19
    ]

    init() {
        count = UserDefaults.standard.object(forKey: "Orca.count") as? Int ?? 0
        color = UserDefaults.standard.object(forKey: "Orca.color") as? Int ?? Orca.BLACK
        always = UserDefaults.standard.object(forKey: "Orca.always") as? Int ?? Orca.TOGGLE
        stones = UserDefaults.standard.object(forKey: "Orca.stones") as? [Int] ?? Array(repeating: 0, count: 361)
    }

    func save() {
        UserDefaults.standard.set(count, forKey: "Orca.count")
        UserDefaults.standard.set(color, forKey: "Orca.color")
        UserDefaults.standard.set(always, forKey: "Orca.always")
        UserDefaults.standard.set(stones, forKey: "Orca.stones")
    }

    func click(index: Int) {
        if (stones[index] == Orca.EMPTY) {
            stones[index] = color
            if (always == Orca.TOGGLE) {
                color = (color == Orca.BLACK) ? Orca.WHITE : Orca.BLACK
            }
        } else {
            stones[index] = Orca.EMPTY
        }

        count += 1

        save()
    }
}
