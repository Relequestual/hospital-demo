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
  
  func planAtPoint(_ gridPosition: CGPoint) {
    self.roomBlueprint.addComponent(PositionComponent(gridPosition: gridPosition))
    guard let tile = Game.sharedInstance.tilesAtCoords[Int(gridPosition.x)]![Int(gridPosition.y)] else {
      // No tile at this position
      return
    }
    let spritePosition = (tile.component(ofType: PositionComponent.self)?.spritePosition)!
    print("mod check")
    print(self.size.width.truncatingRemainder(dividingBy: 2) == 0)
//    self.roomBlueprint.componentForClass(SpriteComponent.self)?.node.position = CGPoint(x: spritePosition.x + (self.size.width % 2 == 0 ? 32 : 0), y: spritePosition.y + (self.size.height % 2 == 0 ? 32 : 0))
      self.roomBlueprint.component(ofType: SpriteComponent.self)?.node.position = self.getPointForSize(spritePosition)

//    let sprite = self.roomBlueprint.componentForClass(SpriteComponent.self)
    
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
      Game.sharedInstance.buildRoomStateMachine.roomBuilding?.component(ofType: BuildRoomComponent.self)?.roomBlueprint.removeResizeHandles()
      //make plan non moveable
      Game.sharedInstance.buildRoomStateMachine.roomBuilding?.component(ofType: BuildRoomComponent.self)?.roomBlueprint.component(ofType: DraggableSpriteComponent.self)?.draggable = false
      
      //    Set state to BRSDoor
      Game.sharedInstance.buildRoomStateMachine.enter(BRSDoor)
      //    create function to allow for placement of door
      self.roomBlueprint.allowToPlaceDoor()
      
    }
//    replace current toolbar with confirm toolbar.
    Game.sharedInstance.toolbarManager?.addToolbar(confirmToolbar, location: Game.rotation.south, shown: true)
    

  }

  
  func clearPlan() {
    Game.sharedInstance.entityManager.node.enumerateChildNodes(withName: "planning_room_blueprint", using: { (node, stop) -> Void in
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
    Game.sharedInstance.gameStateMachine.enter(GSGeneral)
    
  }
  
  func getPointForSize (_ point: CGPoint) -> CGPoint {
    return CGPoint(x: point.x + (self.size.width.truncatingRemainder(dividingBy: 2) == 0 ? 32 : 0), y: point.y + (self.size.height.truncatingRemainder(dividingBy: 2) == 0 ? 32 : 0))
  }
  
}
