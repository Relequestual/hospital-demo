//
//  GameState.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 05/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

class GameState : GKState{
  

}



class GSBuild: GameState {

  override func didEnterWithPreviousState(previousState: GKState?) {
    print(previousState)
    print("In game state build state")
  }

}

class GSGeneral: GameState {

}

class GSLevelEdit: GameState {

}

