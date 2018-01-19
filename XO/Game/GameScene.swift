//
//  GameScene.swift
//  XO
//
//  Copyright © 2018 Nixiware. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
    
    private var grid: Grid?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let gridSize = CGSize(width: self.size.width * 0.663, height: self.size.width * 0.663)
        self.grid = Grid.init(size: gridSize)
        self.grid!.position = CGPoint.init(x: (self.size.width - gridSize.width) / 2.0, y: (self.size.height - gridSize.height) / 2.0)
        self.addChild(self.grid!)
        
        self.backgroundColor = UIColor.white
    }
}

class Grid: SKNode {
    public var size: CGSize = CGSize.zero
    
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
    
    func drawLines() {
        let horizontalStep = self.size.width / 3.0
        let verticalStep = self.size.height / 3.0
        
        for i in 1 ... 2 {
            let lineOrigin = CGPoint.init(x: 0.0, y: verticalStep * CGFloat(i))
            let lineDestination = CGPoint.init(x: self.size.width, y: verticalStep * CGFloat(i))
            
            self.drawLine(origin: lineOrigin, destination: lineDestination)
        }
        
        for i in 1 ... 2 {
            let lineOrigin = CGPoint.init(x: horizontalStep * CGFloat(i), y: 0)
            let lineDestination = CGPoint.init(x: horizontalStep * CGFloat(i), y: self.size.height)
            
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
}

enum SignType {
    case X
    case Y
}

enum SignColor {
    case Player
    case Enemy
}

class Sign {
    public var type: SignType = .X
    public var color: SignColor = .Player
    
    private var spriteLabelValue: String = "X"
    public var sprite: SKLabelNode? = nil
    public let spriteSize: CGSize = CGSize.zero
    
    convenience init(type: SignType) {
        self.init()
        
        self.type = type
        switch self.type {
        case .X:
            self.spriteLabelValue = "X"
        case .Y:
            self.spriteLabelValue = "Y"
        }
        
        self.sprite = SKLabelNode.init(text: self.spriteLabelValue)
        self.sprite?.horizontalAlignmentMode = .center
        self.sprite?.verticalAlignmentMode = .center
        self.sprite?.fontName = UISettings.sharedInstance.font1SemiBold
        self.sprite?.fontSize = (self.spriteSize.width + self.spriteSize.height) / 2.0
        
        switch self.color {
        case .Player:
            self.sprite?.fontColor = UIColor.init(red: 90.0/255.0, green: 177.0/255.0, blue: 142.0/255.0, alpha: 1.0)
        case .Enemy:
            self.sprite?.fontColor = UIColor.init(red: 238/255.0, green: 101.0/255.0, blue: 129.0/255.0, alpha: 1.0)
        }
    }
}
