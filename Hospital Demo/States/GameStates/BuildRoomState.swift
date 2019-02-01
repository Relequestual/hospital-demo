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


class BRSPrePlan: GKState, StateTouchTileDelegate {

  override func didEnter(from previousState: GKState?) {
    Game.sharedInstance.touchTileDelegate = self
  }

  override func willExit(to nextState: GKState) {
    Game.sharedInstance.touchTileDelegate = nil
  }

  func touchTile(tile: Tile) {

    let plannedRoom = Game.sharedInstance.roomManager!.createEntity()
    let tileTouchGridPoint = tile.component(ofType: PositionComponent.self)?.gridPosition

    print("planned room is")
    print(plannedRoom)

    Game.sharedInstance.roomManager?.plan(room: plannedRoom, point: tileTouchGridPoint!)

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
