//
//  Room.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 06/08/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import SpriteKit
import GameplayKit

class Room: GKEntity {

  let minDimentions = CGSize(width: 3, height: 4)
  
  var doors: [Door] = []

  override init() {
    super.init()
    let roomBPComponent = RoomBlueprint(size: minDimentions, room: self)
    self.addComponent(BuildRoomComponent(minSize: minDimentions, roomBlueprint: roomBPComponent))

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func addDoor(door:Door) {
    self.doors.append(door)
  }
  

}
