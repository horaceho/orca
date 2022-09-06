//
//  Match.swift
//  Orca
//
//  Created by Horace Ho on 2022/08/27.
//

import SwiftUI

class Match: ObservableObject {
    @Published var count: Int = 0
    @Published var trash: Int = 0
    @Published var board: String = "Darker"
    @Published var angle: Double = 0.0
    @Published var color: Int = Orca.BLACK
    @Published var turns: Int = Orca.TOGGLE

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

    @Published var clicks: [Int] = []

    @Published var blackDead: Int = 0
    @Published var whiteDead: Int = 0

    @Published var sgfUrl: URL?
    @Published var sgfEncoding: String?

    init() {
        count = UserDefaults.standard.object(forKey: "Orca.count") as? Int ?? 0
        angle = UserDefaults.standard.object(forKey: "Orca.angle") as? Double ?? 0.0
        color = UserDefaults.standard.object(forKey: "Orca.color") as? Int ?? Orca.BLACK
        turns = UserDefaults.standard.object(forKey: "Orca.turns") as? Int ?? Orca.TOGGLE
        stones = UserDefaults.standard.object(forKey: "Orca.stones") as? [Int] ?? Array(repeating: 0, count: 361)
        clicks = UserDefaults.standard.object(forKey: "Orca.clicks") as? [Int] ?? []
        blackDead = UserDefaults.standard.object(forKey: "Orca.blackDead") as? Int ?? 0
        whiteDead = UserDefaults.standard.object(forKey: "Orca.whiteDead") as? Int ?? 0
    }

    func save() {
        UserDefaults.standard.set(count, forKey: "Orca.count")
        UserDefaults.standard.set(color, forKey: "Orca.color")
        UserDefaults.standard.set(turns, forKey: "Orca.turns")
        UserDefaults.standard.set(stones, forKey: "Orca.stones")
        UserDefaults.standard.set(clicks, forKey: "Orca.clicks")
        UserDefaults.standard.set(blackDead, forKey: "Orca.blackDead")
        UserDefaults.standard.set(whiteDead, forKey: "Orca.whiteDead")
    }

    func clear() {
        color = Orca.BLACK
        turns = Orca.TOGGLE
        stones = Array(repeating: 0, count: 361)
        blackDead = 0
        whiteDead = 0
    }

    func reset() {
        count = 0
        clear()
        clicks.removeAll()
    }

    func active() {
        if let image = UserDefaults.standard.object(forKey: "Orca.board") as? String? ?? "Darker" {
            board = image
        }
    }

    func inactive() {
        //
    }

    func background() {
        //
    }

    func click(index: Int) {
        if (stones[index] == Orca.EMPTY) {
            stones[index] = color
            if (turns == Orca.TOGGLE) {
                color = (color == Orca.BLACK) ? Orca.WHITE : Orca.BLACK
            }
        } else {
            if (stones[index] == Orca.BLACK) {
                blackDead += 1
            }
            if (stones[index] == Orca.WHITE) {
                whiteDead += 1
            }
            stones[index] = Orca.EMPTY
        }
    }

    func clickStone(index: Int) {
        click(index: index)
        clicks.append(index)
        count += 1
        save()
    }

    func clickDelete() {
        if (clicks.count > 0) {
            clicks.removeLast()
            clear()
            for index in clicks {
                click(index: index)
            }
            save()
        }
    }

    func clickTrash() {
        if (trash > 0) {
            reset()
            save()
            trash = 0
        } else {
            trash += 1

            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if (self.trash > 0) {
                    self.trash = 0
                }
            }
        }
    }

    func trashRole() -> ButtonRole? {
        return trash == 1 ? .destructive : .none
    }

    func turnImageName() -> String {
        if (turns == Orca.TOGGLE) {
            return color == Orca.BLACK ? "circle.lefthalf.filled" : "circle.righthalf.filled"
        } else {
            return color == Orca.BLACK ? "circle.filled" : "circle"
        }
    }
}
