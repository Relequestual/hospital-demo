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
  var stateMachine = DoorState()
//  This is OK for now, but should be in a placeable item component of some type
  enum plan {
    case possible, planned
    mutating func toggle() {
      switch self {
      case .possible:
        self = .planned
      case .planned:
        self = .possible
      }
    }
  }
  var planStatus: plan? {
    didSet {
      guard planStatus != nil else {
        return
      }
      self.setSprite(planStatus: self.planStatus!)
    }
  }
  
  init(room: GKEntity, realPosition: CGPoint, direction: Game.rotation) {
    self.room = room
    super.init()
    
    self.addComponent(PositionComponent(realPosition: realPosition))
    
    self.planStatus = plan.possible
    
//    let realPositionA = CGPoint(x: (realPosition.x), y: (realPosition.y))
//    let realPositionB: CGPoint
//    var directionB = direction
//    directionB.next()
//    directionB.next()
//    
//    
//    switch direction {
//    case Game.rotation.north:
//      realPositionB = CGPoint(x: (realPosition.x) - 64, y: (realPosition.y))
//    case Game.rotation.east:
//      realPositionB = CGPoint(x: (realPosition.x), y: (realPosition.y) - 64)
//    case Game.rotation.south:
//      realPositionB = CGPoint(x: (realPosition.x) + 64, y: (realPosition.y))
//    case Game.rotation.west:
//      realPositionB = CGPoint(x: (realPosition.x), y: (realPosition.y) + 64)
//
//    }

//    Only need this when finalising the door
////    For position A, need to invert `direction` because it will be the direction they need to face to use
//    let usePoints = [
//      UsePoint(
//        type: UsePoint.usePointTypes.any,
//        realPosition: realPositionA,
//        direction: direction,
//        use: self.use
//      ),
//      UsePoint(
//        type: UsePoint.usePointTypes.any,
//        realPosition: realPositionB,
//        direction: directionB,
//        use: self.use
//      )
//    ]
//
//    self.addComponent(UseableComponent(usePoints: usePoints))

    Game.sharedInstance.entityManager.add(self, layer: ZPositionManager.WorldLayer.interaction)
//    Later change to world layer
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func use() -> Void {
    self.stateMachine.nextState()
  }
  
  func setSprite(planStatus: Door.plan) {
    let texture = Game.sharedInstance.mainView?.texture(from: SKShapeNode(circleOfRadius: 32))
    
    let spriteComponent = SpriteComponent(texture: texture!)
    let node = spriteComponent.node
    
    switch self.planStatus {
    case .some:
      node.colorBlendFactor = 1
      //    This position is wrong
      node.position = (self.component(ofType: PositionComponent.self)?.spritePosition)!
      node.setScale(0.5)
      fallthrough
    case .some(.possible):
      node.color = SKColor.orange
    case .some(.planned):
      node.color = SKColor.green
    default:
      break
    }
    
    self.setSprite(spriteComponent: spriteComponent)
  }
  
  func setSprite(spriteComponent: SpriteComponent) {
    self.addComponent(spriteComponent)
  }
  
}
