//
//  PositionComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 23/12/2015.
//  Copyright © 2015 Ben Hutton. All rights reserved.
//

import SpriteKit
import GameplayKit


class PositionComponent: GKComponent {

  var gridPosition: CGPoint
  var spritePosition: CGPoint?

  init(gridPosition: CGPoint, spritePosition: CGPoint?=nil) {
    self.gridPosition = gridPosition
    self.spritePosition = spritePosition
    super.init()
  }
  
  init(realPosition: CGPoint) {
    self.gridPosition = CGPoint(x: realPosition.x / 32, y: realPosition.y / 32)
    self.spritePosition = realPosition
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
