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
    
    let universGridView: UniverseGridView!
    let columns = 41
    let rows = 60
    let universe: Universe
    
    let startButton: UIBarButtonItem!
    let stopButton: UIBarButtonItem!
    
    var universeGridView: UniverseGridView!
    var gridViewRect: CGRect!
    var isGameRunning: Bool = false
    var timer: NSTimer?
    
    required init(coder aDecoder: NSCoder) {
        universe = Universe(size: CGSize(width: columns, height: rows))
        
        super.init(coder: aDecoder)
        startButton = UIBarButtonItem(title: "Start Game", style: .Plain, target: self, action: Selector("toggleGame"))
        stopButton = UIBarButtonItem(title: "Stop Game", style: .Plain, target: self, action: Selector("toggleGame"))
        
        self.navigationItem.rightBarButtonItem = startButton
    }
    
    func toggleGame() {
        if isGameRunning {
            isGameRunning = false
            self.navigationItem.rightBarButtonItem = startButton
            timer?.invalidate()
        } else {
            isGameRunning = true
            self.navigationItem.rightBarButtonItem = stopButton
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateUniverse"), userInfo: nil, repeats: true)
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
