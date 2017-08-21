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
    case planning
    case interaction
    case ui
    case layerCount

    var zpos: Int {
      return Int(self.rawValue * currentzPositionScale)
    }
  }
  
  var topMost: [Int : Int] = [:]
  
  init() {
    
    for layer in 1 ... WorldLayer.layerCount.rawValue {
      self.topMost[WorldLayer.init(rawValue: layer)!.rawValue] = WorldLayer.init(rawValue: layer)!.zpos
    }
    
    print(topMost)
    
  }
  
}