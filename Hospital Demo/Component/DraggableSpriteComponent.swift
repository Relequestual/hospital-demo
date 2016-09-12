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
  
  var entityTouchStart: (CGPoint)->Void
  var entityTouchMove: (CGPoint)->Void
  var entityTouchEnd: (CGPoint)->Void
  
  var startPoint:CGPoint?
  var movedPoint:CGPoint?
  var endPoint:CGPoint?
  
  init(start:(CGPoint) -> Void, move:(CGPoint) -> Void, end:(CGPoint) -> Void) {
    self.entityTouchStart = start
    self.entityTouchMove  = move
    self.entityTouchEnd   = end
  }
  
  func touchStart(point: CGPoint) {
    self.startPoint = point
    self.entityTouchStart(point)
  }
  
  func touchMove(point: CGPoint) {
    self.movedPoint = point
    self.entityTouchMove(point)
  }
  
  func touchEnd(point: CGPoint) {
    self.endPoint = point
    self.entityTouchEnd(point)
  }
  
}
