//
//  ViewController.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-11-29.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

class Automaton1_5VC: UIViewController {
    
    var rule: Rule = 165
    
    private var automaton: Automaton1_5!
    private var firstAppearance = true
    private var settings: Settings?
    private var edgesWrap = false
    private var firstGen = FirstGeneration.Default
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.magnificationFilter = "nearest"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if settings != nil {
            updateWithRule(settings!.rule, width: automaton.w, height: automaton.h, firstGen: settings!.firstGeneration, edgesWrap: false)
            settings = nil
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
            settings.firstGeneration = firstGen
            self.settings = settings
        }
    }
    
    func showFirstTime() {
        let size = imageView.bounds.size
        updateWithRule(rule, width: Int(size.width), height: Int(size.height), firstGen: .Default, edgesWrap: false)
    }

    func updateWithRule(rule: Rule, width: Int, height: Int, firstGen: FirstGeneration, edgesWrap: Bool) {
        automaton = Automaton1_5(rule: rule, w: width, h: height)
        self.firstGen = firstGen
        self.edgesWrap = edgesWrap
        firstGen.updateAutomaton(automaton)
        makeImage()
    }
    
    func makeImage() {
        automaton.complete()
        imageView.image = Bitmap(grid: automaton).image
    }
}

extension FirstGeneration {
    func updateAutomaton(automaton: Automaton1_5) {
        switch self {
        case .Default:
            automaton[GridPoint(x: (automaton.w / 2), y: 0)] = true
            
        case .Random:
            var index = random() % 8
            repeat {
                automaton[GridPoint(x: index, y: 0)] = true
                index += random() % 8
            } while index < automaton.w
            
        case .Dots:
            for index in 0.stride(to: automaton.w, by: 2) {
                automaton[GridPoint(x: index, y: 0)] = true
            }
            
        case .Dashes:
            for index in 0.stride(to: automaton.w - 8, by: 8) {
                for offset in index ..< index+4 {
                    automaton[GridPoint(x: offset, y: 0)] = true
                }
            }
        }
    }
}
