//
//  Branch.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

public func pow(base: Int, _ exponent: Int) -> Int {
    return Int(pow(Double(base), Double(exponent)))
}

public enum Sector : Int {
    case s0 = 0
    case s1 = 1
    case s2 = 2
    case s3 = 3

    static func sectorForPoint(point: GridPoint, dim: Int) -> Sector {
        return self.init(rawValue: (point.x > dim ? 0 : 1) + (point.y > dim ? 0 : 2))!
    }
    
    static func sectorForPoint(point: GridPoint) -> Sector {
        return Sector.sectorForPoint(point, dim: 0)
    }
}

public class Branch<V> : Grid<V> {
    
    // MARK: Grid
    
    let root: Branch?
    var limbs: [Grid<V>] {
        return [Grid<V>](_limbs.values)
    }
    
    override func valueAtPoint(point: GridPoint) -> V {
        return limbForPoint(point).valueAtPoint(point)
    }
    
    override func setValue(value: V, atPoint point: GridPoint) {
        limbForPoint(point).setValue(value, atPoint: point)
    }
        
    required public init(def: V, dim: Int, lev: Int, root: Branch?) {
        self.root = root
        self.lev = lev
        self.leafDim = Branch.leafDimForDim(dim, level: lev)
        onBuild = {_,_ in }
        super.init(def: def, dim: dim)
    }
    
    // MARK: New
    
    let lev: Int
    private var _limbs = [ Sector : Grid<V> ]()
    
    let leafDim: Int
    var onBuild: (branch: Branch, sector: Sector) -> Void
    
    static func leafDimForDim(dim: Int, level lev: Int) -> Int {
        return dim / pow(2, lev)
    }

    func limbForPoint(point: GridPoint) -> Grid<V> {
        let sector = sectorForPoint(point)
        if let limb = _limbs[sector] {
            return limb
        }
        else {
            let limb = newLimb()
            _limbs[sector] = limb
            onBuild(branch: self, sector: sector)
            return limb
        }
    }
    
    func sectorForPoint(point: GridPoint) -> Sector {
        return Sector.sectorForPoint(point, dim: dim)
    }
    
    func newLimb() -> Branch {
        return Branch(def: def, dim: dim, lev: lev-1, root: self)
    }
}
