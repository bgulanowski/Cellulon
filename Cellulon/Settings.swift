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
    var ruleBits: RuleBits!

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
        let nib = UINib(nibName: "RuleBits", bundle: nil)
        ruleBits = nib.instantiateWithOwner(nil, options: nil).first as! RuleBits
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
    var numberOfRows: Int {
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndex index: Int) -> UITableViewCell {
        return UITableViewCell()
    }
}

class BitFlagSection: TableSection, RuleKeeper {
    
    var ruleKeeper: RuleKeeper!
    
    init(ruleKeeper: RuleKeeper) {
        self.ruleKeeper = ruleKeeper
    }
    
    var rule: Rule {
        get {
            return ruleKeeper.rule
        }
        set {
            ruleKeeper.rule = newValue
        }
    }
    
    var numberOfRows: Int {
        return 8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndex index: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BitFlag") as! BitFlagCell
        cell.ruleKeeper = self
        cell.number = index
        return cell
    }
}

class RuleBits: UIView, BitViewDelegate {
    
    @IBOutlet var bit0: BitView!
    @IBOutlet var bit1: BitView!
    @IBOutlet var bit2: BitView!
    @IBOutlet var bit3: BitView!
    @IBOutlet var bit4: BitView!
    @IBOutlet var bit5: BitView!
    @IBOutlet var bit6: BitView!
    @IBOutlet var bit7: BitView!
    @IBOutlet weak var numberLabel: UILabel!
    
    var ruleKeeper: RuleKeeper!
    
    var bitViews: [BitView] {
        return [ bit0, bit1, bit2, bit3, bit4, bit5, bit6, bit7 ]
    }
    
    var rule: UInt8 {
        get {
            var rule = UInt8(0)
            for bitView in bitViews {
                rule.updateBit(bitView.tag, value: bitView.enabled)
            }
            return rule
        }
        set(value) {
            for bitView in bitViews {
                bitView.enabled = value.bit(bitView.tag)
            }
            updateNumberText()
        }
    }
    
    override func awakeFromNib() {
        for bitView in bitViews {
            bitView.delegate = self
        }
    }
    
    func updateNumberText() {
        numberLabel.text = "\(rule)"
    }
    
    // MARK: BitViewDelegate
    
    func bitViewChanged(bitView: BitView) {
        updateNumberText()
        ruleKeeper.rule = rule
    }
}

class BitFlagCell: UITableViewCell {
    
    var ruleKeeper: RuleKeeper!
    
    @IBOutlet var bit0View: BitView!
    @IBOutlet var bit1View: BitView!
    @IBOutlet var bit2View: BitView!
    
    @IBOutlet var enabledSwitch: UISwitch!
    
    var number: Int = 0 {
        didSet {
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

let borderColor = UIColor.grayColor()

protocol BitViewDelegate {
    func bitViewChanged(bitView: BitView)
}

class BitView : UIView {
    
    var delegate: BitViewDelegate? {
        didSet {
            if delegate != nil {
                self.userInteractionEnabled = true
                tapRecognizer = UITapGestureRecognizer(target: self, action: "didTap:")
                self.addGestureRecognizer(tapRecognizer!)
            }
            else if delegate == nil {
                self.userInteractionEnabled = false
                if tapRecognizer != nil {
                    self.removeGestureRecognizer(tapRecognizer!)
                    tapRecognizer = nil
                }
            }
        }
    }
    
    var tapRecognizer: UITapGestureRecognizer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureBit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBit()
    }
    
    func configureBit() {
        self.layer.borderColor = borderColor.CGColor
        self.layer.borderWidth = 1.0
    }
    
    var enabled: Bool = false {
        didSet {
            updateEnabled()
        }
    }

    func updateEnabled() {
        if enabled {
            enable()
        }
        else {
            disable()
        }
    }
    
    func enable() {
        self.backgroundColor = borderColor
    }
    
    func disable() {
        self.backgroundColor = UIColor.whiteColor()
    }
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        enabled = !enabled
        delegate?.bitViewChanged(self)
    }
}
