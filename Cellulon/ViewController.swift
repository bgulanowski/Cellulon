//
//  ViewController.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-11-29.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var automaton: Automaton1_5!
    var firstAppearance = true
    var settings: Settings?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.magnificationFilter = "nearest"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if settings != nil {
            automaton = Automaton1_5(rule: settings!.rule, w: automaton.w, h: automaton.h)
            makeImage()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppearance {
            showFirstTime()
            firstAppearance = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "settings_1_5" {
            let settings = segue.destinationViewController as! Settings
            settings.rule = automaton.rule
            self.settings = settings
        }
    }
    
    func showFirstTime() {
        let size = imageView.bounds.size
        automaton = Automaton1_5(rule: 169, w: Int(size.width), h: Int(size.height))
        makeImage()
    }

    func update() {
        let rule = automaton.rule == 255 ? 0 : automaton.rule + 1
        automaton = Automaton1_5(rule: rule, w: automaton.w, h: automaton.h)
        makeImage()
    }
    
    func makeImage() {
        automaton[GridPoint(x: (automaton.w / 2), y: 0)] = true
        automaton.complete()
        imageView.image = Bitmap(grid: automaton).image
    }
}
