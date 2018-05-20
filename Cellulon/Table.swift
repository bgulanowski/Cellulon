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
    
    // MARK: UITableViewDataSource
    
    @objc func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].tableView(tableView, cellForRowAtIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footerTitle
    }
}

protocol TableSection {
    var numberOfRows: Int { get }
    var headerTitle: String { get }
    var footerTitle: String { get }
    func tableView(_ tableView: UITableView, cellForRowAtIndex index: Int) -> UITableViewCell
}

protocol TableRow {
    func cellForTableView(_ tableView: UITableView) -> UITableViewCell
}
