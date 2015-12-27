//
//  Automaton1_5CollectionVC.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-27.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

private let reuseIdentifier = "a1_5Cell"

class Automaton1_5CollectionVC: UICollectionViewController {
    
    var cellDim: Int = 128
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
//        self.collectionView!.registerClass(A1_5Cell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        updateCellSize()
    }
    
    func updateCellSize() {
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        var itemWidth = layout.itemSize.width
        let screenWidth = UIScreen.mainScreen().bounds.width
        let columns: CGFloat = 3.0
        if screenWidth / columns < itemWidth {
            let spacing = layout.sectionInset.left + layout.sectionInset.right + layout.minimumInteritemSpacing * (columns - 1.0)
            itemWidth = floor((screenWidth - spacing)/3.0)
        }
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 37.0)
        cellDim = Int(itemWidth)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 256
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! A1_5Cell
        cell.dim = cellDim
        cell.rule = UInt8(indexPath.row)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
}
