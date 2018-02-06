//
//  Player.swift
//  XO
//

import Foundation
import GameplayKit

class Player : NSObject, GKGameModelPlayer {
    public var playerId: Int
    
    enum PlayerType {
        case Human
        case AI
    }
    public var type: PlayerType
    
    init(type: PlayerType) {
        self.playerId = type.hashValue + Int(arc4random())
        
        self.type = type
    }
}
