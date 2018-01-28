//
//  Grid.swift
//  XO
//
//  Copyright © 2018 Nixiware. All rights reserved.
//

import Foundation
import SpriteKit

class Grid: SKNode {
    public var size: CGSize = CGSize.zero
    private var horizontalStep: CGFloat = 0.0
    private var verticalStep: CGFloat = 0.0
    
    fileprivate var map = Array2D<Sign>(columns: 3, rows: 3)
    
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
    public func getMapPosition(point: CGPoint) -> (Int, Int)? {
        var x: Int? = nil
        var y: Int? = nil
        
        if (point.x >= 0.0 && point.x <= size.width) {
            x = Int(floor(point.x / self.horizontalStep))
        }
        
        if (point.y >= 0.0 && point.y <= size.height) {
            y = Int(floor(point.y / self.verticalStep))
        }
        
        if (x == nil || y == nil) {
            return nil
        }
        
        return (x!, y!)
    }
    
    // MARK: - Lines
    
    public func drawLines() {
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
    
    private func drawLine(origin: CGPoint, destination: CGPoint) {
        let path = UIBezierPath()
        path.move(to: origin)
        path.addLine(to: destination)
        
        let shape = SKShapeNode()
        shape.path = path.cgPath
        shape.strokeColor = UIColor.black
        shape.lineWidth = 3.0
        self.addChild(shape)
    }
    
    // MARK: - Signs
    
    func addSign(x: Int, y: Int, sign: Sign) -> Bool {
        if (self.map[x, y] != nil) {
            return false
        }
        
        self.map[x, y] = sign
        
        sign.sprite.position = CGPoint(
            x: CGFloat(x) * self.horizontalStep + self.horizontalStep * 0.5,
            y: CGFloat(y) * self.verticalStep + self.verticalStep * 0.5
        )
        sign.sprite.fontSize = (self.size.width * 0.35 + self.size.height * 0.35) / 2.0
        self.addChild(sign.sprite)
        
        return true
    }
    
    
}
