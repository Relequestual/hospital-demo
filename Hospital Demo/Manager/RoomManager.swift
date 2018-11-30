//
//  RoomManager.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 31/10/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

// The RoomManager class is for keeping track of rooms that have been built
class RoomManager {

  var knownRoomTypes: [RoomDefinitions.BaseRoomTypes: RoomDefinitions.RoomTypeSpec]

  var knownRooms: [RoomDefinitions.BaseRoomTypes:[GKEntity]] = [:]

  var untypedRooms: [GKEntity] = []

  var allRooms: [GKEntity] {
    get {
      var rooms: [GKEntity] = []
      rooms = knownRooms.reduce([]) { (result, arg1) -> Array<GKEntity> in
        let (key, value) = arg1
        return value
      }
      rooms.append(contentsOf: untypedRooms)
      return rooms
    }
  }


  // Compile the set of known item types given an array of item specs
  init(roomTypes:[RoomDefinitions.BaseRoomTypes: RoomDefinitions.RoomTypeSpec]) {

    self.knownRoomTypes = roomTypes.reduce(into: [:]) { ( roomTypes: inout [RoomDefinitions.BaseRoomTypes: RoomDefinitions.RoomTypeSpec], roomSpec) in
      let (key, value) = roomSpec
      roomTypes[key] = value
    }

    print(self.knownRoomTypes)

  }

//  Builds the room entity and components
  func createEntity() -> GKEntity {
    let entity = GKEntity()

    entity.addComponent(BuildRoomComponent())

    let roomSpecComponent = RoomSpecComponent()
    entity.addComponent(roomSpecComponent)

//    let itemSpecComponent = ItemSpecComponent(spec: roomDef)
//    entity.addComponent(itemSpecComponent)

//    let blueprint = ItemBlueprintComponent(itemSpec: itemSpecComponent)
//    entity.addComponent(blueprint)
//
//    entity.addComponent(DraggableSpriteComponent(start: BISPlan.dragStartHandler, move: BISPlan.dragMoveHandler, end: BISPlan.dragEndHandler))
//
//    entity.addComponent(BuildItemComponent())


//    let spriteComponent = SpriteComponent(texture: roomDef.texture)
//    entity.addComponent(spriteComponent)

    self.untypedRooms.append(entity)

    return entity

  }

  func plan(room: GKEntity, point: CGPoint) {
    room.component(ofType: BuildRoomComponent.self)?.clearPlan()
    room.component(ofType: BuildRoomComponent.self)?.planAtPoint(point)
    room.component(ofType: BuildRoomComponent.self)?.needConfirmBounds()
  }

}
