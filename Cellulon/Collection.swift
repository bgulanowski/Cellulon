//
//  Collection.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-27.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import Foundation

class Collection: NSObject, UICollectionViewDataSource {
    
    var sections = [CollectionSection]()
    
    @objc func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].numberOfItems
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return sections[indexPath.section].cellForCollectionView(collectionView, index: indexPath.row)
    }
}

protocol CollectionSection {
    var numberOfItems: Int { get }
    func cellForCollectionView(_ collectionView: UICollectionView, index: Int) -> UICollectionViewCell
}

protocol CollectionItem {
    func cellForCollectionView(_ collectionView: UICollectionView) -> UICollectionViewCell
}
