//
//  Move.swift
//  XO
//
//  Copyright © 2018 Nixiware. All rights reserved.
//

import Foundation
import GameplayKit

class Move : NSObject, GKGameModelUpdate {
    public var player: Player
    public var boardMapLocation: BoardMapLocation
    
    var value: Int = 0
    
    init(player: Player, boardMapLocation: BoardMapLocation) {
        self.player = player
        self.boardMapLocation = boardMapLocation
    }
}
