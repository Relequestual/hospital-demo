//
//  Room.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 06/08/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import SpriteKit
import GameplayKit

class Room: GKEntity {

  let minDimentions = CGSize(width: 2, height: 2)
  
  var doors: [Door] = []
  
  static let floorNode: SKSpriteNode = Room.createFloorNode()

  override init() {
    super.init()
//    This is wrong. It's not a component, but an entity.
//    let roomBPComponent = RoomBlueprint(size: minDimentions, room: self)
    self.addComponent(BuildRoomComponent(minSize: minDimentions, room: self))

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func addDoor(door:Door) {
    self.doors.append(door)
  }
  
//  static func createFloorNode(color: UIColor = UIColor.init(red: 150, green: 20, blue: 20, alpha: 0)) -> SKSpriteNode {
  static func createFloorNode() -> SKSpriteNode {

    let node = SKShapeNode(rectOf: CGSize(width: 60, height: 60))
    let color = SKColor(red: 100, green: 0, blue: 0, alpha: 1)
    node.lineWidth = 0
    node.fillColor = color
    node.strokeColor = color
    return SKSpriteNode(texture: SKView().texture(from: node))
  }
  
  
  func createFloorTexture(_ roomSize: CGSize) -> SKTexture {
    let node = SKSpriteNode()
    let base = 32
    let width = 64
    
    for x in 1...Int(roomSize.width) {
      for y in 1...Int(roomSize.height) {
        let squareNode = Room.floorNode.copy() as! SKSpriteNode
        squareNode.position = CGPoint(x: x * width + base, y: y * width + base)
        node.addChild(squareNode)
      }
    }
    return SKView().texture(from: node)!
  }


}
