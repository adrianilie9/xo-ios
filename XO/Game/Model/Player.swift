//
//  Player.swift
//  XO
//
//  Copyright © 2018 Nixiware. All rights reserved.
//

import Foundation

class Player : NSObject {
    public var playerId: Int
    
    enum PlayerType {
        case Human
        case AI
    }
    public var type: PlayerType
    
    enum PlayerNumber {
        case One
        case Two
    }
    public var number: PlayerNumber
    
    init(type: PlayerType, number: PlayerNumber) {
        self.playerId = type.hashValue + number.hashValue
        
        self.type = type
        self.number = number
    }
}
