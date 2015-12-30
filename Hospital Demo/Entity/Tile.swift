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
    let width = Int((spriteComponent.node.texture?.size().width)!)
    let x = width * x
    let y = width * y

    let positionComponent = PositionComponent(x: x, y: y)

    addComponent(spriteComponent)
    addComponent(positionComponent)

    spriteComponent.node.anchorPoint = CGPoint(x: 0, y: 0)
    spriteComponent.node.position = CGPoint(x: x, y: y)

  }
}
