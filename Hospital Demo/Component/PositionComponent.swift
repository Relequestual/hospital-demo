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
  }
}
