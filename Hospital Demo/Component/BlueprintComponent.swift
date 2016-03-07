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
  var pous : [[Int]]
  
  var baring = Game.rotation.North

  var planFunction: (position: CGPoint)->Void;
  
  init(area: [[Int]], pous: [[Int]], pf:(position: CGPoint) -> Void) {
    self.area = area
    self.pous = pous
    self.planFunction = pf
  }

  func planFunctionCall(position: CGPoint) {
    self.planFunction(position: position)
  }
  
  func rotate(var previousRotation: Game.rotation) {
    previousRotation.next()
    let newRotation = previousRotation
    

      for var i = 0; i < self.area.count; i++ {
        var coord = self.area[i]
        coord = [coord[1] * 1, coord[0] * -1]
        self.area[i] = coord
      }
      for var i = 0; i < self.pous.count; i++ {
        var coord = self.pous[i]
        coord = [coord[1] * 1, coord[0] * -1]
        self.pous[i] = coord
      }
//        print(self.area)
        

    self.baring = newRotation
  }
  
}
