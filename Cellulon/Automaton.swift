//
//  Automaton.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-12.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

extension UInt8 {
    func test1(_ l: Bool, _ m:Bool, _ r:Bool) -> Bool {
        let li = l ? 1 : 0;
        let lm = m ? 1 : 0;
        let lr = r ? 1 : 0;
        let val = (li << 2) | (lm << 1) | lr
        return (self & UInt8(1 << val)) > 0
    }
}

func left(_ p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x-1, y: p.y)
}

func right(_ p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x+1, y: p.y)
}

func below(_ p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x, y: p.y-1)
}

func above(_ p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x, y: p.y+1)
}

func belowLeft(_ p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x-1, y: p.y-1)
}

func belowRight(_ p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x+1, y: p.y-1)
}

func aboveLeft(_ p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x-1, y: p.y+1)
}

func aboveRight(_ p: GridPoint) -> GridPoint {
    return GridPoint(x: p.x+1, y: p.y+1)
}

// Returns the exponent and value of the next power of 2 greater than n
public func nextPowerOf2Log(_ n: Int) -> (Int, Int) {
    var p = MemoryLayout<Int>.size * 8 - 2
    var v = 1 << p
    while v > n {
        p -= 1
        v >>= 1
    }
    return (p + 1, v << 1)
}

// MARK: -

public protocol Automaton {
    associatedtype Cell
    func next(_ index: Int) -> Cell
    func update() -> Void
    func reset() -> Void
}

open class Automaton1 : Automaton {
    
    public typealias Cell = Bool
    
    let size = 128
    var cells: [Cell]
    let rule: UInt8
    
    // FIXME: we need to set an initial value for first generation
    init(rule: UInt8) {
        self.cells = [Cell](repeating: false, count: size)
        self.rule = rule
    }
    
    convenience init() {
        self.init(rule: UInt8(arc4random()))
    }
    
    open func next(_ index: Int) -> Cell {
        if index == 0 || index == size-1 {
            return cells[index]
        }
        else {
            return rule.test1(cells[index-1], cells[index], cells[index+1])
        }
    }
    
    open func update() {
        var newCells = [Cell](repeating: false, count: size)
        for i in 1...126 {
            newCells[i] = next(i)
        }
        cells = newCells
    }
    
    open func reset() {
    }
}

// MARK: -

open class AutomatonGrid: BasicGrid<Bool> {
    
    public typealias Cell = Bool

    let w: Int
    let h: Int
    
    open override var width: Int {
        return w
    }
    
    open override var height: Int {
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

open class Automaton1_5 : AutomatonGrid, Automaton {
    
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
        self.init(rule: UInt8(arc4random()), w: 128, h: 128)
    }
    
    // MARK: Automaton
    
    open func update() {
        if generation < maxGenerations {
            generation += 1
            for i in 0 ..< w {
                self[pointForCellIndex(i)] = next(i)
            }
        }
    }
    
    open func next(_ index: Int) -> Cell {
        let point = below(pointForCellIndex(index))
        if index == 0 || index == dim-1 {
            return self[point]
        }
        else {
            return rule.test1(self[left(point)], self[point], self[right(point)])
        }
    }
    
    open func reset() {
        generation = 0
    }
    
    func complete() {
        for _ in generation ..< maxGenerations {
            update()
        }
    }
    
    final func pointForCellIndex(_ index: Int) -> GridPoint {
        return GridPoint(x: index, y: generation)
    }
}

// MARK: -

open class Automaton2 : AutomatonGrid, Automaton {
    
    final public func next(_ index: Int) -> Cell {
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
        var newCells = [Bool](repeating: false, count: count)
        for i in 0 ..< width {
            for j in 0 ..< height {
                let index = i + dim * j
                newCells[index] = next(index)
            }
        }
        values = newCells
    }
    
    final public func reset() -> Void {
        values = [Bool](repeating: false, count: count)
    }
    
    final public func populate() -> Void {
        let imageCount = width * height
        let living = (imageCount/4) + Int(arc4random()) % imageCount/4
        for _ in 0 ..< living {
            let imageIndex = Int(arc4random())%imageCount
            let gridIndex = imageIndex / width * dim + imageIndex % width
            values[gridIndex] = true
        }
    }
    
    final func pointOnEdge(_ point: GridPoint) -> Bool {
        return point.x == minPoint.x || point.y == minPoint.y || point.x == maxPoint.x || point.y == maxPoint.y
    }

    final func neighbourCount(_ point: GridPoint) -> Int {
        
        let index = indexForPoint(point)
        
        var count = 0
        
        // Sides
        if point.x > 0 && values[index-1] {
            count += 1
        }
        if point.x < width && values[index+1] {
            count += 1
        }
        if point.y > 0 && values[index-dim] {
            count += 1
        }
        if point.y < height && values[index+dim] {
            count += 1
        }
        
        // Corners
        if point.x > 0 && point.y > 0 && values[index-1-dim] {
            count += 1
        }
        if point.x < width && point.y > 0 && values[index+1-dim] {
            count += 1
        }
        if point.x > 0 && point.y < height && values[index-1+dim] {
            count += 1
        }
        if point.x < width && point.y < height && values[index+1+dim] {
            count += 1
        }
        
        return count
    }
}
