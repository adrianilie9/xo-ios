//
//  Board.swift
//  XO
//
//  Copyright © 2018 Nixiware. All rights reserved.
//

import Foundation

struct BoardMapLocation {
    var x: Int
    var y: Int
}

class Board : NSObject {
    fileprivate var map = Array2D<Sign>(columns: 3, rows: 3)
    
    func canPerformMove(move: Move) -> Bool {
        return true
    }
    
    func performMove(move: Move) -> Void {
        
    }
    
    
}
