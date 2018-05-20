//
//  Branch.swift
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

    static func sectorForPoint(_ point: GridPoint, dim: Int) -> Sector? {
        if dim == 0 || (point.x < dim * 2 && point.y < dim * 2) {
            return self.init(rawValue: (point.x > dim ? 0 : 1) + (point.y > dim ? 0 : 2))!
        }
        else {
            return nil
        }
    }
    
    static func sectorForPoint(_ point: GridPoint) -> Sector? {
        return Sector.sectorForPoint(point, dim: 0)
    }
}

open class Branch<V:ColorConvertible> : Grid<V> {

    public typealias Address = GridPoint

    // MARK: Grid
    
    let root: Branch?
    var limbs: [Grid<V>] {
        return [Grid<V>](_limbs.values)
    }
    
    override open func valueAtPoint(_ point: GridPoint) -> V {
        if let limb = limbForPoint(point) {
            return limb.valueAtPoint(offsetPointForLimbs(point))
        }
        else {
            return def
        }
    }
    
    override open func setValue(_ value: V, atPoint point: GridPoint) {
        if let limb = limbForPoint(point) {
            limb.setValue(value, atPoint: offsetPointForLimbs(point))
        }
    }
    
    override open func indexForPoint(_ point: GridPoint) -> Int {
        return indexOffsetForPoint(point) + super.indexForPoint(offsetPointForLimbs(point))
    }
    
    // MARK: Branch
    
    // Not yet supported!?
//    static var leafCache = [ Int : Leaf<V> ]()
    
    let lev: Int
    let idx: Int
    var address: Address {
        return Branch.addressForLevel(lev, index: idx)
    }
    fileprivate var _limbs = [ Sector : Grid<V> ]()

    required public init(def: V, ord: Int, lev: Int, idx: Int, root: Branch?) {
    
        self.root = root
        self.lev = lev
        self.idx = idx
        
        self.leafDim = pow2(ord)
        onBuild = {_,_ in }
        
        super.init(def: def, ord: ord)
    }
    
    public convenience override init(def: V, ord: Int) {
        self.init(def: def, ord: ord, lev: 1, idx: 0, root: nil)
    }
    
    public convenience init(def: V) {
        self.init(def: def, ord: 3, lev: 1, idx: 0, root: nil)
    }
    
    let leafDim: Int
    open var onBuild: (_ branch: Branch, _ sector: Sector) -> Void
    
    // MARK: - index calculations
        
    func indexOffsetForPoint(_ point: GridPoint) -> Int {
        return leafIndexForPoint(point) * leafDim * leafDim
    }
    
    func leafIndexForPoint(_ point: GridPoint) -> Int {
        
        var address = addressForPoint(point)
        let lev = Branch.levelForAddress(address) - 1
        var dim = pow2(lev)
        var total = 0
        while dim > 0 {
            let block = dim * dim
            total += ((address.x >= dim ? 1 : 0) + (address.y >= dim ? 2 : 0)) * block
            address = address % dim
            dim/=2
        }
        
        return total
    }
    
    func limbIndexForSector(_ sector: Sector) -> Int {
        return idx * 4 + sector.rawValue
    }
    
    // MARK: - point calculations
    
    func offsetPointForLimbs(_ point: GridPoint) -> GridPoint {
        return point - originForPoint(point)
    }
    
    func originForPoint(_ point: GridPoint) -> GridPoint {
        return addressForPoint(point) * leafDim
    }
    
    func limbAddressForSector(_ sector: Sector) -> Address {
        return self.address * 2 + addressForSector(sector)
    }
    
    func addressForSector(_ sector: Sector) -> Address {
        return Address(x: sector.rawValue & 1, y: sector.rawValue & 2)
    }
    
    // MARK: - address calculations
    
    func addressForPoint(_ point: GridPoint) -> Address {
        return point / leafDim
    }
    
    open static func levelForAddress(_ address: Address) -> Int {
        let maxDim = address.max()
        return maxDim > 0 ? log2(maxDim) + 1 : 0
    }
    
    open static func addressForLevel(_ level: Int, index: Int) -> Address {
        // FIXME: this is hard/expensive?
        return Address(n: 0)
    }
    
    // MARK: - descendent lookup
    
    func leafForPoint(_ point: GridPoint) -> Grid<V>? {
        var grid = limbForPoint(point)
        while grid != nil {
            // FIXME: type inspection
            if let branch = grid as! Branch? {
                grid = branch.limbForPoint(point)
            }
            else {
                break
            }
        }
        return grid
    }

    func limbForPoint(_ point: GridPoint) -> Grid<V>? {
        if let sector = sectorForPoint(point) {
            return limbForSector(sector)
        }
        else {
            return nil
        }
    }
    
    func sectorForPoint(_ point: GridPoint) -> Sector? {
        return Sector.sectorForPoint(point, dim: dim)
    }
    
    // MARK: - tree growth
    
    func newLimbForPoint(_ point: GridPoint) -> Grid<V> {
        return lev > 1 ? newLimbWithIndex(limbIndexForSector(sectorForPoint(point)!)) : newLeafForPoint(point)
    }
    
    func newLeafForPoint(_ point: GridPoint) -> Leaf<V> {
        return self.newLeafWithIndex(leafIndexForPoint(point))
    }
    
    func newLeafWithIndex(_ index: Int) -> Leaf<V> {
        return Leaf<V>(index: index, def: def, ord: ord)
    }
    
    func newLimbWithIndex(_ index: Int) -> Branch {
        return Branch(def: def, ord: ord, lev: lev-1, idx: index, root: self)
    }
    
    // MARK: - sector calculations
    
    func limbForSector(_ sector: Sector) -> Grid<V> {
        if let limb = _limbs[sector] {
            return limb
        }
        else {
            _limbs[sector] = newLimbForSector(sector)
            onBuild(self, sector)
            return _limbs[sector]!
        }
    }
    
    func newLimbForSector(_ sector: Sector) -> Grid<V> {
        return lev > 1 ? newLimbWithIndex(indexForSector(sector)) : newLeafForSector(sector)
    }
    
    func newLeafForSector(_ sector: Sector) -> Grid<V> {
        return newLeafWithIndex(indexForSector(sector))
    }
    
    func indexForSector(_ sector: Sector) -> Int {
        return idx * 4 + sector.rawValue
    }

}
