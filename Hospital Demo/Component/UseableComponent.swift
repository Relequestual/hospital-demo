//
//  UseableComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 10/03/2017.
//  Copyright © 2017 Ben Hutton. All rights reserved.
//

import GameplayKit
import SpriteKit

//Need to create a struct for the usePoints. duh.

struct UsePoint {
  enum usePointTypes { case patient, staff, any }
  var type: usePointTypes
  var realPosition: CGPoint
  var direction: Game.rotation.Type
  var f:() -> Void
}

class UseableComponent: GKComponent {
  
  var usePoints: Array<UsePoint>
  
  init(usePoints: Array<UsePoint>) {
    self.usePoints = usePoints
    
  }
  
  func callFunction(usePoint: UsePoint) {
    guard let index = self.usePoints.indexOf({ (up) -> Bool in
      return up.realPosition == usePoint.realPosition
    }) else {
      
      return
    }
    
    self.usePoints[index].f()
    
  }
  
}