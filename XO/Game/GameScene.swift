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
        
        var background = SKSpriteNode.init(color: UIColor.red, size: size)
        background.anchorPoint = CGPoint.zero
        self.addChild(background)
        
    }
    
    
}
