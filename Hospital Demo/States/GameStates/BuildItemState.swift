//
//  BuildState.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 07/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

class BuildItemState: GKStateMachine {
  var itemType: GKEntity.Type?
  var itemBuilding: GKEntity?

  init() {
    super.init(states: [
      BISPlan(),
      BISPlace(),
    ])
  }

  func resetState() {
    itemType = nil
    itemBuilding = nil
  }
}

class BISPlan: GKState, StateTouchTileDelegate {

  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass == BISPlace.self
  }

  override func didEnter(from previousState: GKState?) {
    Game.sharedInstance.touchTileDelegate = self
  }

  override func willExit(to nextState: GKState) {
    Game.sharedInstance.touchTileDelegate = nil
  }

  static func dragStartHandler(_: GKEntity, _: CGPoint) {
    print("RD Start drag")
  }

  static var tileTracker: GKEntity?

  static func dragMoveHandler(_ entity: GKEntity, _ point: CGPoint) {
    print("RD Move drag")

    if entity.component(ofType: ItemBlueprintComponent.self)?.status == ItemBlueprintComponent.Status.built {
      print("No dragging built items")
      return
    }

    //    self.componentForClass(SpriteComponent.self)?.node.position = point
    let nodesAtPoint = Game.sharedInstance.wolrdnode.nodes(at: point)

    for node in nodesAtPoint {
      guard let tileEntity: GKEntity = node.userData?["entity"] as? GKEntity else { continue }

      if tileEntity.isKind(of: Tile.self) {
        if (self.tileTracker == tileEntity) {
          return
        }
        self.tileTracker = tileEntity
        entity.component(ofType: ItemBlueprintComponent.self)?.planFunctionCall((tileEntity.component(ofType: PositionComponent.self)?.gridPosition)!)
      }
    }
  }

  static func dragEndHandler(_ entity: GKEntity, _: CGPoint) {
    if entity.component(ofType: ItemBlueprintComponent.self)?.status != ItemBlueprintComponent.Status.built {
      entity.component(ofType: ItemBlueprintComponent.self)?.displayBuildObjectConfirm()
    }
    print("RD End drag")
  }



  func touchTile(tile: Tile) {
    print("override touch tile func called, yay!")
    guard let placingObject = Game.sharedInstance.placingObjectsQueue.first else {
      return
    }
    Game.sharedInstance.placingObjectsQueue.removeFirst()

    let plannedObject = Game.sharedInstance.itemManager!.createEntity(itemType: placingObject)
    Game.sharedInstance.draggingEntiy = plannedObject
    plannedObject.component(ofType: ItemBlueprintComponent.self)?.planFunctionCall((tile.component(ofType: PositionComponent.self)?.gridPosition)!)
    plannedObject.component(ofType: ItemBlueprintComponent.self)?.displayBuildObjectConfirm()
  }
}

class BISPlace: GKState {
  override func didEnter(from previousState: GKState?) {
    print(previousState as Any)
    print("In Place Item State")
  }
}




// class BISPlaned: BuildItemState {
//  override func didEnterWithPreviousState(previousState: GKState?) {
//    print(previousState)
//    print("In Planned Item State")
//  }
// }
