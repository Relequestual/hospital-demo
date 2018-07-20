//
//  GameState.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 05/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

class GameState: GKStateMachine {
  init() {
    super.init(states: [
      GSGeneral(),
      GSBuildItem(),
      GSBuildRoom(),
      GSBuildDoor(),
      GSLevelEdit(),
    ])
  }
}

class GSBuildItem: GKState {
  override func didEnter(from previousState: GKState?) {
    print(previousState ?? "no previous state")
    print("In game state build state")
    Game.sharedInstance.canAutoScroll = true
  }

  override func willExit(to _: GKState) {
    Game.sharedInstance.draggingEntiy = nil
    Game.sharedInstance.buildItemStateMachine.resetState()
    Game.sharedInstance.canAutoScroll = false
  }
}

class GSBuildRoom: GKState {
  override func didEnter(from previousState: GKState?) {
    print(previousState ?? "No previous state")
    Game.sharedInstance.canAutoScroll = true
  }

  override func willExit(to _: GKState) {
    Game.sharedInstance.draggingEntiy = nil
    Game.sharedInstance.buildRoomStateMachine.resetState()
    Game.sharedInstance.canAutoScroll = false
  }
}

class GSBuildDoor: GKState {
  var doors: Set<Door> = []

  override func didEnter(from _: GKState?) {
    let rooms = Game.sharedInstance.entityManager.entities.filter { $0.isKind(of: Room.self) }

    for room in rooms {
      let newDoors = room.component(ofType: BuildRoomComponent.self)?.showPossibleDoorLocation()
      for door in newDoors! {
        doors.insert(door)
      }
    }

//    Confirm toolbar needs to be here
//    Should return a set of rooms from func call, and collect them here, so can be removed easily.

    let confirmToolbar = ConfirmToolbar()

    //    set callbacks for confirm toolbar
    confirmToolbar.cancel = {
      for door in self.doors.filter({ (door: Door) -> Bool in
        door.planStatus != nil
      }) {
        Game.sharedInstance.entityManager.remove(door)
      }
      Game.sharedInstance.gameStateMachine.enter(GSGeneral.self)
    }
    confirmToolbar.confirm = {
      for door in self.doors.filter({ (door) -> Bool in
        door.planStatus == Door.plan.planned
      }) {
        door.completeDoor()
        Game.sharedInstance.gameStateMachine.enter(GSGeneral.self)
      }
//      Game.sharedInstance.gameStateMachine.enter(GSGeneral.self)
    }

    Game.sharedInstance.toolbarManager?.add(toolbar: confirmToolbar, location: .south, shown: true)
  }

  override func willExit(to _: GKState) {
    for door in doors.filter({ (door: Door) -> Bool in
      door.planStatus != nil
    }) {
      Game.sharedInstance.entityManager.remove(door)
    }
  }
}

class GSGeneral: GKState {
  override func didEnter(from _: GKState?) {
    Game.sharedInstance.toolbarManager?.resetSide(Game.rotation.south)
  }
}

class GSLevelEdit: GKState {
}
