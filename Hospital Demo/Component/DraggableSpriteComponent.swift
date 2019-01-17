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
  var entityTouchStart: (GKEntity, CGPoint) -> Void
  var entityTouchMove: (GKEntity, CGPoint) -> Void
  var entityTouchEnd: (GKEntity, CGPoint) -> Void

  var startPoint: CGPoint?
  var movedPoint: CGPoint?
  var endPoint: CGPoint?

  var draggable: Bool = true

  init(start: @escaping (GKEntity, CGPoint) -> Void, move: @escaping (GKEntity, CGPoint) -> Void, end: @escaping (GKEntity, CGPoint) -> Void) {
    entityTouchStart = start
    entityTouchMove = move
    entityTouchEnd = end
    super.init()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func touchStart(_ point: CGPoint) {
    if !(draggable) {
      return
    }
    startPoint = point
    entityTouchStart(self.entity!, point)
  }

  func touchMove(_ point: CGPoint) {
    print("draggable?")
    print(draggable)
    if !(draggable) {
      return
    }
    movedPoint = point
    entityTouchMove(self.entity!, point)
  }

  func touchEnd(_ point: CGPoint) {
    if !(draggable) {
      return
    }
    endPoint = point
    entityTouchEnd(self.entity!, point)
  }
}
