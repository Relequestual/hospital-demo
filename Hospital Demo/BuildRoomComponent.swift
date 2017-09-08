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
  
//  Relocate this at some point
  enum doorTypes { case single, double }
  
  var requiredDoor: doorTypes = doorTypes.single

  init(minSize: CGSize) {
    self.minSize = minSize
    self.size = minSize
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func didAddToEntity() {
    guard let entity = self.entity else {return}
    entity.addComponent(RoomBlueprintComponent(size: self.minSize))
  }
  
  func planAtPoint(_ gridPosition: CGPoint, _ animated: Bool = false) {
    guard let entity = self.entity else {return}
    // Check for tile at position
    guard let tile = Game.sharedInstance.tilesAtCoords[Int(gridPosition.x)]![Int(gridPosition.y)] else {return}
    
    guard self.canPlanAtPoint(gridPosition) else {return}
    
    let tileSpritePosition = tile.component(ofType: PositionComponent.self)!.spritePosition
    self.size = entity.component(ofType: RoomBlueprintComponent.self)!.size
    
    
    let newSpritePosition = CGPoint(x: (tileSpritePosition?.x)! - 32 + self.size.width * 32, y: (tileSpritePosition?.y)! - 32 + self.size.height * 32)
    
    entity.addComponent(PositionComponent(gridPosition: gridPosition, spritePosition: newSpritePosition))
    
    let blockedTiles = self.getBlockedTiles(inRect: self.size, atPoint: gridPosition)
    let newSprite = entity.component(ofType: RoomBlueprintComponent.self)?.createFloorplanTexture(roomSize: self.size, blockedTiles: blockedTiles)
    entity.component(ofType: SpriteComponent.self)!.node.size = (newSprite?.size())!
    entity.component(ofType: SpriteComponent.self)!.node.texture =  newSprite
    
    if (animated) {
      
      //      Later, make genertic north south east west actions... maybe
      let moveAction = SKAction.move(to: newSpritePosition, duration: TimeInterval(0.1))
      moveAction.timingMode = SKActionTimingMode.easeInEaseOut
      
      
      entity.component(ofType: SpriteComponent.self)!.node.run(moveAction)
      
    } else {

      Game.sharedInstance.entityManager.remove(entity)

      Game.sharedInstance.entityManager.add(entity, layer: ZPositionManager.WorldLayer.planning)
      
      self.entity?.component(ofType: RoomBlueprintComponent.self)?.createResizeHandles()
    }

  }
  
  
//  Given a size and a point, return an array of relative coodinates of tiles that are blocked.
  func getBlockedTiles(inRect: CGSize, atPoint: CGPoint) -> [(x: Int, y: Int)] {
    var blockedTiles: [(x: Int,y: Int)] = []
    
    for x in stride(from: Int(atPoint.x), to: Int(atPoint.x + inRect.width), by: 1){
      for y in stride(from: Int(atPoint.y), to: Int(atPoint.y + inRect.height), by: 1) {
        let tile = Game.sharedInstance.tilesAtCoords[Int(x)]![Int(y)]!
        //        Check tile is blocked or has walls. if so, add coords to array as tuple
        if (tile.blocked || tile.walls.anyBlocked() || tile.isRoomFloor) {
          blockedTiles.append((x: x - Int(atPoint.x) + 1, y: y - Int(atPoint.y) + 1))
        }
      }
    }
    
    return blockedTiles
  }
  
//  func getBottomLeftTilePos (point)
  
  
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
    
    Game.sharedInstance.entityManager.remove(self.entity!)
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
    guard let entity = self.entity else {return}

    if self.canBuildAtPoint(entity.component(ofType: PositionComponent.self)!.gridPosition!) == false {
      return
    }
    self.clearPlan()
//    Make the room built somehow
    entity.addComponent(entity.component(ofType: PositionComponent.self)!)
    // The below line probably needs to go
    //    self.size = self.roomBlueprint.size
//    Any tidy up?
    Game.sharedInstance.buildRoomStateMachine.enter(BRSDone.self)
    Game.sharedInstance.gameStateMachine.enter(GSGeneral.self)
    self.build()
  }
  
  func build () {
    guard let entity = self.entity else {return}

    let texture = Room.createFloorTexture(entity.component(ofType: RoomBlueprintComponent.self)!.size)
    
    let floorNode = SKSpriteNode(texture: texture)
    
    self.entity?.addComponent(SpriteComponent(texture: SKView().texture(from: floorNode)!))
    Game.sharedInstance.entityManager.add(entity, layer: ZPositionManager.WorldLayer.room)
    self.setTileWalls()
  }
  
  func cancelBuild() {
    self.clearPlan()
    Game.sharedInstance.gameStateMachine.enter(GSGeneral.self)
  }
  
  func setTileWalls () {
    guard let entity = self.entity else {return}
    
    let bottomLeftTilePosition = entity.component(ofType: PositionComponent.self)!.gridPosition!
    let size = entity.component(ofType: RoomBlueprintComponent.self)!.size

    
    for x in stride(from: Int(bottomLeftTilePosition.x), to: Int(bottomLeftTilePosition.x + size.width), by: 1){
      for y in stride(from: Int(bottomLeftTilePosition.y), to: Int(bottomLeftTilePosition.y + size.height), by: 1) {
        let tile = Game.sharedInstance.tilesAtCoords[Int(x)]![Int(y)]
        // Also set tile room floor
        tile?.isRoomFloor = true
        if (x == Int(bottomLeftTilePosition.x)) {
          tile?.addWall(ofBaring: Game.rotation.west)
        }
        if (y == Int(bottomLeftTilePosition.y)) {
          tile?.addWall(ofBaring: Game.rotation.south)
        }
        if (x == Int(bottomLeftTilePosition.x + size.width - 1 )) {
          tile?.addWall(ofBaring: Game.rotation.east)
        }
        if (y == Int(bottomLeftTilePosition.y + size.height - 1)) {
          tile?.addWall(ofBaring: Game.rotation.north)
        }
      }
    }
    
  }
  
  func getGridPosForSpritePos(_ position: CGPoint) -> CGPoint? {
//    This position needs to be passed in from roomBlueprint
//    let position = self.room.component(ofType: PositionComponent.self)!.spritePosition!
//    let position = self.roomBlueprint.component(ofType: PositionComponent.self)?.spritePosition
    let size = (self.entity?.component(ofType: RoomBlueprintComponent.self)?.size)!

    let bottomLeftX = position.x - (size.width * 64) / 2
    let bottomLeftY = position.y - (size.height * 64) / 2
    
    let bottomLeftGridPosition = CGPoint(x: bottomLeftX / 64, y: bottomLeftY / 64)
    
    if( bottomLeftGridPosition.x.truncatingRemainder(dividingBy: 1) != 0 && bottomLeftGridPosition.y.truncatingRemainder(dividingBy: 1) != 0 ) {
      return nil
    }
    
    return bottomLeftGridPosition
  }
  
  
  func canPlanAtPoint(_ point: CGPoint) -> Bool {
    guard let entity = self.entity else {return false}
    
    let size = entity.component(ofType: RoomBlueprintComponent.self)!.size
    
    for x in stride(from: Int(point.x), to: Int(point.x + size.width), by: 1){
      for y in stride(from: Int(point.y), to: Int(point.y + size.height), by: 1) {
        if (Game.sharedInstance.tilesAtCoords[Int(x)]![Int(y)] == nil) {
          return false
        }
      }
    }
    
    return true
  }
  
  func canBuildAtPoint(_ point: CGPoint) -> Bool {
    guard let entity = self.entity else {return false}

    let size = entity.component(ofType: RoomBlueprintComponent.self)!.size


    for x in stride(from: Int(point.x), to: Int(point.x + size.width), by: 1){
      for y in stride(from: Int(point.y), to: Int(point.y + size.height), by: 1) {
        guard let tile = Game.sharedInstance.tilesAtCoords[Int(x)]![Int(y)] else {
          return false
        }
        if (tile.blocked || tile.walls.anyBlocked() || tile.isRoomFloor) {
          return false
        }
      }
    }
    
    return true
  }
  
  
  
}
