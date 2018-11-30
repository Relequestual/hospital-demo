//
//  RoomUtil.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 06/08/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import GameplayKit
import SpriteKit

class RoomUtil {

  static let floorNode: SKSpriteNode = RoomUtil.createFloorNode()

//  static func createFloorNode(color: UIColor = UIColor.init(red: 150, green: 20, blue: 20, alpha: 0)) -> SKSpriteNode {
  static func createFloorNode() -> SKSpriteNode {
    let node = SKShapeNode(rectOf: CGSize(width: 64, height: 64))
    let color = SKColor(red: 238 / 255, green: 102 / 255, blue: 101 / 255, alpha: 1)
    node.lineWidth = 0
    node.fillColor = color
    node.strokeColor = color
    return SKSpriteNode(texture: SKView().texture(from: node))
  }

  static func createFloorTexture(_ roomSize: CGSize) -> SKTexture {
    let node = SKSpriteNode()
    let base = 32
    let width = 64

    for x in 1 ... Int(roomSize.width) {
      for y in 1 ... Int(roomSize.height) {
        let squareNode = RoomUtil.floorNode.copy() as! SKSpriteNode
        squareNode.position = CGPoint(x: x * width + base, y: y * width + base)
        node.addChild(squareNode)
      }
    }
    return SKView().texture(from: node)!
  }
}
