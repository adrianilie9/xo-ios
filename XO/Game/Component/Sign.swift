//
//  Sign.swift
//  XO
//

import Foundation
import SpriteKit

enum SignType {
    case X
    case O
}

class Sign {
    public var type: SignType = .X
    
    private var spriteLabelValue: String = "X"
    public var sprite: SKLabelNode = SKLabelNode()
    
    convenience init(type: SignType) {
        self.init()
        
        self.type = type
        
        self.sprite.text = self.spriteLabelValue
        self.sprite.horizontalAlignmentMode = .center
        self.sprite.verticalAlignmentMode = .center
        self.sprite.fontName = UISettings.sharedInstance.font1SemiBold
        
        switch self.type {
        case .X:
            self.sprite.text = "X"
            self.sprite.fontColor = UIColor.init(red: 90.0/255.0, green: 177.0/255.0, blue: 142.0/255.0, alpha: 1.0)
            
            break
        case .O:
            self.sprite.text = "0"
            self.sprite.fontColor = UIColor.init(red: 238/255.0, green: 101.0/255.0, blue: 129.0/255.0, alpha: 1.0)
            
            break
        }
    }
}
