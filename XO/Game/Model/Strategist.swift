//
//  Strategist.swift
//  XO
//
//  Copyright © 2018 Nixiware. All rights reserved.
//

import Foundation
import GameplayKit

class Strategist: GKMinmaxStrategist {
    fileprivate let board: Board!
    
    init(board: Board) {
        self.board = board
        
        super.init()
        
        self.gameModel = board
        self.maxLookAheadDepth = 512
        self.randomSource = GKARC4RandomSource()
    }
    
    public func getBestBoardMapLocation() -> BoardMapLocation? {
        guard let player = board.getCurrentPlayer() else { return nil }
        
        if let move = self.bestMove(for: player) as? Move {
            return move.boardMapLocation
        }
        
        return nil
    }
}
