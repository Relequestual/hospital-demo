//
//  BuildRoomState.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 21/08/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

class BuildRoomState: GKStateMachine {
  var roomBuilding: GKEntity?

  init() {
    super.init(states: [
      BRSPrePlan(),
      BRSPlan(),
      BRSDone(),
    ])
  }

  func resetState() {
    roomBuilding = nil
  }
}


class BRSPrePlan: RQTileTouchState {

  override func touchTile(tile: Tile) {
      let plannedRoom = Room()
      print("planned room is")
      print(plannedRoom)
      plannedRoom.component(ofType: BuildRoomComponent.self)?.clearPlan()
      plannedRoom.component(ofType: BuildRoomComponent.self)?.planAtPoint((tile.component(ofType: PositionComponent.self)?.gridPosition)!)
      plannedRoom.component(ofType: BuildRoomComponent.self)?.needConfirmBounds()
      Game.sharedInstance.buildRoomStateMachine.enter(BRSPlan.self)
      Game.sharedInstance.buildRoomStateMachine.roomBuilding = plannedRoom
  }
}

class BRSPlan: GKState {}

class BRSDone: GKState {}

// class BISPlaned: BuildItemState {
//  override func didEnterWithPreviousState(previousState: GKState?) {
//    print(previousState)
//    print("In Planned Item State")
//  }
// }
