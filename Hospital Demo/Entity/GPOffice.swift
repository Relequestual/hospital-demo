//
//  GPOffice.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 06/08/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import SpriteKit
import GameplayKit

class GPOffice: GKEntity {

  let minDimentions = CGSize(width: 4, height: 4)

  override init() {
    super.init()
    self.addComponent(BuildRoomComponent(minSize: minDimentions))

  }
  

}
