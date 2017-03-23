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
  var roomBlueprint: RoomBlueprint
//  Relocate this at some point
  enum doorTypes { case single, double }
  
  var requiredDoor: doorTypes = doorTypes.single

  init(minSize: CGSize) {
    self.minSize = minSize
    self.size = minSize
    self.roomBlueprint = RoomBlueprint(size: minSize)
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func planAtPoint(gridPosition: CGPoint) {
    self.roomBlueprint.addComponent(PositionComponent(gridPosition: gridPosition))
    guard let tile = Game.sharedInstance.tilesAtCoords[Int(gridPosition.x)]![Int(gridPosition.y)] else {
      // No tile at this position
      return
    }
    let spritePosition = (tile.componentForClass(PositionComponent)?.spritePosition)!
    print("mod check")
    print(self.size.width % 2 == 0)
//    self.roomBlueprint.componentForClass(SpriteComponent)?.node.position = CGPoint(x: spritePosition.x + (self.size.width % 2 == 0 ? 32 : 0), y: spritePosition.y + (self.size.height % 2 == 0 ? 32 : 0))
      self.roomBlueprint.componentForClass(SpriteComponent)?.node.position = self.getPointForSize(spritePosition)

//    let sprite = self.roomBlueprint.componentForClass(SpriteComponent)
    
    Game.sharedInstance.entityManager.add(self.roomBlueprint, layer: ZPositionManager.WorldLayer.world)
    self.roomBlueprint.createResizeHandles()
  }
  
//  Called after initial placemet. Show confirmation toolbar
  func needConfirmBounds() {
//    create confirmation toolbar
    let confirmToolbar = ConfirmToolbar(size: CGSize(width: Game.sharedInstance.mainView!.bounds.width , height: 64))
//    set callbacks for confirm toolbar
    confirmToolbar.cancel = {
      print("Cancel room")
      self.cancelBuild()
    }
    confirmToolbar.confirm = {
      print("OK TO BUILD ROOM");
      //remove handles from plan
      Game.sharedInstance.buildRoomStateMachine.roomBuilding?.componentForClass(BuildRoomComponent)?.roomBlueprint.removeResizeHandles()
      //make plan non moveable
      Game.sharedInstance.buildRoomStateMachine.roomBuilding?.componentForClass(BuildRoomComponent)?.roomBlueprint.componentForClass(DraggableSpriteComponent)?.draggable = false
      
      //    Set state to BRSDoor
      Game.sharedInstance.buildRoomStateMachine.enterState(BRSDoor)
      //    create function to allow for placement of door
      self.roomBlueprint.allowToPlaceDoor()
      
    }
//    replace current toolbar with confirm toolbar.
    Game.sharedInstance.toolbarManager?.addToolbar(confirmToolbar, location: Game.rotation.South, shown: true)
    

  }

  
  func clearPlan() {
    Game.sharedInstance.entityManager.node.enumerateChildNodesWithName("planning_room_blueprint", usingBlock: { (node, stop) -> Void in
      if let entity = node.userData?["entity"]as? GKEntity {
        Game.sharedInstance.entityManager.remove(entity)
      } else {
        print("node has no entity and is being removed!")
        node.removeFromParent()
      }
    });
    Game.sharedInstance.draggingEntiy = nil
    
  }
  
  func cancelBuild() {
    self.clearPlan()
//    re set game and build states.
    Game.sharedInstance.gameStateMachine.enterState(GSGeneral)
    
  }
  
  func getPointForSize (point: CGPoint) -> CGPoint {
    return CGPoint(x: point.x + (self.size.width % 2 == 0 ? 32 : 0), y: point.y + (self.size.height % 2 == 0 ? 32 : 0))
  }
  
}
