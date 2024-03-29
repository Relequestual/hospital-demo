//
//  UseableComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 10/03/2017.
//  Copyright © 2017 Ben Hutton. All rights reserved.
//

import GameplayKit
import SpriteKit

// Need to create a struct for the usePoints. duh.

struct UsePoint {
  enum usePointTypes { case patient, staff, any }
  var type: usePointTypes
  var realPosition: CGPoint
  var direction: Game.rotation
  var use: () -> Void
}

class UseableComponent: GKComponent {
  var usePoints: Array<UsePoint>

  init(usePoints: Array<UsePoint>) {
    self.usePoints = usePoints
    super.init()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func callFunction(_ usePoint: UsePoint) {
    guard let index = self.usePoints.index(where: { (up) -> Bool in
      up.realPosition == usePoint.realPosition
    }) else {
      return
    }

    usePoints[index].use()
  }
}
