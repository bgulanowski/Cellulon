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
    
    fileprivate var automaton: Automaton1_5!
    fileprivate var firstAppearance = true
    fileprivate var settings: Settings?
    fileprivate var edgesWrap = false
    fileprivate var firstGen = FirstGeneration.default

    var singleTapGR: UITapGestureRecognizer!
    var doubleTapGR: UITapGestureRecognizer!

    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(Automaton1_5VC.showSettings(_:)))
        imageView.layer.magnificationFilter = "nearest"
        singleTapGR = UITapGestureRecognizer(target: self, action: #selector(Automaton1_5VC.toggleBars(_:)))
        doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(Automaton1_5VC.saveImage(_:)))
        doubleTapGR.numberOfTapsRequired = 2
        singleTapGR.require(toFail: doubleTapGR)
        imageView.addGestureRecognizer(singleTapGR)
        imageView.addGestureRecognizer(doubleTapGR)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if settings != nil {
            updateWithRule(settings!.rule, width: automaton.w, height: automaton.h, firstGen: settings!.firstGeneration, edgesWrap: false)
            settings = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppearance {
            showFirstTime()
            firstAppearance = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == settingsSegueID {
            let settings = segue.destination as! Settings
            settings.rule = automaton.rule
            settings.firstGeneration = firstGen
            self.settings = settings
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer == singleTapGR || otherGestureRecognizer == doubleTapGR
    }
    
    // MARK: New
    
    func showFirstTime() {
        let size = view.bounds.size
        updateWithRule(rule, width: Int(size.width), height: Int(size.height), firstGen: .default, edgesWrap: false)
    }

    func updateWithRule(_ rule: Rule, width: Int, height: Int, firstGen: FirstGeneration, edgesWrap: Bool) {
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
    func showSettings(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: settingsSegueID, sender: sender)
    }
    
    @IBAction func toggleBars(_ sender: UITapGestureRecognizer) {
        if let nav = self .navigationController {
            let hidden = nav.isNavigationBarHidden
            nav.setNavigationBarHidden(!hidden, animated: true)
        }
    }
    
    @IBAction func saveImage(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Save Image", message: "Where would you like to save the image?", preferredStyle: .alert)
        let photosAction = UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            // TODO:
        })
        photosAction.isEnabled = false
        alert.addAction(photosAction)
        alert.addAction(UIAlertAction(title: "Documents", style: .default, handler: { (action: UIAlertAction) in
            self.saveImageToDocuments()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func saveImageToDocuments() {
        if let image = imageView.image {
            if let directory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first {
                let url = URL(fileURLWithPath: directory).appendingPathComponent("Rule \(rule).png")
                try? UIImagePNGRepresentation(image)?.write(to: url, options: [.atomic])
                print("saved image to %@", url)
            }
        }
    }
}

extension FirstGeneration {
    func updateAutomaton(_ automaton: Automaton1_5) {
        switch self {
        case .default:
            automaton[GridPoint(x: (automaton.w / 2), y: 0)] = true
            
        case .random:
            var index: Int = FirstGeneration.random.rawValue % 8
            repeat {
                automaton[GridPoint(x: index, y: 0)] = true
                index += Int(arc4random()) % 8
            } while index < automaton.w
            
        case .dots:
            for index in stride(from: 0, to: automaton.w, by: 2) {
                automaton[GridPoint(x: index, y: 0)] = true
            }
            
        case .dashes:
            for index in stride(from: 0, to: automaton.w - 8, by: 8) {
                for offset in index ..< index+4 {
                    automaton[GridPoint(x: offset, y: 0)] = true
                }
            }
        }
    }
}
