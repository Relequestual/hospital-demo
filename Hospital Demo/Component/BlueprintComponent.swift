//
//  BlueprintComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 10/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//


import SpriteKit
import GameplayKit

class BlueprintComponent: GKComponent {
  
  var area : [[Int]]

  var planFunction: (tile: Tile)->Void;
  
  init(area: [[Int]], pf:(tile: Tile) -> Void) {
    self.area = area
    self.planFunction = pf
  }

  func planFunctionCall(tile: Tile) {
    self.planFunction(tile: tile)
  }
}
