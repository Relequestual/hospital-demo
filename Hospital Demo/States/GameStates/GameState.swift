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

  override func didEnter(from previousState: GKState?) {
    print(previousState!)
    print("In game state build state")
    Game.sharedInstance.canAutoScroll = true
  }
  
  override func willExit(to nextState: GKState) {
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

class GSGeneral: GKState {
  
  override func didEnter(from previousState: GKState?) {
    Game.sharedInstance.toolbarManager?.resetSide(Game.rotation.south)
    Game.sharedInstance.buildRoomStateMachine.resetState()
    Game.sharedInstance.buildItemStateMachine.resetState()

  }

}

class GSLevelEdit: GKState {

}

