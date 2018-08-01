//
//  Tile.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 19/12/2015.
//  Copyright © 2015 Ben Hutton. All rights reserved.
//

import GameplayKit
import SpriteKit

class Tile: GKEntity {
  enum tileTypes {
    case tile
    case grass
    case path
  }

  var tileType: tileTypes

  var isBuildingOn = false
  var unbuildable: Bool
  var isRoomFloor = false
  var blocked: Bool {
    didSet {
      if blocked == true {
        unbuildable = true
        walls.setAll(toBool: true)
      }
    }
  }

  var walls = sides_blocked_status()

  struct sides_blocked_status {
    var index = [
      Game.rotation.north: false,
      Game.rotation.east: false,
      Game.rotation.south: false,
      Game.rotation.west: false,
    ]

    var sprites: Dictionary<Game.rotation, SKShapeNode?> = [:]

    mutating func addWall(ofBaring: Game.rotation) {
      index[ofBaring] = true
    }

    mutating func removeWall(ofBaring: Game.rotation) {
      index[ofBaring] = false
    }

    func get(baring: Game.rotation) -> Bool {
      return index[baring]!
    }

    mutating func setAll(toBool: Bool) {
      for i in index.keys {
        index[i] = toBool
      }
    }

    func anyBlocked() -> Bool {
      return index.values.contains(true)
    }
  }

  let wallVert = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 4, height: 64))
  let wallHoriz = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 64, height: 4))

  func addWall(ofBaring: Game.rotation, room: Room) {
    walls.addWall(ofBaring: ofBaring)
    let sprite: SKShapeNode
    if ofBaring == .north || ofBaring == .south {
      sprite = wallHoriz.copy() as! SKShapeNode
    } else {
      sprite = wallVert.copy() as! SKShapeNode
    }
    sprite.fillColor = UIColor.black
    sprite.position = (component(ofType: PositionComponent.self)?.spritePosition)!
    sprite.strokeColor = UIColor.clear

    switch ofBaring {
    case .north:
      sprite.position = CGPoint(x: sprite.position.x - 32, y: sprite.position.y + 32 - 4)
    case .south:
      sprite.position = CGPoint(x: sprite.position.x - 32, y: sprite.position.y - 32)
    case .east:
      sprite.position = CGPoint(x: sprite.position.x + 32 - 4, y: sprite.position.y - 32)
    case .west:
      sprite.position = CGPoint(x: sprite.position.x - 32, y: sprite.position.y - 32)
    }

    sprite.zPosition = CGFloat(ZPositionManager.WorldLayer.room.zpos + 1)
    walls.sprites[ofBaring] = sprite
    Game.sharedInstance.entityManager.node.addChild(sprite)
    room.walls.append(sprite)
  }

  init(imageName: String, initType: tileTypes = tileTypes.tile, x: Int, y: Int) {
    tileType = initType

    switch initType {
    case tileTypes.tile:
      unbuildable = false
      blocked = false
    case _ where initType == tileTypes.grass || initType == tileTypes.path:
      unbuildable = true
      blocked = true
    default:
      unbuildable = false
      blocked = false
    }

    super.init()

    let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
    addComponent(spriteComponent)
    spriteComponent.addToNodeKey()

    let width = Int((spriteComponent.node.texture?.size().width)!)
    let sx = width * x + width / 2
    let sy = width * y + width / 2

    let positionComponent = PositionComponent(gridPosition: CGPoint(x: x, y: y), spritePosition: CGPoint(x: sx, y: sy))

    addComponent(positionComponent)

    spriteComponent.node.position = CGPoint(x: x, y: y)


    let touchableComponent = TouchableSpriteComponent {
      Game.sharedInstance.touchTile(tile: self)
    }

    addComponent(touchableComponent)

    Game.sharedInstance.touchTile = { tile in 
      print("tile was touched")
    }

    let spriteDebugComponent = SpriteDebugComponent(node: spriteComponent.node)
    addComponent(spriteDebugComponent)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  

  var debugNode: SKShapeNode?

  func highlight(_ position: CGPoint, colour: UIColor = UIColor.yellow) {
//    let position = self.componentForClass(PositionComponent.self)?.spritePosition
    debugNode = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
    debugNode!.position = position
    debugNode!.strokeColor = colour
    debugNode!.zPosition = 1_000_000
    Game.sharedInstance.entityManager.node.addChild(debugNode!)
    print("====highlighting tile")
  }
}
