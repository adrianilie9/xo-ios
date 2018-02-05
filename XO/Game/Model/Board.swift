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

protocol BoardDelegate: class {
    func performedMove(move: Move)
}

class Board : NSObject, NSCopying {
    weak var delegate: BoardDelegate?
    
    fileprivate var map = Array2D<Move>(columns: 3, rows: 3)
    fileprivate var movesPerfomed = Array<Move>()
    
    init(players: [Player]) {
        self.players = players
    }
    
    func canPerformMove(move: Move) -> Bool {
        if (self.map[move.boardMapLocation.x, move.boardMapLocation.y] != nil) {
            return false
        }
        
        return true
    }
    
    func performMove(move: Move) -> Void {
        self.map[move.boardMapLocation.x, move.boardMapLocation.y] = move
        self.movesPerfomed.append(move)
        
        self.delegate?.performedMove(move: move)
    }
    
    func isFull() -> Bool {
        for x in 0 ... 2 {
            for y in 0 ... 2 {
                if self.map[x, y] == nil {
                    return false
                }
            }
        }
        
        return true
    }
    
    func evaluateWin() -> (Player?, (BoardMapLocation, BoardMapLocation, BoardMapLocation)?) {
        var winningPlayer: Player?
        var winningLine: (BoardMapLocation, BoardMapLocation, BoardMapLocation)?
        
        // checking columns
        for x in 0 ... 2 {
            guard let firstMove = self.map[x, 0] else { continue }
            var playerCount = 1
            
            for y in 1 ... 2 {
                guard let move = self.map[x, y] else { break }
                if (move.player.playerId == firstMove.player.playerId) {
                    playerCount += 1
                }
            }
            
            if (playerCount == 3) {
                winningLine = (BoardMapLocation(x: x, y: 0), BoardMapLocation(x: x, y: 1), BoardMapLocation(x: x, y: 2))
                winningPlayer = firstMove.player
            }
        }
        
        // checking rows
        for y in 0 ... 2 {
            guard let firstMove = self.map[0, y] else { continue }
            var playerCount = 1
            
            for x in 1 ... 2 {
                guard let move = self.map[x, y] else { break }
                if (move.player.playerId == firstMove.player.playerId) {
                    playerCount += 1
                }
            }
            
            if (playerCount == 3) {
                winningLine = (BoardMapLocation(x: 0, y: y), BoardMapLocation(x: 1, y: y), BoardMapLocation(x: 2, y: y))
                winningPlayer = firstMove.player
            }
        }
        
        // checking diagonals
        let diagonals: Array<Array<BoardMapLocation>> = [
            [BoardMapLocation(x: 0, y: 0), BoardMapLocation(x: 1, y: 1), BoardMapLocation(x: 2, y: 2)],
            [BoardMapLocation(x: 2, y: 0), BoardMapLocation(x: 1, y: 1), BoardMapLocation(x: 0, y: 2)]
        ]
        for diagonal in diagonals {
            guard let firstMove = self.map[diagonal[0].x, diagonal[0].y] else { continue }
            var playerCount = 1
            
            for index in 1 ... 2 {
                guard let move = self.map[diagonal[index].x, diagonal[index].y] else { break }
                if (move.player.playerId == firstMove.player.playerId) {
                    playerCount += 1
                }
            }
            
            if (playerCount == 3) {
                winningLine = (diagonal[0], diagonal[1], diagonal[2])
                winningPlayer = firstMove.player
            }
        }
        
        return (winningPlayer, winningLine)
    }
    
    // MARK: - NSCopying
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Board(players: self.players)
        copy.map = self.map
        copy.movesPerfomed = Array(self.movesPerfomed)
        return copy
    }
    
    // MARK: - AI
    
    fileprivate let players: [Player]
    fileprivate var currentPlayer: Player? {
        get {
            if (self.movesPerfomed.count == 0) {
                return self.players[0]
            } else {
                let lastMovePlayer = self.movesPerfomed[self.movesPerfomed.count - 1].player
                let otherPlayers = self.players.filter() { $0.playerId != lastMovePlayer.playerId }
                if (otherPlayers.count == 1) {
                    return otherPlayers[0]
                }
            }
            
            return nil
        }
    }
    
    public func getCurrentPlayer() -> Player? {
        return self.currentPlayer
    }
}
