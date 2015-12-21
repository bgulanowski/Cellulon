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
    
    var automaton = Automaton1_5(rule: 0)
    var timer: NSTimer!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.magnificationFilter = "nearest"
        update()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "update", userInfo: nil, repeats: true)
    }

    func update() {
        let rule = automaton.rule == 255 ? 0 : automaton.rule + 1
        automaton = Automaton1_5(rule: rule)
        automaton[GridPoint(x: (automaton.dim / 2), y: 0)] = true
        automaton.complete()
        imageView.image = Bitmap(grid: automaton).image
    }
}
