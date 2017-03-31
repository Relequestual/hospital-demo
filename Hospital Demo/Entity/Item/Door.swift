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
  var position: PositionComponent
  var usePoints: UseableComponent?
  
  init(room: GKEntity, gridPosition: CGPoint, direction: Game.rotation) {
    self.room = room
    let realPosition = UtilConvert.gridToSpritePosition(gridPosition: gridPosition)
    self.position = PositionComponent(gridPosition: gridPosition, spritePosition: realPosition)
    
    let realPositionA = CGPoint(x: (realPosition?.x)!, y: (realPosition?.y)!)
    let realPositionB: CGPoint
    
    switch direction {
    case Game.rotation.north:
      realPositionB = CGPoint(x: (realPosition?.x)! - 64, y: (realPosition?.y)!)
    case Game.rotation.east:
      realPositionB = CGPoint(x: (realPosition?.x)!, y: (realPosition?.y)! - 64)
    case Game.rotation.south:
      realPositionB = CGPoint(x: (realPosition?.x)! + 64, y: (realPosition?.y)!)
    case Game.rotation.west:
      realPositionB = CGPoint(x: (realPosition?.x)!, y: (realPosition?.y)! + 64)

    }
    
    super.init()
//    For position A, need to invert `direction` because it will be the direction they need to face to use
    let usePoints = [
      UsePoint(
        type: UsePoint.usePointTypes.any,
        realPosition: realPositionA,
        direction: direction,
        use: self.use
      )
    ]
    self.usePoints = UseableComponent(usePoints: [])
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func use() -> Void {
    
  }
  
  
//  Usable component
//  has function hook for use action
//  requires pou or staffpou. Guard to require at least one of.
//  Door has statemachine for closed / opening / open / closing.
//
  
  
}
