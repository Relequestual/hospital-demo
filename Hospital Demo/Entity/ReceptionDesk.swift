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

  init(height: Int, width: Int) {
    super.init()

    let areaComponent = AreaComponent(width: width, height: height)
    self.addComponent(areaComponent)
    
  }


}

