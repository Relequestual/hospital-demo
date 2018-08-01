//
//  BuildState.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 07/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

class BuildItemState: GKStateMachine {
  var itemType: GKEntity.Type?
  var itemBuilding: GKEntity?

  init() {
    super.init(states: [
      BISPlan(),
      BISPlace(),
    ])
  }

  func resetState() {
    itemType = nil
    itemBuilding = nil
  }
}

class BISPlan: RQTileTouchState {
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass == BISPlace.self
  }

  override func touchTile(tile: Tile) {
    print("override touch tile func called, yay!")
      guard let placingObject: GKEntity.Type = Game.sharedInstance.placingObjectsQueue.first else {
        return
      }

      let plannedObject = placingObject.init()
      Game.sharedInstance.draggingEntiy = plannedObject
      plannedObject.component(ofType: ItemBlueprintComponent.self)?.planFunctionCall((tile.component(ofType: PositionComponent.self)?.gridPosition)!)
      plannedObject.component(ofType: ItemBlueprintComponent.self)?.displayBuildObjectConfirm()

    //      Game.sharedInstance.buildStateMachine.enterState(BISPlaned)

  }
}

class BISPlace: GKState {
  override func didEnter(from previousState: GKState?) {
    print(previousState as Any)
    print("In Place Item State")
  }
}




// class BISPlaned: BuildItemState {
//  override func didEnterWithPreviousState(previousState: GKState?) {
//    print(previousState)
//    print("In Planned Item State")
//  }
// }
