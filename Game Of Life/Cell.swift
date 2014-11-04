//
//  Cell.swift
//  Game Of Life
//
//  Created by Daniel Valencia on 10/20/14.
//  Copyright (c) 2014 Daniel Valencia. All rights reserved.
//

import Foundation

class Cell {
    
    var isAlive: Bool = false
    var shouldBeAlive: Bool = false
    let x: Int!
    let y: Int!
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    var description: String {
        return "(\(x), \(y))"
    }
}