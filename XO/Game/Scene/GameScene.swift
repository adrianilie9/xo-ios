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
