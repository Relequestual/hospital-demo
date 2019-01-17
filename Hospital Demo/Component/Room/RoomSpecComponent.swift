//
//  RoomSpecComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 09/11/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import GameplayKit
import SpriteKit

class RoomSpecComponent: GKComponent {

  var doors: [Door] = []
  var walls: [SKShapeNode] = []

  
  private var _roomType: RoomDefinitions.BaseRoomTypes?

  var roomType: RoomDefinitions.BaseRoomTypes? {
    get {
      return _roomType
    }
    set(roomType) {
      _roomType = roomType
      Game.sharedInstance.roomManager?.registerRoomTypeChange(self.entity!)
    }
  }

  func updateRoomFloorColour() {
    var roomColour = RoomDefinitions.defaultRoomColor

    if (self.roomType != nil) {
      roomColour = (RoomDefinitions.rooms[roomType!]?.floorColor)!
    }
    self.changeFloorColour(color: roomColour)
  }

  func changeFloorColour(color: SKColor, alpha: CGFloat = 1.0) {
    let newFloorNodeTexture = RoomUtil.createFloorTexture(self.entity!.component(ofType: RoomBlueprintComponent.self)!.size, colour: color)
    self.entity?.component(ofType: SpriteComponent.self)?.node.texture = newFloorNodeTexture
    self.entity?.component(ofType: SpriteComponent.self)?.node.alpha = alpha
  }


}
