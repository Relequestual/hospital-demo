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

  var planFunction: (position: CGPoint)->Void;
  
  init(area: [[Int]], pf:(position: CGPoint) -> Void) {
    self.area = area
    self.planFunction = pf
  }

  func planFunctionCall(position: CGPoint) {
    self.planFunction(position: position)
  }
}
