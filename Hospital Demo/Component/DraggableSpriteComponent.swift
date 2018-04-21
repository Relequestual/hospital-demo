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
  var entityTouchStart: (CGPoint) -> Void
  var entityTouchMove: (CGPoint) -> Void
  var entityTouchEnd: (CGPoint) -> Void

  var startPoint: CGPoint?
  var movedPoint: CGPoint?
  var endPoint: CGPoint?

  var draggable: Bool = true

  init(start: @escaping (CGPoint) -> Void, move: @escaping (CGPoint) -> Void, end: @escaping (CGPoint) -> Void) {
//    Working here.
//    Calling these directly rather than through this classes function accessors!! duh!
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
    entityTouchStart(point)
  }

  func touchMove(_ point: CGPoint) {
    print("draggable?")
    print(draggable)
    if !(draggable) {
      return
    }
    movedPoint = point
    entityTouchMove(point)
  }

  func touchEnd(_ point: CGPoint) {
    if !(draggable) {
      return
    }
    endPoint = point
    entityTouchEnd(point)
  }
}
