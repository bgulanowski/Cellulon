//
//  SettingsTable.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-26.
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Pattern") as! PatternCell
        cell.ruleKeeper = self
        cell.number = index
        return cell
    }
}
