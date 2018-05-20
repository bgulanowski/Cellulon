//
//  Automaton1_5CollectionVC.swift
//  Cellulon
//
//  Created by Brent Gulanowski on 2015-12-27.
//  Copyright © 2015 Lichen Labs. All rights reserved.
//

import UIKit

private let reuseIdentifier = "a1_5Cell"

private let detailSegueID = "detail"

class Automaton1_5CollectionVC: UICollectionViewController, UINavigationControllerDelegate {
    
    var cellDim: Int = 128
    var ruleToPresent: Rule = 0
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        updateCellSize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueID {
            let detail = segue.destination as! Automaton1_5VC
            detail.rule = ruleToPresent
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 256
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! A1_5Cell
        cell.dim = cellDim
        cell.rule = Rule(indexPath.row)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ruleToPresent = Rule(indexPath.row)
        performSegue(withIdentifier: detailSegueID, sender: self)
    }
    
    // MARK: UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.setNavigationBarHidden(viewController === self, animated: true)
    }
    
    // MARK: New
    
    func updateCellSize() {
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let screenWidth = UIScreen.main.bounds.width
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
