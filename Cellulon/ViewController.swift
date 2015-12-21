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
    
    var automaton: Automaton1_5!
    var timer: NSTimer!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.magnificationFilter = "nearest"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let size = imageView.bounds.size
        automaton = Automaton1_5(rule: 169, w: Int(size.width), h: Int(size.height))
        makeImage()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "update", userInfo: nil, repeats: true)
    }

    func update() {
        let rule = automaton.rule == 255 ? 0 : automaton.rule + 1
        automaton = Automaton1_5(rule: rule, w: automaton.w, h: automaton.h)
        makeImage()
    }
    
    func makeImage() {
        automaton[GridPoint(x: (automaton.w / 2), y: 0)] = true
        automaton.complete()
        imageView.image = Bitmap(automaton: automaton).image
    }
}
