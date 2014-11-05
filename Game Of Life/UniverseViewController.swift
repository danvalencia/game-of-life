//
//  ViewController.swift
//  Game Of Life
//
//  Created by Daniel Valencia on 10/20/14.
//  Copyright (c) 2014 Daniel Valencia. All rights reserved.
//

import UIKit

class UniverseViewController: UICollectionViewController {

    let REUSE_IDENTIFIER = "Universe Cell Identifier"
    let columns = 10
    let rows = 20
    var timer: NSTimer?
    var timerIsRunning = false
    var universe: Universe!
    
    var stopButton: UIBarButtonItem!
    var startButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        universe = Universe(size: CGSize(width: columns, height: rows))
        
        collectionView.registerNib(UINib(nibName: "CellView", bundle: nil), forCellWithReuseIdentifier: REUSE_IDENTIFIER)
        
        let flowLayout = collectionView.collectionViewLayout as UICollectionViewFlowLayout
        flowLayout.scrollDirection = .Vertical
        let itemSize = cellSize()
        flowLayout.itemSize = itemSize
        flowLayout.minimumInteritemSpacing = 0.5
        flowLayout.minimumLineSpacing = 0.0
        let screenFrame = UIScreen.mainScreen().bounds
        
        collectionView.reloadData()
        
        stopButton = UIBarButtonItem(title: "Stop", style: .Plain, target: self, action: Selector("startGame"))
        startButton = UIBarButtonItem(title: "Start", style: .Plain, target: self, action: Selector("startGame"))
        self.navigationItem.rightBarButtonItem = startButton
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cellCount = universe.cellCount()
        return cellCount
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(REUSE_IDENTIFIER, forIndexPath: indexPath) as UICollectionViewCell
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.blackColor().CGColor
        
        let indexPathRow = indexPath.row
        let (col, row) = indexRowToCoordinate(indexPathRow)
        let universeCell = universe[col, row]
        
        if universeCell.isAlive {
            cell.backgroundColor = UIColor.blackColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let indexPathRow = indexPath.row
        let (col, row) = indexRowToCoordinate(indexPathRow)
        
        let cell = universe[col, row]
        
        cell.isAlive = !cell.isAlive
        
        collectionView.reloadItemsAtIndexPaths([indexPath])
    }
    
    func startGame() {
        if timerIsRunning {
            timerIsRunning = false
            timer!.invalidate()
            self.navigationItem.rightBarButtonItem = startButton
        } else {
            timerIsRunning = true
            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("updateUniverse"), userInfo: nil, repeats: true)
            self.navigationItem.rightBarButtonItem = stopButton
        }
    }
    
    func updateUniverse() {
        universe.update()
        collectionView.reloadData()
    }
    
    func cellSize() -> CGSize {
        let navBarRect = self.navigationController?.navigationBar.bounds
        let collectionViewRect = collectionView.bounds
        let collectionViewHeight = collectionViewRect.height - navBarRect!.height
        
        let cellWidth = collectionViewRect.width / CGFloat(columns)
        let cellHeight = collectionViewHeight / CGFloat(rows)
        return CGSize(width: Int(cellWidth), height: Int(cellHeight))
    }
    
    func indexRowToCoordinate(indexRow: Int) -> (Int, Int) {
        let x = (indexRow  % columns) > 0 ? (indexRow % columns) : 0
        let y = indexRow / columns
        return (x, y)
    }
}

