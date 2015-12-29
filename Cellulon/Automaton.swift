//
//  Automaton.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-12.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

extension UInt8 {
    func test1(l: Bool, _ m:Bool, _ r:Bool) -> Bool {
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
    var p = sizeof(Int) * 8 - 2
    var v = 1 << p
    while v > n {
        --p
        v >>= 1
    }
    return (p + 1, v << 1)
}

// MARK: -

public protocol Automaton {
    typealias Cell
    func next(index: Int) -> Cell
    func update() -> Void
    func reset() -> Void
}

public class Automaton1 : Automaton {
    
    public typealias Cell = Bool
    
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
    
    public func next(index: Int) -> Cell {
        if index == 0 || index == size-1 {
            return cells[index]
        }
        else {
            return rule.test1(cells[index-1], cells[index], cells[index+1])
        }
    }
    
    public func update() {
        var newCells = [Cell](count: size, repeatedValue: false)
        for i in 1...126 {
            newCells[i] = next(i)
        }
        cells = newCells
    }
    
    public func reset() {
    }
}

// MARK: -

public class AutomatonGrid: BasicGrid<Bool> {
    
    public typealias Cell = Bool

    let w: Int
    let h: Int
    
    public override var width: Int {
        return w
    }
    
    public override var height: Int {
        return h
    }
    
    var border: Int {
        return (dim - w) / 2
    }
    
    public init(w: Int, h: Int) {
        self.w = w
        self.h = h
        let ord = nextPowerOf2Log(max(w, h)).0
        super.init(def: false, ord: ord)
    }
}

public class Automaton1_5 : AutomatonGrid, Automaton {
    
    var generation = 0
    let rule: UInt8
    
    var maxGenerations: Int {
        return h - 1
    }
    
    init(rule: UInt8, w: Int, h: Int) {
        self.rule = rule
        super.init(w: w, h: h)
    }
    
    convenience init() {
        self.init(rule: UInt8(random()), w: 128, h: 128)
    }
    
    // MARK: Automaton
    
    public func update() {
        if generation < maxGenerations {
            ++generation
            for i in 0 ..< w {
                self[pointForCellIndex(i)] = next(i)
            }
        }
    }
    
    public func next(index: Int) -> Cell {
        let point = below(pointForCellIndex(index))
        if index == 0 || index == dim-1 {
            return self[point]
        }
        else {
            return rule.test1(self[left(point)], self[point], self[right(point)])
        }
    }
    
    public func reset() {
        generation = 0
    }
    
    func complete() {
        for _ in generation ..< maxGenerations {
            update()
        }
    }
    
    final func pointForCellIndex(index: Int) -> GridPoint {
        return GridPoint(x: index, y: generation)
    }
}

// MARK: -

public class Automaton2 : AutomatonGrid, Automaton {
    
    final public func next(index: Int) -> Cell {
        let point = pointForIndex(index)
        var value = valueAtPoint(point)
        if !pointOnEdge(point) {
            let count = neighbourCount(point)
            if count == 3 {
                value = true
            }
            else if count != 2 {
                value = false
            }
        }
        return value
    }
    
    final public func update() -> Void {
        var newCells = [Bool](count: count, repeatedValue: false)
        for i in 0 ..< width {
            for j in 0 ..< height {
                let index = i + dim * j
                newCells[index] = next(index)
            }
        }
        values = newCells
    }
    
    final public func reset() -> Void {
        values = [Bool](count: count, repeatedValue: false)
    }
    
    final public func populate() -> Void {
        let imageCount = width * height
        let living = imageCount/4 + random() % (imageCount/4)
        for _ in 0 ..< living {
            let imageIndex = random()%imageCount
            let gridIndex = imageIndex / width * dim + imageIndex % width
            values[gridIndex] = true
        }
    }
    
    final func pointOnEdge(point: GridPoint) -> Bool {
        return point.x == minPoint.x || point.y == minPoint.y || point.x == maxPoint.x || point.y == maxPoint.y
    }

    final func neighbourCount(point: GridPoint) -> Int {
        
        let index = indexForPoint(point)
        
        var count = 0
        
        // Sides
        if point.x > 0 && values[index-1] {
            ++count
        }
        if point.x < width && values[index+1] {
            ++count
        }
        if point.y > 0 && values[index-dim] {
            ++count
        }
        if point.y < height && values[index+dim] {
            ++count
        }
        
        // Corners
        if point.x > 0 && point.y > 0 && values[index-1-dim] {
            ++count
        }
        if point.x < width && point.y > 0 && values[index+1-dim] {
            ++count
        }
        if point.x > 0 && point.y < height && values[index-1+dim] {
            ++count
        }
        if point.x < width && point.y < height && values[index+1+dim] {
            ++count
        }
        
        return count
    }
}
