//
//  RoomDefinitions.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 31/10/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit


class RoomDefinitions {

  struct RoomTypeSpec {

    let name: String
    let description: String

    let requiredItems: [ItemDefinitions.BaseItems: Int]
    let floorColor: SKColor
    
  }

  static let defaultRoomColor = SKColor.lightGray

  enum BaseRoomTypes {
    case GPOffice
    case Pharmacy
  }

  static let rooms: [BaseRoomTypes: RoomTypeSpec] = [
    BaseRoomTypes.GPOffice: RoomTypeSpec(
      name: "GP's Office",
      description: "An office for a GP",
      requiredItems: [
        ItemDefinitions.BaseItems.StaffDesk : 1,
        ItemDefinitions.BaseItems.PateintChair: 1,
        ItemDefinitions.BaseItems.ExamBed: 1
      ],
      floorColor: SKColor.cyan
    ),
    BaseRoomTypes.Pharmacy: RoomTypeSpec(
      name: "Pharmacy",
      description: "Dispense drugs",
      requiredItems: [:],
      floorColor: SKColor.green
    )
  ]
}
