//
//  Branch.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

func pow2(exponent: Int) -> Int {
    return Int(pow(2.0, Double(exponent)))
}

func log2(exponent: Int) -> Int {
    return Int(log2(Double(exponent)))
}

func firstBit(n: Int) -> Int {
    var result = 0
    var temp = n
    while temp > 0 {
        temp >>= 1
        ++result
    }
    return result
}

enum Sector : Int {
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

    public typealias Address = GridPoint

    // MARK: Grid
    
    let root: Branch?
    var limbs: [Grid<V>] {
        return [Grid<V>](_limbs.values)
    }
    
    override public func valueAtPoint(point: GridPoint) -> V {
        return limbForPoint(point).valueAtPoint(point)
    }
    
    override public func setValue(value: V, atPoint point: GridPoint) {
        limbForPoint(point).setValue(value, atPoint: point)
    }
    
    override public func indexForPoint(point: GridPoint) -> Int {
        return indexOffsetForPoint(point) + super.indexForPoint(point - originForPoint(point))
    }
    
    // MARK: New

    required public init(def: V, dim: Int, lev: Int, root: Branch?) {
        self.root = root
        self.lev = lev
        self.leafDim = Branch.leafDimForDim(dim, level: lev)
        onBuild = {_,_ in }
        super.init(def: def, dim: dim)
    }
    
    let lev: Int
    private var _limbs = [ Sector : Grid<V> ]()
    
    let leafDim: Int
    var onBuild: (branch: Branch, sector: Sector) -> Void
    
    static func leafDimForDim(dim: Int, level lev: Int) -> Int {
        return dim / pow2(lev)
    }
    
    func indexOffsetForPoint(point: GridPoint) -> Int {
        return leafIndexForPoint(point) * leafDim * leafDim
    }
    
    func leafIndexForPoint(point: GridPoint) -> Int {
        
        var address = addressForPoint(point)
        var level = Branch.levelForAddress(address)
        var total = 0
        repeat {
            let levelDim = pow2(level)
            let block = levelDim * levelDim
            total += ((address.x >= levelDim ? 1 : 0) + (address.y >= levelDim ? 2 : 0)) * block
            address = address - Address(n: levelDim)
            --level
        }
        while level > 0
        
        return total
    }
    
    func originForPoint(point: GridPoint) -> GridPoint {
        return addressForPoint(point) * leafDim
    }
    
    func addressForPoint(point: GridPoint) -> Address {
        return point / leafDim
    }
    
    public static func levelForAddress(address: Address) -> Int {
        return log2(address.max())
    }

    func limbForPoint(point: GridPoint) -> Grid<V> {
        let sector = sectorForPoint(point)
        if let limb = _limbs[sector] {
            return limb
        }
        else {
            _limbs[sector] = newLimbForPoint(point)
            onBuild(branch: self, sector: sector)
            return _limbs[sector]!
        }
    }
    
    func sectorForPoint(point: GridPoint) -> Sector {
        return Sector.sectorForPoint(point, dim: dim)
    }
    
    func newLimbForPoint(point: GridPoint) -> Grid<V> {
        return lev > 1 ? newLimb() : newLeafForPoint(point)
    }
    
    func newLeafForPoint(point: GridPoint) -> Leaf<V> {
        return self.newLeafWithIndex(leafIndexForPoint(point))
    }
    
    func newLeafWithIndex(index: Int) -> Leaf<V> {
        return Leaf<V>(index: index, def: def, dim: dim)
    }
    
    func newLimb() -> Branch {
        return Branch(def: def, dim: dim, lev: lev-1, root: self)
    }
}
