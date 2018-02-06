//
//  Grid.swift
//  XO
//

import Foundation
import SpriteKit

class Grid: SKNode, BoardDelegate {
    fileprivate var playerSigns: Dictionary<Int, SignType>
    
    public var size: CGSize = CGSize.zero
    private var horizontalStep: CGFloat = 0.0
    private var verticalStep: CGFloat = 0.0
    
    fileprivate var board: Board
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize, board: Board, players: [Player]) {
        self.size = size
        self.board = board
        self.playerSigns = [
            players[0].playerId: SignType.X,
            players[1].playerId: SignType.O
        ]
        
        super.init()
        self.board.delegate = self
        
        let background = SKSpriteNode.init(color: UIColor.white, size: size)
        background.anchorPoint = CGPoint.zero
        self.addChild(background)
        
        self.drawLines()
    }
    
    /**
     * Transforms a CG coordinate into a map location.
     *
     * - parameter point: coordinate to query
     * - returns: BoardMapLocation or nil if not found
     */
    public func getMapPosition(point: CGPoint) -> BoardMapLocation? {
        var x: Int? = nil
        var y: Int? = nil
        
        if (point.x >= 0.0 && point.x <= size.width) {
            x = Int(floor(point.x / self.horizontalStep))
        }
        
        if (point.y >= 0.0 && point.y <= size.height) {
            y = Int(floor(point.y / self.verticalStep))
        }
        
        guard let lX = x, let lY = y else { return nil }
        
        return BoardMapLocation(x: lX, y: lY)
    }
    
    fileprivate func getMiddlePoint(location: BoardMapLocation) -> CGPoint {
        let x = CGFloat(location.x) * self.horizontalStep + self.horizontalStep * 0.5
        let y = CGFloat(location.y) * self.verticalStep + self.verticalStep * 0.5
        
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    
    // MARK: - Lines
    
    fileprivate func drawLines() {
        self.horizontalStep = self.size.width / 3.0
        self.verticalStep = self.size.height / 3.0
        
        for i in 1 ... 2 {
            let lineOrigin = CGPoint.init(x: 0.0, y: self.verticalStep * CGFloat(i))
            let lineDestination = CGPoint.init(x: self.size.width, y: self.verticalStep * CGFloat(i))
            
            self.drawLine(origin: lineOrigin, destination: lineDestination)
        }
        
        for i in 1 ... 2 {
            let lineOrigin = CGPoint.init(x: self.horizontalStep * CGFloat(i), y: 0)
            let lineDestination = CGPoint.init(x: self.horizontalStep * CGFloat(i), y: self.size.height)
            
            self.drawLine(origin: lineOrigin, destination: lineDestination)
        }
    }
    
    fileprivate func drawLine(origin: CGPoint, destination: CGPoint) {
        let path = UIBezierPath()
        path.move(to: origin)
        path.addLine(to: destination)
        
        let shape = SKShapeNode()
        shape.path = path.cgPath
        shape.strokeColor = UIColor.black
        shape.lineWidth = 3.0
        self.addChild(shape)
    }
    
    fileprivate func drawWinningLine(origin: CGPoint, destination: CGPoint) {
        var extendedOrigin: CGPoint?
        var extendedDestination: CGPoint?
        
        if (origin.x == destination.x) { // vertical line
            extendedOrigin = CGPoint(x: origin.x, y: origin.y - self.verticalStep * 0.5)
            extendedDestination = CGPoint(x: destination.x, y: destination.y + self.verticalStep * 0.5)
        } else if (origin.y == destination.y) { // horizontal line
            extendedOrigin = CGPoint(x: origin.x - self.horizontalStep * 0.5, y: origin.y)
            extendedDestination = CGPoint(x: destination.x + self.horizontalStep * 0.5, y: destination.y)
        } else if (origin.x < destination.x) { // 1st diagonal line
            extendedOrigin = CGPoint(x: origin.x - self.horizontalStep * 0.5, y: origin.y - self.verticalStep * 0.5)
            extendedDestination = CGPoint(x: destination.x + self.horizontalStep * 0.5, y: destination.y + self.verticalStep * 0.5)
        } else if (origin.x > destination.x) { // 2nd diagonal line
            extendedOrigin = CGPoint(x: origin.x + self.horizontalStep * 0.5, y: origin.y - self.verticalStep * 0.5)
            extendedDestination = CGPoint(x: destination.x - self.horizontalStep * 0.5, y: destination.y + self.verticalStep * 0.5)
        }
        
        guard let origin = extendedOrigin, let destination = extendedDestination else { return }
        
        // drawing the line
        let path = UIBezierPath()
        path.move(to: origin)
        path.addLine(to: destination)
        
        let shape = SKShapeNode()
        shape.path = path.cgPath
        shape.strokeColor = UIColor.init(red: 62.0/255.0, green: 92.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        shape.lineWidth = 5.0
        self.addChild(shape)
    }
    
    /**
     * Draws the horizontal/vertical/diagonal winning line.
     *
     * - parameter line: tuple consisting the 3 BoardMapLocations defining a winning line
     */
    public func drawWinningLine(line: (BoardMapLocation, BoardMapLocation, BoardMapLocation)) {
        self.drawWinningLine(
            origin: self.getMiddlePoint(location: line.0),
            destination: self.getMiddlePoint(location: line.2)
        )
    }
    
    // MARK: - Signs
    
    fileprivate func addSign(location: BoardMapLocation, sign: Sign) {
        sign.sprite.position = CGPoint(
            x: CGFloat(location.x) * self.horizontalStep + self.horizontalStep * 0.5,
            y: CGFloat(location.y) * self.verticalStep + self.verticalStep * 0.5
        )
        sign.sprite.fontSize = (self.size.width * 0.35 + self.size.height * 0.35) / 2.0
        self.addChild(sign.sprite)
    }
    
    // MARK: - BoardDelegate
    func performedMove(move: Move) {
        guard let signType = self.playerSigns[move.player.playerId] else { return }
        
        self.addSign(
            location: move.boardMapLocation,
            sign: Sign(type: signType)
        )
    }
}
