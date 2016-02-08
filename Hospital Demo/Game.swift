//
//  Game.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 04/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//
//  http://krakendev.io/blog/the-right-way-to-write-a-singleton

import Foundation
import GameplayKit

class Game {
  static let sharedInstance = Game()

  var gameStateMachine = GKStateMachine(states: [
    GSBuild(),
    GSGeneral(),
    GSLevelEdit()
  ])

  var buildStateMachine = GKStateMachine(states: [
    BSNoBuild(),
    BSPlaceItem(),
    BSSelectSqaures()
  ])

  var entityManager: EntityManager!

  private init() {

    self.gameStateMachine.enterState(GSGeneral)
    
    self.buildStateMachine.enterState(BSNoBuild)

  }

}
