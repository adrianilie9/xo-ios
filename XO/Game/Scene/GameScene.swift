//
//  GameScene.swift
//  XO
//

import UIKit
import SpriteKit

enum GameState {
    case WaitingPlayerTurn
    case WonPlayer
    case Draw
}

class GameScene: SKScene {
    private weak var viewController: GameViewController?
    
    private var players: [Player]
    private var board: Board
    
    private var strategist: Strategist!
    private var updateAI: TimeInterval = 0.0
    
    private var grid: Grid?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize, players: [Player], viewController: GameViewController) {
        self.viewController = viewController
        
        // creating model
        assert(players.count == 2, "There must be exactly 2 players each game.")
        self.players = players
        self.board = Board(players: players)
        self.strategist = Strategist(board: self.board)
        
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
        if (self.state == .WaitingPlayerTurn &&
            self.board.getCurrentPlayer()?.type == .AI &&
            currentTime - 2.0 >= self.updateAI) {
            self.updateAI = currentTime
            
            DispatchQueue.global().async {
                let strategistTime = CFAbsoluteTimeGetCurrent()
                guard let bestBoardMapLocation = self.strategist.getBestBoardMapLocation() else { return }
                
                let delta = CFAbsoluteTimeGetCurrent() - strategistTime
                
                let aiTimeCeiling = 0.75
                let delay = max(delta, aiTimeCeiling)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    guard let player = self.board.getCurrentPlayer() else { return }
                    let move = Move(player: player, boardMapLocation: bestBoardMapLocation)
                    self.board.performMove(move: move)
                    
                    self.evaluateGameUpdate()
                })
            }
        }
    }
    
    private var state: GameState {
        didSet {
            switch (state) {
            case .WaitingPlayerTurn:
                break
            case .WonPlayer:
                let hasAIPlayer = (self.players.filter() { $0.type == .AI }.count == 1) ? true : false
                if (hasAIPlayer) {
                    if let losingPlayer = self.board.getCurrentPlayer() {
                        if (losingPlayer.type == .AI) {
                            self.viewController?.displayInfo(info: "Victory")
                        } else if (losingPlayer.type == .Human) {
                            self.viewController?.displayInfo(info: "Defeat")
                        }
                    }
                } else {
                    if let losingPlayer = self.board.getCurrentPlayer() {
                        if (losingPlayer.playerId == self.players[1].playerId) {
                            self.viewController?.displayInfo(info: "Player 1 ( X ) is Victorious")
                        } else if (losingPlayer.playerId == self.players[0].playerId) {
                            self.viewController?.displayInfo(info: "Player 2 ( O ) is Victorious")
                        }
                    }
                }
                
                self.viewController?.setupRestartScene()
                
                break
            case .Draw:
                self.viewController?.displayInfo(info: "Draw")
                self.viewController?.setupRestartScene()
                
                break
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
        if (self.state != .WaitingPlayerTurn) { return }
        
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
                    if let viewController = self.viewController {
                        viewController.displayInfoFade(info: "Invalid move")
                    }
                    
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
