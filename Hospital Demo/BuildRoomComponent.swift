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

  let minSize: CGSize
  var size: CGSize = CGSize(width: 1, height: 1)
  
  var room: Room!
  
  var roomBlueprint: RoomBlueprint!
  
  
//  Relocate this at some point
  enum doorTypes { case single, double }
  
  var requiredDoor: doorTypes = doorTypes.single

  init(minSize: CGSize, room: Room) {
    self.minSize = minSize
    self.size = minSize
    self.room = room
    super.init()
    self.roomBlueprint = RoomBlueprint(size: self.minSize, room: room)
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
//    let spritePosition = (tile.component(ofType: PositionComponent.self)?.spritePosition)!
    let spritePosition = (tile.component(ofType: SpriteComponent.self)?.node.position)!
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
    print("confirm bounds?")
//    create confirmation toolbar
    let confirmToolbar = ConfirmToolbar(size: CGSize(width: Game.sharedInstance.mainView!.bounds.width , height: 64))
//    set callbacks for confirm toolbar
    confirmToolbar.cancel = {
      print("Cancel room")
      self.cancelBuild()
    }
    confirmToolbar.confirm = {
      print("OK TO BUILD ROOM");
      self.confirmBuild()
      
            //    create function to allow for placement of door
//      NOPE, now we will allow a room without doors, and doors are addable later
//      self.roomBlueprint.allowToPlaceDoor()
      
    }
    
    Game.sharedInstance.toolbarManager?.addToolbar(confirmToolbar, location: Game.rotation.south, shown: true)

  }

  
  func clearPlan() {
    
    Game.sharedInstance.entityManager.remove(self.roomBlueprint)
//    Game.sharedInstance.gameStateMachine.enter(GSGeneral.self)
    
//    Game.sharedInstance.entityManager.node.enumerateChildNodes(withName: "planning_room_blueprint", using: { (node, stop) -> Void in
//      if let entity = node.userData?["entity"]as? GKEntity {
//        Game.sharedInstance.entityManager.remove(entity)
//      } else {
//        print("node has no entity and is being removed!")
//        node.removeFromParent()
//      }
//    });
//    Game.sharedInstance.draggingEntiy = nil
    
  }
  
  func confirmBuild() {
    //remove handles from plan
//    self.roomBlueprint.removeResizeHandles()
    //make plan non moveable
//    self.roomBlueprint.component(ofType: DraggableSpriteComponent.self)?.draggable = false
    
    self.entity?.addComponent(PositionComponent(gridPosition: CGPoint(), spritePosition: self.roomBlueprint.component(ofType: SpriteComponent.self)?.node.position))
    
    Game.sharedInstance.entityManager.remove(self.roomBlueprint)
    
//    Make the room built somehow
    self.entity?.addComponent(self.roomBlueprint.component(ofType: PositionComponent.self)!)
    
//    Any tidy up?
    Game.sharedInstance.buildRoomStateMachine.enter(BRSDone.self)
    Game.sharedInstance.gameStateMachine.enter(GSGeneral.self)
    self.size = self.roomBlueprint.size
    self.build()
  }
  
  func cancelBuild() {
    self.clearPlan()
    Game.sharedInstance.gameStateMachine.enter(GSGeneral.self)
  }
  
  func build () {
    let texture = self.room.createFloorTexture(self.roomBlueprint.size)
    
    let floorNode = SKSpriteNode(texture: texture)
    
    self.room.addComponent(self.roomBlueprint.component(ofType: PositionComponent.self)!)
    
    self.room.addComponent(SpriteComponent(texture: SKView().texture(from: floorNode)!))
    Game.sharedInstance.entityManager.add(self.room, layer: ZPositionManager.WorldLayer.ground)
  }
  
  func getPointForSize (_ point: CGPoint) -> CGPoint {
    return CGPoint(x: point.x + (self.size.width.truncatingRemainder(dividingBy: 2) == 0 ? 32 : 0), y: point.y + (self.size.height.truncatingRemainder(dividingBy: 2) == 0 ? 32 : 0))
  }
  
}
