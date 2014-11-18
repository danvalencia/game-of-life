//
//  Universe.swift
//  Game Of Life
//
//  Created by Daniel Valencia on 10/20/14.
//  Copyright (c) 2014 Daniel Valencia. All rights reserved.
//

import Foundation
import UIKit

class Universe {
    
    let UNIVERSE_UPDATED_NOTIFICATION = "Universe Updated Notification"
    
    var cells: [Cell?]
    var updatedCells: [Cell]
    let columns: Int
    let rows: Int
    
    init(size: CGSize) {
        columns = Int(size.width)
        rows = Int(size.height)
        let numCells = columns * rows
        cells = Array<Cell?>(count: numCells, repeatedValue: nil)
        updatedCells = []
        initCells()
    }
    
    func initCells() {
        for y in 0..<rows {
            for x in 0..<columns {
                let cell = Cell(x: x, y: y)
                self[x, y] = cell
            }
        }
    }
    
    func update() {
        updatedCells.removeAll(keepCapacity: false)
        
        for y in 0..<rows {
            for x in 0..<columns {
                var cell = self[x, y]
                let numNeighbors = numberOfNeighborsForCellWithPosition(x, y: y)
                if cell.isAlive {
                    if numNeighbors < 2 {
                        cell.shouldBeAlive = false
                        //cell changed
                        updatedCells.append(cell)
                    } else if numNeighbors <= 3 {
                        cell.shouldBeAlive = true
                    } else {
                        cell.shouldBeAlive = false
                        //cell changed
                        updatedCells.append(cell)
                    }
                } else {
                    if numNeighbors == 3 {
                        cell.shouldBeAlive = true
                        // cell changed
                        updatedCells.append(cell)
                    } else {
                        cell.shouldBeAlive = false
                    }
                }
            }
        }
        
        for cell in updatedCells {
            cell.isAlive = cell.shouldBeAlive
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(UNIVERSE_UPDATED_NOTIFICATION, object: self)
    }
    
    func numberOfNeighborsForCellWithPosition(x: Int, y: Int) -> Int {
        let initX: Int = x - 1 < 0 ? 0 : x - 1
        let endX: Int = x + 1 == columns ? x : x + 1
        let initY: Int = y - 1 < 0 ? 0 : y - 1
        let endY: Int = y + 1 == rows ? y : y + 1
        var neighborCount: Int = 0
        
        for neighborX in initX...endX {
            for neighborY in initY...endY {
                if neighborX != x || neighborY != y {
                    let neighborCell = self[neighborX, neighborY]
                    
                    if neighborCell.isAlive {
                        neighborCount++
                    }
                }
            }
        }
        
        return neighborCount
    }
    
    func cellCount() -> Int {
        return columns * rows
    }
    
    func getPositionFromCoordinates(x: Int, _ y: Int) -> Int {
        let position = (y * columns) + x
        return position
    }
    
    subscript(x: Int, y: Int) -> Cell {
        get {
            let pos = getPositionFromCoordinates(x, y)
            return cells[pos]!
        }
        
        set(newCell) {
            let cellIndex = getPositionFromCoordinates(x, y)
            cells[cellIndex] = newCell
        }
    }
}