//
//  Settings.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-23.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

typealias Rule = UInt8

extension Rule {
    
    func bit(index: Int) -> Bool {
        return (Int(self) & 1 << index) > 0
    }
    
    mutating func updateBit(index: Int, value: Bool) {
        if value { setBit(index) } else { clearBit(index) }
    }
    
    mutating func setBit(index: Int) {
        self |= UInt8(1 << index)
    }
    
    mutating func clearBit(index: Int) {
        self &= ~(UInt8(1 << index))
    }
}

protocol RuleKeeper {
    var rule: UInt8 { get set }
}

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

class EmptySection: TableSection {
    
    // MARK: TableSection
    
    var numberOfRows: Int {
        return 0
    }
    var headerTitle: String {
        return ""
    }
    var footerTitle: String {
        return ""
    }
    func tableView(tableView: UITableView, cellForRowAtIndex index: Int) -> UITableViewCell {
        return UITableViewCell()
    }
}

class BitFlagSection: TableSection, RuleKeeper {
    
    var ruleKeeper: RuleKeeper!
    
    var rule: Rule {
        get {
            return ruleKeeper.rule
        }
        set {
            ruleKeeper.rule = newValue
        }
    }
    
    init(ruleKeeper: RuleKeeper) {
        self.ruleKeeper = ruleKeeper
    }
    
    // MARK: TableSection
    
    var numberOfRows: Int {
        return 8
    }
    
    var headerTitle: String {
        return ""
    }
    
    var footerTitle: String {
        return ""
    }

    func tableView(tableView: UITableView, cellForRowAtIndex index: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BitFlag") as! BitFlagCell
        cell.ruleKeeper = self
        cell.number = index
        return cell
    }
}

class BitFlagCell: UITableViewCell {
    
    var ruleKeeper: RuleKeeper!
    
    @IBOutlet var bit0View: BitView!
    @IBOutlet var bit1View: BitView!
    @IBOutlet var bit2View: BitView!
    
    @IBOutlet var label: UILabel!
    @IBOutlet var enabledSwitch: UISwitch!
    
    var number: Int = 0 {
        didSet {
            label.text = "\(number)"
            enabledSwitch.on = ruleKeeper.rule.bit(number)
            bit0View.enabled = (number & 1 == 1)
            bit1View.enabled = (number & 2 == 2)
            bit2View.enabled = (number & 4 == 4)
        }
    }
    
    @IBAction func updateEnabled(sender: UISwitch) {
        var rule = ruleKeeper.rule
        if sender.on {
            rule.setBit(number)
        }
        else {
            rule.clearBit(number)
        }
        ruleKeeper!.rule = rule
    }
}
