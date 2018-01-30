//
//  GameScene.swift
//  XO
//
//  Copyright © 2018 Nixiware. All rights reserved.
//

import UIKit
import SpriteKit

enum GameMode {
    case PlayerVersusPlayer
    case PlayerVersusAI
}

enum GameState {
    case WaitingPlayer1Turn
    case WaitingPlayer2Turn
    case WonPlayer1
    case WonPlayer2
    case Draw
}

class GameScene: SKScene {
    
    private var grid: Grid?
    
    private var mode: GameMode?
    private var state: GameState = .WaitingPlayer1Turn
    private var updateAI: TimeInterval = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize, mode: GameMode) {
        super.init(size: size)
        
        let gridSize = CGSize(width: self.size.width * 0.663, height: self.size.width * 0.663)
        self.grid = Grid.init(size: gridSize)
        if let grid = self.grid {
            grid.position = CGPoint.init(
                x: (self.size.width - gridSize.width) / 2.0,
                y: (self.size.height - gridSize.height) / 2.0
            )
            self.addChild(grid)
        }
        
        self.backgroundColor = UIColor.white
        
        self.mode = mode
    }
    
    // MARK: - Update
    
    override func update(_ currentTime: TimeInterval) {
        if (self.mode == .PlayerVersusAI && self.state == .WaitingPlayer2Turn && currentTime - 1.0 >= self.updateAI) {
            self.updateAI = currentTime
            
            print("UpdateAI")
            
            
        }
    }
    
    // MARK: - State
    
    func evaluateState() {
        print("evaluateState")
        
        var nextState: GameState?
        var winningLine: (GridMapLocation, GridMapLocation, GridMapLocation)?
        
        // checking columns
        for x in 0 ... 2 {
            guard let firstSign = self.grid?.getSign(location: GridMapLocation(x: x, y: 0)) else { continue }
            var signCount = 1
            
            for y in 1 ... 2 {
                guard let sign = self.grid?.getSign(location: GridMapLocation(x: x, y: y)) else { break }
                if (sign.type == firstSign.type) {
                    signCount += 1
                }
            }
            
            if (signCount == 3) {
                winningLine = (GridMapLocation(x: x, y: 0), GridMapLocation(x: x, y: 1), GridMapLocation(x: x, y: 2))
                
                if (firstSign.type == .X) {
                    nextState = .WonPlayer1
                } else if (firstSign.type == .O) {
                    nextState = .WonPlayer2
                }
            }
        }
        
        // checking rows
        for y in 0 ... 2 {
            guard let firstSign = self.grid?.getSign(location: GridMapLocation(x: 0, y: y)) else { continue }
            var signCount = 1
            
            for x in 1 ... 2 {
                guard let sign = self.grid?.getSign(location: GridMapLocation(x: x, y: y)) else { break }
                if (sign.type == firstSign.type) {
                    signCount += 1
                }
            }
            
            if (signCount == 3) {
                winningLine = (GridMapLocation(x: 0, y: y), GridMapLocation(x: 1, y: y), GridMapLocation(x: 2, y: y))
                
                if (firstSign.type == .X) {
                    nextState = .WonPlayer1
                } else if (firstSign.type == .O) {
                    nextState = .WonPlayer2
                }
            }
        }
        
        // checking diagonals
        let diagonals: Array<Array<GridMapLocation>> = [
            [GridMapLocation(x: 0, y: 0), GridMapLocation(x: 1, y: 1), GridMapLocation(x: 2, y: 2)],
            [GridMapLocation(x: 2, y: 0), GridMapLocation(x: 1, y: 1), GridMapLocation(x: 0, y: 2)]
        ]
        for diagonal in diagonals {
            guard let firstSign = self.grid?.getSign(location: diagonal[0]) else { continue }
            var signCount = 1
            
            for index in 1 ... 2 {
                guard let sign = self.grid?.getSign(location: diagonal[index]) else { break }
                if (sign.type == firstSign.type) {
                    signCount += 1
                }
            }
            
            if (signCount == 3) {
                winningLine = (diagonal[0], diagonal[1], diagonal[2])
                
                if (firstSign.type == .X) {
                    nextState = .WonPlayer1
                } else if (firstSign.type == .O) {
                    nextState = .WonPlayer2
                }
            }
        }
        
        if (nextState == nil && self.grid?.getSignsCount() == 9) {
            nextState = .Draw
        }
        
        guard let state = nextState else { return }
        
        print(state)
        self.state = state
        
        if let line = winningLine {
            self.grid?.drawWinningLine(line: line)
        }
    }
    
    // MARK: - Input
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        for node in self.nodes(at: touch.location(in: self.view)) {
            if let grid = node as? Grid {
                let gridTouchLocation = touch.location(in: grid)
                guard let location = grid.getMapPosition(point: gridTouchLocation) else { return }
                
                if (self.mode == .PlayerVersusPlayer) {
                    var signToAdd: Sign?
                    var nextState: GameState?
                    if (self.state == .WaitingPlayer1Turn) {
                        signToAdd = Sign(type: .X, color: .Player1)
                        nextState = .WaitingPlayer2Turn
                    } else if (self.state == .WaitingPlayer2Turn) {
                        signToAdd = Sign(type: .O, color: .Player2)
                        nextState = .WaitingPlayer1Turn
                    }
                    
                    guard let sign = signToAdd, let state = nextState else { return }
                    
                    if (grid.addSign(location: location, sign: sign)) {
                        self.state = state
                        self.evaluateState()
                    } else {
                        // TODO: play animation - invalid position
                    }
                } else if (self.mode == .PlayerVersusAI) {
                    if (self.state == .WaitingPlayer1Turn) {
                        if (grid.addSign(location: location, sign: Sign(type: .X, color: .Player1))) {
                            self.state = .WaitingPlayer2Turn
                            self.evaluateState()
                        } else {
                            // TODO: play animation - invalid position
                        }
                    } else if (self.state == .WaitingPlayer2Turn) {
                        // TODO: play animation - wait for computer turn
                    }
                }
            }
        }
    }
}
