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
  
  init(room: GKEntity, gridPosition: CGPoint) {
    self.room = room
    self.position = PositionComponent(gridPosition: gridPosition)
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
//  Usable component
//  has function hook for use action
//  requires pou or staffpou. Guard to require at least one of.
//  Door has statemachine for closed / opening / open / closing.
//
  
  
}
