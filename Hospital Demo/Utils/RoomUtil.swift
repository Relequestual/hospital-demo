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

//  static let floorColor: SKColor = SKColor(red: 238 / 255, green: 102 / 255, blue: 101 / 255, alpha: 1)

  // Create spriteNode of one square of a given colour, or default floor colour for rooms
  static func createFloorNode(colour: SKColor) -> SKSpriteNode {
    let node = SKShapeNode(rectOf: CGSize(width: 64, height: 64))
    node.lineWidth = 0
    node.fillColor = colour
    node.strokeColor = colour
    return SKSpriteNode(texture: SKView().texture(from: node))
  }

  static func createFloorTexture(_ roomSize: CGSize, colour: SKColor = RoomDefinitions.defaultRoomColor) -> SKTexture {
    let node = SKSpriteNode()
    let base = 32
    let width = 64

    let floorNode: SKSpriteNode = RoomUtil.createFloorNode(colour: colour)

    for x in 1 ... Int(roomSize.width) {
      for y in 1 ... Int(roomSize.height) {
        let squareNode = floorNode.copy() as! SKSpriteNode
        squareNode.position = CGPoint(x: x * width + base, y: y * width + base)
        node.addChild(squareNode)
      }
    }
    return SKView().texture(from: node)!
  }

  static func createFloorNode(withSize size: CGSize, colour: SKColor = RoomDefinitions.defaultRoomColor) -> SKSpriteNode {
    let texture = RoomUtil.createFloorTexture(size, colour: colour)
    let floorNode = SKSpriteNode(texture: texture)
    return floorNode
  }
}
