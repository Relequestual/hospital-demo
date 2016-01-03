//
//  SpriteDebugComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 30/12/2015.
//  Copyright © 2015 Ben Hutton. All rights reserved.
//

import GameplayKit
import SpriteKit

class SpriteDebugComponent: GKComponent {

  init(node: SKSpriteNode ) {
    let size = node.texture?.size()
    print(size)

    let debugRect = SKShapeNode(rectOfSize: size!)
    debugRect.strokeColor = UIColor.cyanColor()
    debugRect.zPosition = 100
    node.addChild(debugRect)
    
  }

}