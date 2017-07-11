//
//  BuildRoomState.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 21/08/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

class BuildRoomState : GKStateMachine {
  
  var roomBuilding: GKEntity?

  init() {
    super.init(states:[
      BRSPrePlan(),
      BRSPlan(),
      BRSDoor(),
      BRSItems(),
      BRSDone(),
      ])
  }
  
  func resetState() {
    roomBuilding = nil
  }

}

class BRSPrePlan: GKState {}

class BRSPlan: GKState {}

class BRSDoor: GKState {}

class BRSItems: GKState {}

class BRSDone: GKState {}



//class BISPlaned: BuildItemState {
//  override func didEnterWithPreviousState(previousState: GKState?) {
//    print(previousState)
//    print("In Planned Item State")
//  }
//}

