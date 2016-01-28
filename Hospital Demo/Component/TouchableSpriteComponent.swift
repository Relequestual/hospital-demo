//
//  TouchableSpriteComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 19/12/2015.
//  Copyright © 2015 Ben Hutton. All rights reserved.
//

import GameplayKit
import SpriteKit

class ToucheableSpriteComponent: GKComponent {
  
  let node: Touchable
  
  init(node: Touchable) {
    print("created touchable?")
    self.node = node
  }
}
