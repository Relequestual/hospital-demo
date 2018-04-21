//
//  zPositionManager.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 26/07/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class ZPositionManager {
  static let currentzPositionScale = 5000

  enum WorldLayer: Int {
    case ground = 1
    case world
    case room
    case item
    case planning
    case interaction
    case ui
    case layerCount

    var zpos: Int {
      return Int(rawValue * currentzPositionScale)
    }
  }

  var topMost: [Int: Int] = [:]

  init() {
    for layer in 1 ... WorldLayer.layerCount.rawValue {
      topMost[WorldLayer(rawValue: layer)!.rawValue] = WorldLayer(rawValue: layer)!.zpos
    }

    print(topMost)
  }
}
