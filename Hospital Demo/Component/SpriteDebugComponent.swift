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
    print(debugRect.description)
    debugRect.strokeColor = UIColor.cyanColor()
//    debugRect.fillColor = UIColor.blackColor()
    debugRect.zPosition = 100
    node.addChild(debugRect)
  }

}