//
//  TreeGrid.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

private protocol Grid_ {
    func valueAtPoint(point: GridPoint) -> Int
    func setValue(value: Int, atPoint point: GridPoint) -> Void
}

private protocol Tree_ {
    var root: Tree_? { get }
    var limbs: [Grid_] { get }
    init(root: Tree_?)
    func addLimb(limb: Grid_)
    func remLimb(limb: Grid_)
}

private class Branch : Grid_, Tree_ {
    
    let root: Tree_?
    var limbs = [Grid_]()
    
    func valueAtPoint(point: GridPoint) -> Int {
        return 0
    }
    func setValue(value: Int, atPoint point: GridPoint) {
        
    }
    
   required init(root: Tree_?) {
        self.root = root
    }
    
    func addLimb(limb: Grid_) {
        
    }
    
    func remLimb(limb: Grid_) {
        
    }
}

private class Leaf : Grid_ {
    func valueAtPoint(point: GridPoint) -> Int {
        return 0
    }
    func setValue(value: Int, atPoint point: GridPoint) {
        
    }
}
