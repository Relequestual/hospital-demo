//
//  PositionComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 23/12/2015.
//  Copyright © 2015 Ben Hutton. All rights reserved.
//

import SpriteKit
import GameplayKit

class PositionComponent: GKComponent {

    let position = what?
    
    init(texture: SKTexture) {
        node = SKSpriteNode(texture: texture, color: SKColor.whiteColor(), size: texture.size())
    }
}
