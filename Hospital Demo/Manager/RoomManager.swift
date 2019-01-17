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

  var typedRooms = [RoomDefinitions.BaseRoomTypes:Set<GKEntity>]()

  var untypedRooms: Set<GKEntity> = Set()

  var allRooms: Set<GKEntity> {
    get {
      var rooms: Set<GKEntity> = Set()
      rooms = typedRooms.reduce([]) { (result, arg1) -> Set<GKEntity> in
        let (_, value) = arg1
        return result.union(value)
      }
      rooms = rooms.union(untypedRooms)
      return rooms
    }
  }

  private var _proposedTypedRoom: GKEntity?

  var proposedTypedRoom: GKEntity? {
    set(proposedTypedRoom) {
      // Set the colour back to planned blue colour
      _proposedTypedRoom?.component(ofType: RoomSpecComponent.self)!.changeFloorColour(color: SKColor.blue, alpha: 0.3)
      _proposedTypedRoom = proposedTypedRoom

      if (proposedTypedRoom == nil) {
        return
      }

    }
    get {
      return _proposedTypedRoom
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

  func add(_ entity: GKEntity) {
    self.untypedRooms.insert(entity)
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

//    self.untypedRooms.insert(entity)

    return entity
  }

  func plan(room: GKEntity, point: CGPoint) {
    room.component(ofType: BuildRoomComponent.self)?.clearPlan()
    room.component(ofType: BuildRoomComponent.self)?.planAtPoint(point)
    room.component(ofType: BuildRoomComponent.self)?.needConfirmBounds()
  }

  func clearProposedRoomTypes() {
    let rooms = Game.sharedInstance.roomManager!.allRooms

    for room in rooms {
      self.registerRoomTypeChange(room)
      room.removeComponent(ofType: TouchableSpriteComponent.self)
    }
  }

  func registerRoomTypeChange(_ entity: GKEntity) {
    let newRoomType = entity.component(ofType: RoomSpecComponent.self)?.roomType
    // Remove room from all typed or untyped room, and add to correct new set
    self.untypedRooms.remove(entity)
    for key in self.typedRooms.keys {
      self.typedRooms[key]?.remove(entity)
    }
    if (newRoomType == nil) {
      self.untypedRooms.insert(entity)
    } else {
      if (self.typedRooms[newRoomType!] == nil ){
        self.typedRooms[newRoomType!] = Set()
      }
      self.typedRooms[newRoomType!]?.insert(entity)
    }

    entity.component(ofType: RoomSpecComponent.self)!.updateRoomFloorColour()
  }

}
