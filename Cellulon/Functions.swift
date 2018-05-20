//
//  Functions.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-22.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

func log2(_ exponent: Int) -> Int {
    return Int(log2(Double(exponent)))
}

func pow2(_ exponent: Int) -> Int {
    return Int(pow(2.0, Double(exponent)))
}

func areaForOrder(_ ord : Int) -> Int {
    let dim = pow2(ord)
    return dim * dim
}

func firstBit(_ n: Int) -> Int {
    var result = 0
    var temp = n
    while temp > 0 {
        temp >>= 1
        result += 1
    }
    return result
}
