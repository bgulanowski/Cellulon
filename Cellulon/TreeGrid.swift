//
//  TreeGrid.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

public enum Sector : Int {
    case s0 = 0
    case s1 = 1
    case s2 = 2
    case s3 = 3
}

public final class Branch<V> : Grid<V> {
    
    // MARK: Grid_
    
    let root: Branch?
    var limbs: [Grid<V>] {
        return [Grid<V>](_limbs.values)
    }
    
    let lev: Int
    
    override func valueAtPoint(point: GridPoint) -> V {
        return limbForPoint(point).valueAtPoint(point)
    }
    
    override func setValue(value: V, atPoint point: GridPoint) {
        limbForPoint(point).setValue(value, atPoint: point)
    }
        
    required public init(def: V, root: Branch?) {
        self.root = root
        lev = 1
        super.init(def: def)
    }
    
    // MARK: New
    
    private var _limbs = [ Sector : Grid<V> ]()

    func limbForPoint(point: GridPoint) -> Grid<V> {
        let sector = sectorForPoint(point)
        var limb : Grid<V>? = _limbs[sector]
        if limb == nil {
            limb = newLimb()
            _limbs[sector] = limb
        }
        return limb!
    }
    
    func sectorForPoint(point: GridPoint) -> Sector {
        // FIXME:
        return .s0
    }
    
    func newLimb() -> Branch {
        let limb = Branch(def: def, root: self)
        return limb
    }
}

public class Leaf<V> : Grid<V> {
    
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
