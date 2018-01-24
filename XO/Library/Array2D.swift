//
//  Array2D.swift
//
//  Copyright © 2018 Nixiware. All rights reserved.
//

import Foundation

struct Array2D<T> {
    let columns: Int
    let rows: Int
    fileprivate var array: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        
        self.array = Array<T?>(repeating: nil, count: columns*rows)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return self.array[row * self.columns + column]
        }
        
        set {
            self.array[row * self.columns + column] = newValue
        }
    }
}
