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
  static let sharedInstance = Game(view: nil)

  var gameStateMachine = GameState()

  var buildItemStateMachine = BuildItemState()
  
  var buildRoomStateMachine = BuildRoomState()
  
  var panningWold = true

  var canAutoScroll = false

  var autoScrollVelocityX = CGFloat(0.0);

  var autoScrollVelocityY = CGFloat(0.0);

  var entityManager: EntityManager!
  
  var wolrdnode: HLScrollNode!
  
  var toolbarManager: ToolbarManager?
  
  var tilesAtCoords = [Int: [Int: Tile]]()
  
  var placingObjectsQueue = Array<GKEntity.Type>()
  
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
  
  enum axis {
    case Vert, Hroiz
  }
  
  enum numericalSignage {
    case positive, negative
  }
  
  var mainView: SKView?

  private init(view: SKView?) {
//    self.gameStateMachine.enterState(GSGeneral)
//    self.buildStateMachine.enterState(BSInitial)
    
    self.mainView = view

    let zPositionManager = ZPositionManager()
    print(zPositionManager.topMost)
  }

}
