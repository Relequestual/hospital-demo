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

class BISPlan: GKState {
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass == BISPlace.self
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
