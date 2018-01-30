//
//  Grid.swift
//  XO
//
//  Copyright © 2018 Nixiware. All rights reserved.
//

import Foundation
import SpriteKit

struct GridMapLocation {
    var x: Int
    var y: Int
}

class Grid: SKNode {
    public var size: CGSize = CGSize.zero
    private var horizontalStep: CGFloat = 0.0
    private var verticalStep: CGFloat = 0.0
    
    fileprivate var map = Array2D<Sign>(columns: 3, rows: 3)
    fileprivate var mapSignsCount = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize) {
        super.init()
        
        self.size = size
        
        let background = SKSpriteNode.init(color: UIColor.white, size: size)
        background.anchorPoint = CGPoint.zero
        self.addChild(background)
        
        self.drawLines()
    }
    
    /**
     * Transforms a CG coordinate into a map location.
     *
     * - parameter point: coordinate to query
     * - returns: 2D tuple with map location or nil if not found
     */
    public func getMapPosition(point: CGPoint) -> GridMapLocation? {
        var x: Int? = nil
        var y: Int? = nil
        
        if (point.x >= 0.0 && point.x <= size.width) {
            x = Int(floor(point.x / self.horizontalStep))
        }
        
        if (point.y >= 0.0 && point.y <= size.height) {
            y = Int(floor(point.y / self.verticalStep))
        }
        
        guard let lX = x, let lY = y else { return nil }
        
        return GridMapLocation(x: lX, y: lY)
    }
    
    fileprivate func getMiddlePoint(location: GridMapLocation) -> CGPoint {
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
        if (origin.x == destination.x) { // vertical line
            
        } else if (origin.y == destination.y) { // horizontal line
            
        } else { // diagonal line
            
        }
        
        // drawing the line
        let path = UIBezierPath()
        path.move(to: origin)
        path.addLine(to: destination)
        
        let shape = SKShapeNode()
        shape.path = path.cgPath
        shape.strokeColor = UIColor.red
        shape.lineWidth = 5.0
        self.addChild(shape)
        
        print("\(origin) \(destination)")
    }
    
    // MARK: - Signs
    
    func addSign(location: GridMapLocation, sign: Sign) -> Bool {
        if (self.map[location.x, location.y] != nil) {
            return false
        }
        
        self.map[location.x, location.y] = sign
        
        sign.sprite.position = CGPoint(
            x: CGFloat(location.x) * self.horizontalStep + self.horizontalStep * 0.5,
            y: CGFloat(location.y) * self.verticalStep + self.verticalStep * 0.5
        )
        sign.sprite.fontSize = (self.size.width * 0.35 + self.size.height * 0.35) / 2.0
        self.addChild(sign.sprite)
        
        self.mapSignsCount += 1
        
        return true
    }
    
    func getSign(location: GridMapLocation) -> Sign? {
        return self.map[location.x, location.y]
    }
    
    func getSignsCount() -> Int {
        return self.mapSignsCount
    }
    
    public func drawWinningLine(line: (GridMapLocation, GridMapLocation, GridMapLocation)) {
        self.drawWinningLine(
            origin: self.getMiddlePoint(location: line.0),
            destination: self.getMiddlePoint(location: line.2)
        )
    }
}
