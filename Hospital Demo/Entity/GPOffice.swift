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

  let minDimentions = CGSize(width: 3, height: 4)

  override init() {
    super.init()
    self.addComponent(BuildRoomComponent(minSize: minDimentions))

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

}
