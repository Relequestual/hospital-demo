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
  
  var entityTouchStart: ()->Void;
  var entityTouchMove: (CGPoint)->Void;
  var entityTouchEnd: ()->Void;
  
  init(start:() -> Void, move:(CGPoint) -> Void, end:() -> Void) {
    self.entityTouchStart = start
    self.entityTouchMove  = move
    self.entityTouchEnd   = end
  }
  
  func touchStart() {
    self.entityTouchStart()
  }
  
  func touchMove(point: CGPoint) {
    self.entityTouchMove(point)
  }
  
  func touchEnd() {
    self.entityTouchEnd()
  }
  
}
