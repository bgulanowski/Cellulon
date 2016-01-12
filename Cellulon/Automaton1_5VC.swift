//
//  ViewController.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-11-29.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

let settingsSegueID = "settings"

class Automaton1_5VC: UIViewController, UIGestureRecognizerDelegate {
    
    var rule: Rule = 165
    
    private var automaton: Automaton1_5!
    private var firstAppearance = true
    private var settings: Settings?
    private var edgesWrap = false
    private var firstGen = FirstGeneration.Default

    var singleTapGR: UITapGestureRecognizer!
    var doubleTapGR: UITapGestureRecognizer!

    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: "showSettings:")
        imageView.layer.magnificationFilter = "nearest"
        singleTapGR = UITapGestureRecognizer(target: self, action: "toggleBars:")
        doubleTapGR = UITapGestureRecognizer(target: self, action: "saveImage:")
        doubleTapGR.numberOfTapsRequired = 2
        singleTapGR.requireGestureRecognizerToFail(doubleTapGR)
        imageView.addGestureRecognizer(singleTapGR)
        imageView.addGestureRecognizer(doubleTapGR)
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
        if segue.identifier == settingsSegueID {
            let settings = segue.destinationViewController as! Settings
            settings.rule = automaton.rule
            settings.firstGeneration = firstGen
            self.settings = settings
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer == singleTapGR || otherGestureRecognizer == doubleTapGR
    }
    
    // MARK: New
    
    func showFirstTime() {
        let size = view.bounds.size
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
    
    // MARK: Actions
    func showSettings(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier(settingsSegueID, sender: sender)
    }
    
    @IBAction func toggleBars(sender: UITapGestureRecognizer) {
        if let nav = self .navigationController {
            let hidden = nav.navigationBarHidden
            nav.setNavigationBarHidden(!hidden, animated: true)
        }
    }
    
    @IBAction func saveImage(sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Save Image", message: "Where would you like to save the image?", preferredStyle: .Alert)
        let photosAction = UIAlertAction(title: "Photo Library", style: .Default, handler: { (action: UIAlertAction) in
            // TODO:
        })
        photosAction.enabled = false
        alert.addAction(photosAction)
        alert.addAction(UIAlertAction(title: "Documents", style: .Default, handler: { (action: UIAlertAction) in
            self.saveImageToDocuments()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveImageToDocuments() {
        if let image = imageView.image {
            if let directory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first {
                let url = NSURL(fileURLWithPath: directory).URLByAppendingPathComponent("Rule \(rule).png")
                UIImagePNGRepresentation(image)?.writeToURL(url, atomically: true)
                print("saved image to %@", url)
            }
        }
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
