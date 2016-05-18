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
    GSGeneral(),
    GSLevelEdit()
  ])

  var buildStateMachine = GKStateMachine(states: [
    BSNoBuild(),
    BSPlaceItem(),
    BSPlanedItem(),
    BSSelectSqaures()
  ])
  
  var canPanWorld = true

  var canAutoScroll = false

  var autoScrollVelocityX = CGFloat(0.0);

  var autoScrollVelocityY = CGFloat(0.0);

  var entityManager: EntityManager!
  
  var wolrdnode: HLScrollNode!
  
  var tilesAtCoords = [Int: [Int: Tile]]()
  
  var placingObjectsQueue = Array<GKEntity.Type>()

  var plannedBuildingObject: GKEntity?
  
  var plannedBuildingTiles = [Tile]()
  
  var draggingEntiy: GKEntity?
  
  enum rotation {
    case North, East, South, West
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

    self.gameStateMachine.enterState(GSGeneral)
    
    self.buildStateMachine.enterState(BSNoBuild)
    

  }

}
