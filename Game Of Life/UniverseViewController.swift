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
    let columns = 10
    let rows = 20
    let universe: Universe
    var gridViewRect: CGRect!
    
    required init(coder aDecoder: NSCoder) {
        universe = Universe(size: CGSize(width: columns, height: rows))
        
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        let screenFrame = UIScreen.mainScreen().bounds
        let navBarRect = self.navigationController?.navigationBar.bounds
        let frameYOrigin = Int(navBarRect!.height)
        let frameHeight = Int(screenFrame.height - navBarRect!.height)
        
        gridViewRect = CGRect(origin: CGPoint(x: 0, y: frameYOrigin), size: CGSize(width: Int(screenFrame.width), height: frameHeight))
        
        self.view = UniverseGridView(universe: universe, frame: gridViewRect)
    }
}
