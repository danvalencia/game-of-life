//
//  UniverseViewController.swift
//  Game Of Life
//
//  Created by Daniel Valencia on 11/7/14.
//  Copyright (c) 2014 Daniel Valencia. All rights reserved.
//

import Foundation
import UIKit

class UniverseViewController: UIViewController {
    
    let columns = 15
    let rows = 25
    let universe: Universe
    
    let startButton: UIBarButtonItem!
    let stopButton: UIBarButtonItem!
    let eraseButton: UIBarButtonItem!
    
    var universeGridView: UniverseGridView!
    var gridViewRect: CGRect!
    var isGameRunning: Bool = false
    var timer: NSTimer?
    
    required init(coder aDecoder: NSCoder) {
        universe = Universe(size: CGSize(width: columns, height: rows))
        
        super.init(coder: aDecoder)
        
        eraseButton = UIBarButtonItem(title: "Erase", style: .Bordered, target: self, action: Selector("toggleEraseMode"))
        startButton = UIBarButtonItem(title: "Start Game", style: .Plain, target: self, action: Selector("toggleGame"))
        stopButton = UIBarButtonItem(title: "Stop Game", style: .Plain, target: self, action: Selector("toggleGame"))
        
        self.navigationItem.rightBarButtonItems = [startButton, eraseButton]
    }
    
    func toggleGame() {
        if isGameRunning {
            isGameRunning = false
            eraseButton.enabled = true
            timer?.invalidate()
            self.navigationItem.rightBarButtonItems = [startButton, eraseButton]
        } else {
            isGameRunning = true
            eraseButton.enabled = false
            universeGridView.isEraseMode = false
            self.navigationItem.rightBarButtonItems = [stopButton, eraseButton]
            
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateUniverse"), userInfo: nil, repeats: true)
        }
    }
    
    func toggleEraseMode() {
        if universeGridView.isEraseMode {
            universeGridView.isEraseMode = false
        } else {
            universeGridView.isEraseMode = true
        }
    }
    
    func updateUniverse() {
        universe.update()
        self.view.setNeedsDisplay()
    }
    
    override func loadView() {
        let screenFrame = UIScreen.mainScreen().bounds
        let navBarRect = self.navigationController?.navigationBar.bounds
        let frameYOrigin = Int(navBarRect!.height)
        let frameHeight = Int(screenFrame.height - navBarRect!.height)
        
        gridViewRect = CGRect(origin: CGPoint(x: 0, y: frameYOrigin), size: CGSize(width: Int(screenFrame.width), height: frameHeight))
        
        self.universeGridView = UniverseGridView(universe: universe, frame: gridViewRect)
        
        self.view = universeGridView
    }
}
