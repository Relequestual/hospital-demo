//
//  BuildState.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 07/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

class BuildItemState : GKState {
  func currentBuild() -> GKEntity? {
    return nil
  }

}

class BISPlan: BuildItemState {
  override func isValidNextState(stateClass: AnyClass) -> Bool {
    return stateClass == BISPlace.self
  }
}

class BISPlace: BuildItemState {
  override func didEnterWithPreviousState(previousState: GKState?) {
    print(previousState)
    print("In Place Item State")
  }
}

class BISPlaned: BuildItemState {
  override func didEnterWithPreviousState(previousState: GKState?) {
    print(previousState)
    print("In Planned Item State")
  }
}

