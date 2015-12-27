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
    
    @objc func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    @objc func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].numberOfItems
    }
    
    @objc func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return sections[indexPath.section].cellForCollectionView(collectionView, index: indexPath.row)
    }
}

protocol CollectionSection {
    var numberOfItems: Int { get }
    func cellForCollectionView(collectionView: UICollectionView, index: Int) -> UICollectionViewCell
}

protocol CollectionItem {
    func cellForCollectionView(collectionView: UICollectionView) -> UICollectionViewCell
}
