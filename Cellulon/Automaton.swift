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

func below(p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x, y: p.y-1)
}

func above(p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x, y: p.y+1)
}

func belowLeft(p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x-1, y: p.y-1)
}

func belowRight(p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x+1, y: p.y-1)
}

func aboveLeft(p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x-1, y: p.y+1)
}

func aboveRight(p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x+1, y: p.y+1)
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
    func next(index: Int) -> Cell
    func update() -> Void
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
    
    func next(index: Int) -> Cell {
        if index == 0 || index == size-1 {
            return cells[index]
        }
        else {
            return rule.test1(cells[index-1], cells[index], cells[index+1])
        }
    }
    
    func update() {
        var newCells = [Cell](count: size, repeatedValue: false)
        for i in 1...126 {
            newCells[i] = next(i)
        }
        cells = newCells
    }
    
    func reset() {
    }
}

// MARK: -

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
    
    // MARK: Automaton
    
    func update() {
        if generation < maxGenerations {
            ++generation
            for i in 0 ..< w {
                self[pointForCellIndex(i)] = next(i)
            }
        }
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
    
    func pointForCellIndex(index: Int) -> GridPoint {
        return GridPoint(x: index, y: generation)
    }
}

// MARK: -

class Automaton2 : BasicGrid<Bool>, Automaton {
    
    typealias Cell = Bool

    func next(index: Int) -> Cell {
        let point = pointForIndex(index)
        if pointOnEdge(point) {
            return valueAtPoint(point)
        }
        else {
            let count = neighbourCount(point)
            return count > 1 && count < 4
        }
    }
    
    func update() -> Void {
        var newCells = [Bool](count: count, repeatedValue: false)
        for i in 0 ..< count {
            newCells[i] = next(i)
        }
        values = newCells
    }
    
    func reset() -> Void {
        values = [Bool](count: count, repeatedValue: false)
    }
    
    func pointOnEdge(point: GridPoint) -> Bool {
        return point.x == minPoint.x || point.y == minPoint.y || point.x == maxPoint.x || point.y == maxPoint.y
    }

    func neighbourCount(point: GridPoint) -> Int {
        
        var count = 0
        
        if point.x > 0 && valueAtPoint(left(point)) {
            ++count
        }
        if point.x < width && valueAtPoint(right(point)) {
            ++count
        }
        if point.y > 0 && valueAtPoint(below(point)) {
            ++count
        }
        if point.y < height && valueAtPoint(above(point)) {
            ++count
        }
        
        if point.x > 0 && point.y > 0 && valueAtPoint(belowLeft(point)) {
            ++count
        }
        if point.x < width && point.y > 0 && valueAtPoint(belowRight(point)) {
            ++count
        }
        if point.x > 0 && point.y < height && valueAtPoint(aboveLeft(point)) {
            ++count
        }
        if point.x < width && point.y < height && valueAtPoint(aboveRight(point)) {
            ++count
        }
        
        return count
    }
}
