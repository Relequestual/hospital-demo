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
      GSLevelEdit(),
    ])
  }

}



class GSBuildItem: GKState {

  override func didEnterWithPreviousState(previousState: GKState?) {
    print(previousState)
    print("In game state build state")
    Game.sharedInstance.canAutoScroll = true
  }
  
  override func willExitWithNextState(nextState: GKState) {
    Game.sharedInstance.canAutoScroll = false
  }

}

class GSBuildRoom: GKState {
  
  override func didEnterWithPreviousState(previousState: GKState?) {
    print(previousState)
    Game.sharedInstance.canAutoScroll = true
  }
  
  
  override func willExitWithNextState(nextState: GKState) {
    Game.sharedInstance.canAutoScroll = false
  }
  
}

class GSGeneral: GKState {

}

class GSLevelEdit: GKState {

}

