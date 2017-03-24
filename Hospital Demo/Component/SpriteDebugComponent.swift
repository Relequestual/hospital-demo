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
  
  static var debugLayer = SKNode()

  init(node: SKSpriteNode ) {
    super.init()
    let size = node.texture?.size()
    let position = node.position
//    print(size)

    let debugRect = SKShapeNode(rectOf: size!)
    debugRect.strokeColor = UIColor.cyan
    debugRect.zPosition = 100
    debugRect.position = position
    SpriteDebugComponent.debugLayer.addChild(debugRect)

    let anchorPoint = SKShapeNode(circleOfRadius: 2.0)
    anchorPoint.fillColor = UIColor.red
    anchorPoint.zPosition = 100
    anchorPoint.position = position
    SpriteDebugComponent.debugLayer.addChild(anchorPoint)

    let desc = SKLabelNode(text: NSStringFromCGPoint(CGPoint(x: (position.x - 32) / 64, y: (position.y - 32) / 64)))
    desc.fontColor = UIColor.black
    desc.zPosition = 100
    desc.position = CGPoint(x: position.x-28, y: position.y-28)
    desc.fontSize = 10
    desc.fontName = "AvenirNext-Bold"

    desc.verticalAlignmentMode = .bottom
    desc.horizontalAlignmentMode = .left

    SpriteDebugComponent.debugLayer.addChild(desc)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
//  static func getDebugNode() -> SKNode{
//    return debugLayer
//  }

}
