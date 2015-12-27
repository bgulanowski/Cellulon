//
//  Automaton.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-12.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

extension UInt8 {
    func test(l: Bool, _ m:Bool, _ r:Bool) -> Bool {
        let val = (Int(l) << 2) | (Int(m) << 1) | Int(r)
        return (self & UInt8(1 << val)) > 0
    }
}

func left(p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x-1, y: p.y)
}

func right(p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x+1, y: p.y)
}

func above(p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x, y: p.y+1)
}

func below(p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x, y: p.y-1)
}

// Returns the exponent and value of the next power of 2 greater than n
public func nextPowerOf2Log(n: Int) -> (Int, Int) {
    var p = 62
    var v = 1 << p
    while v > n {
        --p
        v >>= 1
    }
    return (p + 1, v << 1)
}

// MARK: -

protocol Automaton {
    typealias Cell
    func update() -> Void
    func next(index: Int) -> Cell
    func reset() -> Void
}

class Automaton1 : Automaton {
    
    typealias Cell = Bool
    
    let size = 128
    var cells: [Cell]
    let rule: UInt8
    
    // FIXME: we need to set an initial value for first generation
    init(rule: UInt8) {
        self.cells = [Cell](count: size, repeatedValue: false)
        self.rule = rule
    }
    
    convenience init() {
        self.init(rule: UInt8(random()))
    }
    
    func update() {
        var newCells = [Cell](count: size, repeatedValue: false)
        for i in 1...126 {
            let nexti = next(i)
            if nexti {
                newCells[i] = nexti
            }
        }
        cells = newCells
    }
    
    func next(index: Int) -> Cell {
        if index == 0 || index == size-1 {
            return cells[index]
        }
        else {
            return rule.test(cells[index-1], cells[index], cells[index+1])
        }
    }
    
    func reset() {
    }
}

class Automaton1_5 : BasicGrid<Bool>, Automaton {
    
    typealias Cell = Bool
    
    var generation = 0
    let rule: UInt8
    let w: Int
    let h: Int
    
    override var width: Int {
        return w
    }
    
    override var height: Int {
        return h
    }
    
    var maxGenerations: Int {
        return h - 1
    }
    
    var border: Int {
        return (dim - w) / 2
    }
    
    // FIXME: we need to set an initial value for first generation
    init(rule: UInt8, w: Int, h: Int) {
        self.rule = rule
        self.w = w
        self.h = h
        let ord = nextPowerOf2Log(max(w, h)).0
        super.init(def: false, ord: ord)
    }
    
    convenience init() {
        self.init(rule: UInt8(random()), w: 128, h: 128)
    }
    
    func update() {
        if generation < maxGenerations {
            ++generation
            for i in 0 ..< w {
                self[pointForCellIndex(i)] = next(i)
            }
        }
    }
    
    func pointForCellIndex(index: Int) -> GridPoint {
        return GridPoint(x: index, y: generation)
    }
    
    func next(index: Int) -> Cell {
        let point = below(pointForCellIndex(index))
        if index == 0 || index == dim-1 {
            return self[point]
        }
        else {
            return rule.test(self[left(point)], self[point], self[right(point)])
        }
    }
    
    func reset() {
        generation = 0
    }
    
    func complete() {
        for _ in generation ..< maxGenerations {
            update()
        }
    }
}
