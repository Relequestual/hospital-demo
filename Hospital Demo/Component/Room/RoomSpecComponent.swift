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

  var roomType: RoomDefinitions.BaseRoomTypes?

}
