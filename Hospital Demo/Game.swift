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
  
  var tilesAtCoords: [Int: [Int: Tile]] = [:]
  
  var placingObjectsQueue = Array<GKEntity.Type>()
  
  var plannedBuildingTiles = [Tile]()
  
  var draggingEntiy: GKEntity?

  var tappableEntity: GKEntity?

  var touchDidMove = false
  
  enum rotation: Int {
    case north = 1, east = 2, south = 3, west = 4
    mutating func next() {
      switch self {
      case .north:
        self = .east
      case .east:
        self = .south
      case .south:
        self = .west
      case .west:
        self = .north
      }
    }
  }
  
  enum axis {
    case vert, hroiz
  }
  
  enum numericalSignage {
    case positive, negative
  }
  
  var mainView: SKView?

  fileprivate init(view: SKView?) {
//    self.gameStateMachine.enterState(GSGeneral)
//    self.buildStateMachine.enterState(BSInitial)
    
    self.mainView = view

    let zPositionManager = ZPositionManager()
    print(zPositionManager.topMost)
  }

}
