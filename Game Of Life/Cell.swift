//
//  Cell.swift
//  Game Of Life
//
//  Created by Daniel Valencia on 10/20/14.
//  Copyright (c) 2014 Daniel Valencia. All rights reserved.
//

import Foundation

class Cell {
    
    var isAlive: Bool
    var shouldBeAlive: Bool = false
    
    init(isAlive: Bool) {
        self.isAlive = isAlive
    }
}