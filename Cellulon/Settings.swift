//
//  Settings.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-23.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

class Settings: UIViewController, UINavigationBarDelegate, UITableViewDelegate, RuleKeeper {
    
    var rule: UInt8 = 113 {
        didSet {
            if ruleBits != nil {
                ruleBits.rule = rule
            }
            tableView?.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
        }
    }
    
    var table: Table = Table()
    var ruleBits: RuleBitsView!

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        loadRuleBits()
        table.sections.append(BitFlagSection(ruleKeeper: self))
        table.sections.append(EmptySection())
        tableView.delegate = self
        tableView.dataSource = table
    }
    
    func loadRuleBits() {
        let nib = UINib(nibName: "RuleBitsView", bundle: nil)
        ruleBits = nib.instantiateWithOwner(nil, options: nil).first as! RuleBitsView
        ruleBits.ruleKeeper = self
        ruleBits.rule = rule
    }
    
    // MARK:
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 66
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? ruleBits : nil
    }
    
    // MARK: Actions
    
    @IBAction func dismiss() {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
