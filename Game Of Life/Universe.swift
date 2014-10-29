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
    
    var cells: [Cell]
    let columns: Int
    let rows: Int
    
    init(size: CGSize) {
        columns = Int(size.width)
        rows = Int(size.height)
        let numCells = columns * rows
        cells = [Cell](count: numCells, repeatedValue: Cell(isAlive: false))
        initCells()
    }
    
    func initCells() {
        for col in 0..<columns {
            for row in 0..<rows {
               self[col, row] = Cell(isAlive: false)
            }
        }
    }
    
    func numberOfNeighborsForCellWithPosition(col: Int, row: Int) -> Int {
        let initCol: Int = col - 1 < 0 ? 0 : col - 1
        let endCol: Int = col + 1 == columns ? col : col + 1
        let initRow: Int = row - 1 < 0 ? 0 : row - 1
        let endRow: Int = row + 1 == rows ? row : row + 1
        var neighborCount: Int = 0
        
        for col in initCol...endCol {
            for row in initRow...endRow {
                let cell = self[col, row]
                if cell.isAlive {
                    neighborCount++
                }
            }
        }
        
        return neighborCount
    }
    
    func cellCount() -> Int {
        return columns * rows
    }
    

    
    func getPositionFromCoordinates(x: Int, y: Int) -> Int {
        let position = (x * columns) + y
        return position
    }
    
    subscript(x: Int, y: Int) -> Cell {
        get {
            let pos = getPositionFromCoordinates(x, y: y)
            return cells[pos]
        }
        
        set(newCell) {
            let cellIndex = getPositionFromCoordinates(x, y: y)
            cells[cellIndex] = newCell
        }
    }
}