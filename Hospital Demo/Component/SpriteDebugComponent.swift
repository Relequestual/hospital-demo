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
    super.init()
    let size = node.texture?.size()
    let position = node.position
    print(size)

    let debugRect = SKShapeNode(rectOfSize: size!)
    debugRect.strokeColor = UIColor.cyanColor()
    debugRect.zPosition = 100
    node.addChild(debugRect)

    let anchorPoint = SKShapeNode(circleOfRadius: 2.0)
    anchorPoint.fillColor = UIColor.redColor()
    anchorPoint.zPosition = 100
    node.addChild(anchorPoint)


    let desc = SKLabelNode(text: NSStringFromCGPoint(CGPoint(x: (position.x - 32) / 64, y: (position.y - 32) / 64)))
    desc.fontColor = UIColor.blackColor()
    desc.zPosition = 100
    desc.position = CGPoint(x: -32, y: -32)
    desc.fontSize = 10
    desc.fontName = "AvenirNext-Bold"

    desc.verticalAlignmentMode = .Bottom
    desc.horizontalAlignmentMode = .Left

    node.addChild(desc)

  }

}