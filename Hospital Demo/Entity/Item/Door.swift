//
//  Door.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 10/03/2017.
//  Copyright © 2017 Ben Hutton. All rights reserved.
//

import GameplayKit
import SpriteKit

class Door: GKEntity {
  var room: GKEntity
  var direction: Game.rotation

  var stateMachine = DoorState()

//  This is OK for now, but should be in a placeable item component of some type
  enum plan {
    case possible, planned
    mutating func toggle() {
      switch self {
      case .possible:
        print("should be planned")
        self = .planned
      case .planned:
        self = .possible
      }
    }
  }

  var planStatus: plan? {
    didSet {
      print("did set plan status")
      if planStatus != nil {
        setSprite(planStatus: planStatus!)
      }
    }
  }

  init(room: GKEntity, realPosition: CGPoint, direction: Game.rotation) {
    print("===== new room")
    self.room = room
    self.direction = direction
    super.init()

    addComponent(PositionComponent(realPosition: realPosition))

    planStatus = plan.possible
    setSprite(planStatus: plan.possible)
  }

//  DOING; WRITING THIS FUNCTION, OR RATHER RECREATING
  func completeDoor() {
    planStatus = nil

    let realPositionA = component(ofType: PositionComponent.self)!.spritePosition!
    let realPositionB: CGPoint
    var directionB = direction
    directionB.next()
    directionB.next()

//    I think this creates wrong placement of usepoints, but should make an in game debug UI thing first
    switch direction {
    case Game.rotation.north:
      realPositionB = CGPoint(x: (realPositionA.x) - 64, y: (realPositionA.y))
    case Game.rotation.east:
      realPositionB = CGPoint(x: (realPositionA.x), y: (realPositionA.y) - 64)
    case Game.rotation.south:
      realPositionB = CGPoint(x: (realPositionA.x) + 64, y: (realPositionA.y))
    case Game.rotation.west:
      realPositionB = CGPoint(x: (realPositionA.x), y: (realPositionA.y) + 64)
    }

//    Only need this when finalising the door
//    For position A, need to invert `direction` because it will be the direction they need to face to use
    let usePoints = [
      UsePoint(
        type: UsePoint.usePointTypes.any,
        realPosition: realPositionA,
        direction: self.direction,
        use: self.use
      ),
      UsePoint(
        type: UsePoint.usePointTypes.any,
        realPosition: realPositionB,
        direction: directionB,
        use: self.use
      ),
    ]

    addComponent(UseableComponent(usePoints: usePoints))

    print(self)

    let spriteComponent = SpriteComponent(texture: Door.doorGraphic)
    setSprite(spriteComponent: spriteComponent)

    if direction == .west || direction == .east {
      if #available(iOS 10.0, *) {
        spriteComponent.node.zRotation = CGFloat(Measurement(value: 90, unit: UnitAngle.degrees).converted(to: UnitAngle.radians).value)
      } else {
        spriteComponent.node.zRotation = 90 * .pi / 180
      }
    }
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func use() {
    stateMachine.nextState()
  }

  func setSprite(planStatus _: Door.plan) {
    print("==========setSprite")
    let circle = SKShapeNode(circleOfRadius: 32)
    circle.fillColor = SKColor.white
    let texture = SKView().texture(from: circle)

    let spriteComponent = SpriteComponent(texture: texture!)
    let node = spriteComponent.node

    node.colorBlendFactor = 1
    node.setScale(0.5)
    node.alpha = 0.7

    print(planStatus)

    if planStatus == .possible {
      node.color = SKColor.orange
    } else if planStatus == .planned {
      node.color = SKColor.blue
    }

    setSprite(spriteComponent: spriteComponent)
  }

  func setSprite(spriteComponent: SpriteComponent) {
    print("=========================set sprite 2")
    Game.sharedInstance.entityManager.remove(self)
    addComponent(spriteComponent)
    component(ofType: SpriteComponent.self)?.addToNodeKey()
    Game.sharedInstance.entityManager.add(self, layer: ZPositionManager.WorldLayer.interaction)
  }

  static let doorGraphic = Door.compileSprite()

  static func compileSprite() -> SKTexture {
    let node = SKShapeNode(rectOf: CGSize(width: 40, height: 4))
    node.fillColor = UIColor.brown
    node.strokeColor = UIColor.clear
    let texture = SKView().texture(from: node)
    return texture!
  }
}
