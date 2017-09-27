//
//  GameState.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 05/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit



class GameState : GKStateMachine{

  init() {
    super.init(states:[
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
  
  override func willExit(to nextState: GKState) {
    Game.sharedInstance.buildItemStateMachine.resetState()
    Game.sharedInstance.canAutoScroll = false
  }

}

class GSBuildRoom: GKState {
  
  override func didEnter(from previousState: GKState?) {
    print(previousState ?? "No previous state")
    Game.sharedInstance.canAutoScroll = true
  }
  
  override func willExit(to nextState: GKState) {
    Game.sharedInstance.draggingEntiy = nil
    Game.sharedInstance.buildRoomStateMachine.resetState()
    Game.sharedInstance.canAutoScroll = false
  }
  
}

class GSBuildDoor: GKState {
  
  var doors: Set<Door> = []
  
  override func didEnter(from previousState: GKState?) {
    let rooms = Game.sharedInstance.entityManager.entities.filter { $0.isKind(of: Room.self) }
    
    for room in rooms {
      let newDoors = room.component(ofType: BuildRoomComponent.self)?.showPossibleDoorLocation()
      for door in newDoors! {
        self.doors.insert(door)
      }
    }
    
//    Confirm toolbar needs to be here
//    Should return a set of rooms from func call, and collect them here, so can be removed easily.
    
    let confirmToolbar = ConfirmToolbar(size: CGSize(width: Game.sharedInstance.mainView!.bounds.width , height: 64))
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
    
    Game.sharedInstance.toolbarManager?.addToolbar(confirmToolbar, location: Game.rotation.south, shown: true)
    
    
  }
  
  override func willExit(to nextState: GKState) {
    for door in self.doors.filter({ (door: Door) -> Bool in
      door.planStatus != nil
    }) {
      Game.sharedInstance.entityManager.remove(door)
    }
  }
}

class GSGeneral: GKState {
  
  override func didEnter(from previousState: GKState?) {
    Game.sharedInstance.toolbarManager?.resetSide(Game.rotation.south)
  }

}

class GSLevelEdit: GKState {

}

