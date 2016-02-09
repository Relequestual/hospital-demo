//
//  AreaComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 08/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import SpriteKit
import GameplayKit

class AreaComponent: GKComponent {

  var width : Int
  var height : Int

  init(width : Int, height : Int) {
    self.width = width
    self.height = height
  }
}
