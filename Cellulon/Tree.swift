//
//  Tree.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-05.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

public class Tree<T> {
    
    let root: Tree?
    var limbs: [Int : T]
    
    init(root: Tree?, limbs: [Int : T]) {
        self.root = root
        self.limbs = limbs
    }
    
    convenience init(root: Tree?) {
        self.init(root: root, limbs: [Int : T]())
    }
    
    convenience init() {
        self.init(root: nil, limbs: [Int : T]())
    }
}
