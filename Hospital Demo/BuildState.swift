//
//  BuildState.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 07/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

class BuildState : GKState {
  func currentBuild() -> GKEntity? {
    return nil
  }

}

class BSInitial: BuildState {
  override func isValidNextState(stateClass: AnyClass) -> Bool {
    let allowed_states: [AnyClass] = [ BSPlaceItem.self ]
    return allowed_states.contains({ $0 == stateClass})
  }
}

class BSNoBuild: BuildState {
  override func didEnterWithPreviousState(previousState: GKState?) {
    print("entering BSNoBuild")
    Game.shouldShowPlaceObjectToolbar(false)
  }
}

class BSPlaceItem: BuildState {
  override func didEnterWithPreviousState(previousState: GKState?) {
    print(previousState)
    print("In Place Item State")
    Game.shouldShowPlaceObjectToolbar(true)
//    Game.sharedInstance.canAutoScroll = true
  }
}

class BSPlanedItem: BuildState {
  override func didEnterWithPreviousState(previousState: GKState?) {
    print(previousState)
    print("In Planned Item State")
    Game.shouldShowPlaceObjectToolbar(true)

  }
}

class BSSelectSquares: BuildState {

}
