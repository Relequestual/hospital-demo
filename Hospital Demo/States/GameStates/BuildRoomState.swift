//
//  BuildRoomState.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 21/08/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

class BuildRoomState : GKState {
  func currentBuild() -> GKEntity? {
    return nil
  }

}

class BRSPrePlan: BuildRoomState {}

class BRSPlan: BuildRoomState {}

class BRSDoor: BuildRoomState {}

class BRSItems: BuildRoomState {}



//class BISPlaned: BuildItemState {
//  override func didEnterWithPreviousState(previousState: GKState?) {
//    print(previousState)
//    print("In Planned Item State")
//  }
//}

