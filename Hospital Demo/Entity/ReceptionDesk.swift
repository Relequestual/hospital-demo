//
//  ReceptionDesk.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 08/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import SpriteKit
import GameplayKit

class ReceptionDesk: GKEntity {

  let area = [[0,0], [1,0]]
  
  override init() {
    super.init()

    let blueprint = BlueprintComponent(area: area, pf: { tile in
      self.planAtPoint(tile)
    })
    self.addComponent(blueprint)
    
  }
  
  func planAtPoint(tile: Tile){
    print("planning reception desk at ")
    print(tile)
  }


}

