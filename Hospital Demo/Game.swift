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
  static let sharedInstance = Game(view: nil)

  var gameStateMachine = GameState()

  var buildItemStateMachine = BuildItemState()

  var buildRoomStateMachine = BuildRoomState()

  var panningWold = true

  var canAutoScroll = false

  var autoScrollVelocityX = CGFloat(0.0)

  var autoScrollVelocityY = CGFloat(0.0)

  var entityManager: EntityManager!

  var wolrdnode: SKSpriteNode!

  var toolbarManager: ToolbarManager?

  var menuManager: MenuManager?

  var itemManager: ItemManager?

  var tilesAtCoords: [Int: [Int: Tile]] = [:]

  var placingObjectsQueue = Array<GKEntity.Type>()

  var draggingEntiy: GKEntity?

  var tappableEntity: GKEntity?

  var touchDidMove = false

  var touchTile: ((_ tile:Tile) -> Void)?

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

    mainView = view

    let zPositionManager = ZPositionManager()
    print(zPositionManager.topMost)
  }

  func initDebugNode(name: String?) {
    let pointSprite = SKShapeNode(circleOfRadius: 2)
    pointSprite.strokeColor = UIColor.red
    //    (currentTile as! Tile).highlight((currentTile!.componentForClass(SpriteComponent.self)?.node.position)!)
    pointSprite.zPosition = 100_000
    pointSprite.removeFromParent()
    pointSprite.name = name != nil ? name : ""
    Game.sharedInstance.entityManager.node.addChild(pointSprite)
  }

  func updateDebugNode(name: String, position: CGPoint) {
    Game.sharedInstance.entityManager.node.enumerateChildNodes(withName: name) { node, _ in
      node.position = position
    }
  }

  func removeDebugNode(name: String) {
    Game.sharedInstance.entityManager.node.enumerateChildNodes(withName: name) { node, _ in
      node.removeFromParent()
    }
  }
}
