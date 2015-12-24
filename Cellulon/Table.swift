//
//  Table.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-23.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

class Table: NSObject, UITableViewDataSource {
    
    var sections = [TableSection]()
    
    @objc func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return sections[indexPath.section].tableView(tableView, cellForRowAtIndex: indexPath.row)
    }
}

protocol TableSection {
    var numberOfRows: Int { get }
    func tableView(tableView: UITableView, cellForRowAtIndex index: Int) -> UITableViewCell
}
