//
//  UniverseGridView.swift
//  Game Of Life
//
//  Created by Daniel Valencia on 11/4/14.
//  Copyright (c) 2014 Daniel Valencia. All rights reserved.
//

import Foundation
import UIKit

class UniverseGridView: UIView {
    
    let universeModel: Universe
    var universeGridCells: [UniverseGridCell?]
    
    init(universe: Universe, frame: CGRect) {
        universeModel = universe
        universeGridCells = Array<UniverseGridCell?>()
        
        super.init(frame: frame)
        
        initCellPaths()
        setNeedsDisplay()
    }
    
    func initCellPaths() {
        let cellWidth = (Int(frame.width) / universeModel.columns) as Int
        let cellHeight = (Int(frame.height) / universeModel.rows) as Int
        
        for y in 0..<universeModel.rows {
            for x in 0..<universeModel.columns {
                let pathRect = CGRect(x: (x * cellWidth), y: (y * cellHeight), width: cellWidth, height: cellHeight)
                let path = UIBezierPath(rect: pathRect)
                let cell: UniverseGridCell = UniverseGridCell(cell: universeModel[x, y], path: path)
                universeGridCells.append(cell)
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let initialTouch = touches.anyObject() as UITouch
        let point: CGPoint = initialTouch.locationInView(self)
        let touchedGridCells = universeGridCells.filter {
            let path = $0?.path
            return path!.containsPoint(point)
        }
        
        if let touchedCell: UniverseGridCell? = touchedGridCells.first {
            touchedCell!.cell.isAlive = !touchedCell!.cell.isAlive
        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        for cell in universeGridCells {
            UIColor.blackColor().set()
            cell?.path.stroke()
            
            if !cell!.cell.isAlive {
                UIColor.whiteColor().set()
            }
            
            cell?.path.fill()
        }
    }
}

class UniverseGridCell {
    
    let cell: Cell
    let path: UIBezierPath
    
    init(cell: Cell, path: UIBezierPath) {
        self.cell = cell
        self.path = path
    }
}