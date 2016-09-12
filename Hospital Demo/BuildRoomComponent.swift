//
//  BuildRoomComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 07/08/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class BuildRoomComponent: GKComponent {

  var minSize: CGSize
  var size: CGSize = CGSize(width: 1, height: 1)
  var roomBlueprint: GKEntity
  
  init(minSize: CGSize) {
    self.minSize = minSize
    self.roomBlueprint = RoomBlueprint(size: minSize)
  }
  
  func planAtPoint(gridPosition: CGPoint) {
    self.roomBlueprint.addComponent(PositionComponent(gridPosition: gridPosition))
    guard let tile = Game.sharedInstance.tilesAtCoords[Int(gridPosition.x)]![Int(gridPosition.y)] else {
      // No tile at this position
      return
    }
    let spritePosition = (tile.componentForClass(PositionComponent)?.spritePosition)!
    self.roomBlueprint.componentForClass(SpriteComponent)?.node.position = CGPoint(x: spritePosition.x + 32, y: spritePosition.y + 32)
//    let sprite = self.roomBlueprint.componentForClass(SpriteComponent)
    
    Game.sharedInstance.entityManager.add(self.roomBlueprint, layer: ZPositionManager.WorldLayer.world)
  }
  
  func clearPlan() {
    Game.sharedInstance.entityManager.node.enumerateChildNodesWithName("planning_room_blueprint", usingBlock: { (node, stop) -> Void in
      if let entity = node.userData?["entity"]as? GKEntity {
        Game.sharedInstance.entityManager.remove(entity)
      } else {
        node.removeFromParent()
      }
    });
    Game.sharedInstance.draggingEntiy = nil
//    Game.sharedInstance.placingObjectsQueue.removeFirst()
    //    Game.sharedInstance.buildStateMachine.enterState(BSNoBuild)
    
  }
}