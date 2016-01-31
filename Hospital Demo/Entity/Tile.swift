//
//  Tile.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 19/12/2015.
//  Copyright © 2015 Ben Hutton. All rights reserved.
//

import SpriteKit
import GameplayKit

class Tile: GKEntity {

  init(imageName: String, x: Int, y: Int) {
    super.init()

    let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
    addComponent(spriteComponent)
    spriteComponent.addToNodeKey()

    let width = Int((spriteComponent.node.texture?.size().width)!)
    let x = width * x + width / 2
    let y = width * y + width / 2

    let positionComponent = PositionComponent(x: x, y: y)

    addComponent(positionComponent)
    
    spriteComponent.node.position = CGPoint(x: x, y: y)
    
    let spriteDebugComponent = SpriteDebugComponent(node: spriteComponent.node)
    addComponent(spriteDebugComponent)

  }
}
