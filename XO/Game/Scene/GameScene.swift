//
//  GameScene.swift
//  XO
//
//  Copyright © 2018 Nixiware. All rights reserved.
//

import UIKit
import SpriteKit

enum GameState {
    case WaitingPlayerTurn
    case WonPlayer
    case Draw
}

class GameScene: SKScene {
    private var board: Board
    
    private var updateAI: TimeInterval = 0.0
    
    private var grid: Grid?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize, players: [Player]) {
        // creating model
        assert(players.count == 2, "There must be exactly 2 players each game.")
        self.board = Board(players: players)
        
        self.state = .WaitingPlayerTurn
        
        super.init(size: size)
        
        // adding the grid
        let gridSize = CGSize(width: self.size.width * 0.663, height: self.size.width * 0.663)
        self.grid = Grid.init(size: gridSize, board: self.board, players: players)
        if let grid = self.grid {
            grid.position = CGPoint.init(
                x: (self.size.width - gridSize.width) / 2.0,
                y: (self.size.height - gridSize.height) / 2.0
            )
            self.addChild(grid)
        }
        
        // setting UI
        self.backgroundColor = UIColor.white
    }
    
    // MARK: - Update
    
    override func update(_ currentTime: TimeInterval) {
        if (self.board.getCurrentPlayer()?.type == .AI && currentTime - 1.0 >= self.updateAI) {
            self.updateAI = currentTime
            
            print("UpdateAI")
        }
    }
    
    private var state: GameState {
        didSet {
            switch (state) {
            case .WaitingPlayerTurn:
                print("-")
            case .WonPlayer:
                print("Player won")
            case .Draw:
                print("Draw")
            }
        }
    }
    
    public func evaluateGameUpdate() {
        // checking status
        let winResult = self.board.evaluateWin()
        if winResult.0 != nil {
            if let line = winResult.1 {
                self.grid?.drawWinningLine(line: line)
            }
            
            self.state = .WonPlayer
            
            return
        } else if (self.board.isFull()) {
            self.state = .Draw
            
            return
        }
    }
    
    // MARK: - Input
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        for node in self.nodes(at: touch.location(in: self.view)) {
            if let grid = node as? Grid {
                // checking if current player can perform move
                let currentPlayer = self.board.getCurrentPlayer()
                guard let player = currentPlayer else { return }
                if (player.type != .Human) { return }
                
                let gridTouchLocation = touch.location(in: grid)
                guard let location = grid.getMapPosition(point: gridTouchLocation) else { return }
                
                // creating move
                let move = Move(player: player, boardMapLocation: location)
                if (!self.board.canPerformMove(move: move)) {
                    // TODO: play animation - invalid position
                    return
                }
                
                // performing move
                self.board.performMove(move: move)
                
                // updating game
                self.evaluateGameUpdate()
            }
        }
    }
}
