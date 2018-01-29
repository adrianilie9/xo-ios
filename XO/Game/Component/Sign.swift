//
//  Sign.swift
//  XO
//
//  Copyright © 2018 Nixiware. All rights reserved.
//

import Foundation
import SpriteKit

enum SignType {
    case X
    case O
}

enum SignColor {
    case Player1
    case Player2
}

class Sign {
    public var type: SignType = .X
    public var color: SignColor = .Player1
    
    private var spriteLabelValue: String = "X"
    public var sprite: SKLabelNode = SKLabelNode()
    
    convenience init(type: SignType, color: SignColor) {
        self.init()
        self.type = type
        self.color = color
        
        switch self.type {
        case .X:
            self.spriteLabelValue = "X"
        case .O:
            self.spriteLabelValue = "0"
        }
        
        self.sprite.text = self.spriteLabelValue
        self.sprite.horizontalAlignmentMode = .center
        self.sprite.verticalAlignmentMode = .center
        self.sprite.fontName = UISettings.sharedInstance.font1SemiBold
        
        switch self.color {
        case .Player1:
            self.sprite.fontColor = UIColor.init(red: 90.0/255.0, green: 177.0/255.0, blue: 142.0/255.0, alpha: 1.0)
        case .Player2:
            self.sprite.fontColor = UIColor.init(red: 238/255.0, green: 101.0/255.0, blue: 129.0/255.0, alpha: 1.0)
        }
    }
}
