//
//  TreeGrid.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation


private protocol Tree_ {
    typealias Limb
    var root: Self? { get }
    var limbs: [Limb] { get }
    init(root: Self?)
    func addLimb(limb: Limb)
    func remLimb(limb: Limb)
}
public typealias GridPoint = PointI

private class Grid_<V> {
    
    private let def: V
    
    init(def: V) {
        self.def = def
    }
    
    func valueAtPoint(point: GridPoint) -> V {
        return def
    }
    
    func setValue(value: V, atPoint point: GridPoint) -> Void {
    }
}

private final class Branch<V> : Grid_<V> {
    
    // MARK: Grid_
    
    let root: Branch?
    var limbs: [Grid_<V>] {
        return [Grid_<V>](_limbs.values)
    }
    
    let lev: Int
    
    override func valueAtPoint(point: GridPoint) -> V {
        return limbForPoint(point).valueAtPoint(point)
    }
    
    override func setValue(value: V, atPoint point: GridPoint) {
        limbForPoint(point).setValue(value, atPoint: point)
    }
    
    // MARK: Tree_
    
    required init(def: V, root: Branch?) {
        self.root = root
        lev = 1
        super.init(def: def)
    }
    
    // MARK: New
    
    private var _limbs = [ Int : Grid_<V> ]()

    func limbForPoint(point: GridPoint) -> Grid_<V> {
        let sector = sectorForPoint(point)
        var limb : Grid_<V>? = _limbs[sector]
        if limb == nil {
            limb = newLimb()
            _limbs[sector] = limb
        }
        return limb!
    }
    
    func sectorForPoint(point: GridPoint) -> Int {
        return 0
    }
    
    func newLimb() -> Branch {
        let limb = Branch(def: def, root: self)
        return limb
    }
}

private class Leaf<V> : Grid_<V> {
    
    var values: [V]
    
    override init(def: V) {
        values = [V](count: 100, repeatedValue: def)
        super.init(def: def)
    }
    
    override func valueAtPoint(point: GridPoint) -> V {
        return values[indexForPoint(point)]
    }
    
    override func setValue(value: V, atPoint point: GridPoint) {
        values[indexForPoint(point)] = value
    }
    
    private final func indexForPoint(point: GridPoint) -> Int {
        return point.x + point.y * 10
    }
}
