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
  
//  Let's not have a room component yet, and in stead have props here
  
  var doors: [Door] = []

  override init() {
    super.init()
    let roomBPComponent = RoomBlueprint(size: minDimentions, room: self)
    self.addComponent(BuildRoomComponent(minSize: minDimentions, roomBlueprint: roomBPComponent))

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

}
