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

  var position: CGPoint

  init(x : Int, y : Int) {
    self.position = CGPoint(x: x, y: y)
  }
}
