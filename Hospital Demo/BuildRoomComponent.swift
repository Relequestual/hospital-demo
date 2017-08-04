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
  var size: CGSize 
  
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
//    self.roomBlueprint.addComponent(PositionComponent(gridPosition: gridPosition))
    guard let tile = Game.sharedInstance.tilesAtCoords[Int(gridPosition.x)]![Int(gridPosition.y)] else {
      // No tile at this position
      return
    }

    let spritePosition = tile.component(ofType: PositionComponent.self)?.spritePosition
    print("mod check")
//    print(self.size.width.truncatingRemainder(dividingBy: 2) == 0)
//    self.roomBlueprint.componentForClass(SpriteComponent.self)?.node.position = CGPoint(x: spritePosition.x + (self.size.width % 2 == 0 ? 32 : 0), y: spritePosition.y + (self.size.height % 2 == 0 ? 32 : 0))
    self.roomBlueprint.component(ofType: PositionComponent.self)?.spritePosition = self.getPointForSize(spritePosition!)

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
  
//  Set the room entity to have the same position and size as the room blueprint
  func confirmBuild() {
    self.clearPlan()
//    Make the room built somehow
    self.entity?.addComponent(self.roomBlueprint.component(ofType: PositionComponent.self)!)
    self.size = self.roomBlueprint.size
//    Any tidy up?
    Game.sharedInstance.buildRoomStateMachine.enter(BRSDone.self)
    Game.sharedInstance.gameStateMachine.enter(GSGeneral.self)
    self.build()
  }
  
  func build () {
    let texture = self.room.createFloorTexture(self.roomBlueprint.size)
    
    let floorNode = SKSpriteNode(texture: texture)
    
    self.room.addComponent(SpriteComponent(texture: SKView().texture(from: floorNode)!))
    Game.sharedInstance.entityManager.add(self.room, layer: ZPositionManager.WorldLayer.world)
    self.setTileWalls()
  }
  
  func cancelBuild() {
    self.clearPlan()
    Game.sharedInstance.gameStateMachine.enter(GSGeneral.self)
  }
  
  func getPointForSize (_ point: CGPoint) -> CGPoint {
    return CGPoint(x: point.x + (self.roomBlueprint.size.width.truncatingRemainder(dividingBy: 2) == 0 ? 32 : 0), y: point.y + (self.roomBlueprint.size.height.truncatingRemainder(dividingBy: 2) == 0 ? 32 : 0))
  }
  
  func setTileWalls () {
    let position = self.room.component(ofType: PositionComponent.self)!.spritePosition!
  
    let bottomLeftX = position.x - (self.roomBlueprint.size.width * 64) / 2
    let bottomLeftY = position.y - (self.roomBlueprint.size.height * 64) / 2
    
    let bottomLeftTilePosition = CGPoint(x: bottomLeftX / 64, y: bottomLeftY / 64)

    
    for x in stride(from: Int(bottomLeftTilePosition.x), to: Int(bottomLeftTilePosition.x + self.roomBlueprint.size.width), by: 1){
      for y in stride(from: Int(bottomLeftTilePosition.y), to: Int(bottomLeftTilePosition.y + self.roomBlueprint.size.height), by: 1) {
        let tile = Game.sharedInstance.tilesAtCoords[Int(x)]![Int(y)]
        if (x == Int(bottomLeftTilePosition.x)) {
          tile?.addWall(ofBaring: Game.rotation.west)
        }
        if (y == Int(bottomLeftTilePosition.y)) {
          tile?.addWall(ofBaring: Game.rotation.south)
        }
        if (x == Int(bottomLeftTilePosition.x + self.roomBlueprint.size.width - 1 )) {
          tile?.addWall(ofBaring: Game.rotation.east)
        }
        if (y == Int(bottomLeftTilePosition.y + self.roomBlueprint.size.height - 1)) {
          tile?.addWall(ofBaring: Game.rotation.north)
        }
      }
    }
    
  }
  
  
  
  
  
  
  
}
