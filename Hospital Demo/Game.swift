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

  var stateMachine: GKStateMachine

  var entityManager: EntityManager!

  private init() {

    stateMachine = GKStateMachine(states: [
      GSBuild(),
      GSGeneral(),
      GSLevelEdit()
    ])

    stateMachine.enterState(GSGeneral)

  }

}
