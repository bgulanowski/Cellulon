//
//  Automaton1_5CollectionVC.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-27.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

private let reuseIdentifier = "a1_5Cell"

class Automaton1_5CollectionVC: UICollectionViewController, UINavigationControllerDelegate {
    
    var cellDim: Int = 128
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        updateCellSize()
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
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("detail", sender: self)
    }
    
    // MARK: UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        navigationController.setNavigationBarHidden(viewController === self, animated: true)
    }
    
    func updateCellSize() {
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let screenWidth = UIScreen.mainScreen().bounds.width
        let columns: CGFloat = 3.0
        
        var itemWidth = layout.itemSize.width
        if screenWidth / columns < itemWidth {
            let spacing = layout.sectionInset.left + layout.sectionInset.right + layout.minimumInteritemSpacing * (columns - 1.0)
            itemWidth = floor((screenWidth - spacing)/3.0)
        }
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 37.0)
        cellDim = Int(itemWidth)
    }
}
