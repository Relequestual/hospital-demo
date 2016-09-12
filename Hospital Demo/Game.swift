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
import HLSpriteKit

class Game {
  static let sharedInstance = Game()

  var gameStateMachine = GKStateMachine(states: [
    GSBuild(),
    GSBuildRoom(),
    GSGeneral(),
    GSLevelEdit()
  ])

  var buildStateMachine = GKStateMachine(states: [
    BISPlan(),
    BISPlace(),
    BRSPlan(),
    BRSDoor()
  ])
  
  var buildRoomStateMachine =  GKStateMachine(states: [
    BRSPrePlan(),
    BRSPlan(),
    BRSDoor()
  ])
  
  var panningWold = true

  var canAutoScroll = false

  var autoScrollVelocityX = CGFloat(0.0);

  var autoScrollVelocityY = CGFloat(0.0);

  var entityManager: EntityManager!
  
  var wolrdnode: HLScrollNode!
  
  var tilesAtCoords = [Int: [Int: Tile]]()
  
  var placingObjectsQueue = Array<GKEntity.Type>()

  var plannedBuildingObject: GKEntity?
  
  var plannedRoom: GKEntity.Type?
  
  var plannedBuildingTiles = [Tile]()
  
  var draggingEntiy: GKEntity?

  var tappableEntity: GKEntity?

  var touchDidMove = false
  
  enum rotation: Int {
    case North = 1, East = 2, South = 3, West = 4
    mutating func next() {
      switch self {
      case North:
        self = East
      case East:
        self = South
      case South:
        self = West
      case West:
        self = North
      }
    }
  }

  private init() {
//    self.gameStateMachine.enterState(GSGeneral)
//    self.buildStateMachine.enterState(BSInitial)

    let zPositionManager = ZPositionManager()
    print(zPositionManager.topMost)
  }

}
