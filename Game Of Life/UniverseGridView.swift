//
//  UniverseGridView.swift
//  Game Of Life
//
//  Created by Daniel Valencia on 11/4/14.
//  Copyright (c) 2014 Daniel Valencia. All rights reserved.
//

import Foundation
import UIKit
import Darwin

class UniverseGridView: UIView {
    
    let universeModel: Universe
    var universeGridCells: [UniverseGridCell]
    var touchedCells: [String: UniverseGridCell]
    var isEraseMode: Bool = false
    
    init(universe: Universe, frame: CGRect) {
        universeModel = universe
        universeGridCells = Array<UniverseGridCell>()
        touchedCells = [String: UniverseGridCell]()
        
        super.init(frame: frame)
        
        initCellPaths()
        setNeedsDisplay()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let initialTouch = touches.anyObject() as UITouch
        
        let touchedCell = getTouchedCell(initialTouch)
        touchedCell?.cell.isAlive = true
        
        if let cell = touchedCell?.cell {
            touchedCells[cell.description] = touchedCell!
            
            setNeedsDisplayInRect(touchedCell!.path.bounds)
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let initialTouch = touches.anyObject() as UITouch
        
        for touch in touches {
            let touchedCell = getTouchedCell(initialTouch)
            
            if let cell = touchedCell?.cell {
                if touchedCells[cell.description] == nil {
                    cell.isAlive = true
                    touchedCells[cell.description] = touchedCell
                    setNeedsDisplayInRect(touchedCell!.path.bounds)
                }
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        touchedCells.removeAll(keepCapacity: false)
    }
    
    override func drawRect(rect: CGRect) {
        if touchedCells.count > 0 {
            for cell in touchedCells.values {
                if CGRectContainsRect(rect, cell.path.bounds) {
                    if isEraseMode {
                        UIColor.blackColor().set()
                        cell.path.stroke()
                        
                        UIColor.whiteColor().set()
                        cell.path.fill()
                    } else {
                        UIColor.blackColor().set()
                        cell.path.fill()
                    }
                    
                }
            }
        } else {
            for cell in universeGridCells {
                UIColor.blackColor().set()
                cell.path.stroke()
                
                if !cell.cell.isAlive {
                    UIColor.whiteColor().set()
                }
                
                cell.path.fill()
            }
        }
    }
    
    func initCellPaths() {
        let cellWidth = ceil(frame.width / CGFloat(universeModel.columns))
        let cellHeight = ceil(frame.height / CGFloat(universeModel.rows))
        
        for y in 0..<universeModel.rows {
            for x in 0..<universeModel.columns {
                let xOrigin = ceil(CGFloat(x) * cellWidth)
                let yOrigin = ceil(CGFloat(y) * cellHeight)
                
                let pathRect = CGRect(x: xOrigin, y: yOrigin, width: cellWidth, height: cellHeight)
                let path = UIBezierPath(rect: pathRect)
                let universeGridCell: UniverseGridCell = UniverseGridCell(cell: universeModel[x, y], path: path)
                universeGridCells.append(universeGridCell)
            }
        }
    }
    
    func getTouchedCell(point: CGPoint) -> UniverseGridCell? {
        let touchedGridCells = universeGridCells.filter {
            return $0.path.containsPoint(point)
        }
        
        return touchedGridCells.first
    }
    
    func getTouchedCell(touch: UITouch) -> UniverseGridCell? {
        let point: CGPoint = touch.locationInView(self)
        return self.getTouchedCell(point)
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