//
//  ViewController.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-11-29.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

extension UInt8 : ColorConvertable {
    public init(color: Color) {
        self = UInt8(color.v)
    }
    public var color: Color {
        return Color(v: UInt32(self))
    }
}

class ViewController: UIViewController {
    
    let grid = Grid<UInt8>(def: 0, ord: 8)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

func makeBitmap() {
    
    
}

