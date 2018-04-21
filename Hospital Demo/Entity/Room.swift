//
//  Room.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 06/08/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import GameplayKit
import SpriteKit

class Room: GKEntity {
  let minDimentions = CGSize(width: 2, height: 2)

  var doors: [Door] = []
  var walls: [SKShapeNode] = []

  static let floorNode: SKSpriteNode = Room.createFloorNode()

  override init() {
    super.init()
//    This is wrong. It's not a component, but an entity.
//    let roomBPComponent = RoomBlueprint(size: minDimentions, room: self)
    addComponent(BuildRoomComponent(minSize: minDimentions))
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func addDoor(door: Door) {
    doors.append(door)
  }

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
        let squareNode = Room.floorNode.copy() as! SKSpriteNode
        squareNode.position = CGPoint(x: x * width + base, y: y * width + base)
        node.addChild(squareNode)
      }
    }
    return SKView().texture(from: node)!
  }
}
