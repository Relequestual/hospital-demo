//
//  TouchableSpriteComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 08/05/2016.
//  Copyright © 2015 Ben Hutton. All rights reserved.
//

import GameplayKit
import SpriteKit

class DraggableSpriteComponent: GKComponent {
  
  var entityTouched: ()->Void;
  
  init(f:() -> Void) {
    self.entityTouched = f
  }
  
  func callFunction() {
    self.entityTouched()
  }
  
}
