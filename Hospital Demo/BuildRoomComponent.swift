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
      
      
    }
//    replace current toolbar with confirm toolbar.
    Game.sharedInstance.toolbarManager?.addToolbar(confirmToolbar, location: Game.rotation.South, shown: true)
    

  }
  
  struct possibleDoorLocationDrawingInstruction {
    var axis: Game.axis
    var start: Int
    var end: Int
    var face: Int
    var side: Game.rotation
  }
  
  func allowToPlaceDoor() {
    
    // The code at the start of this function is almost identical to that found in RoomBlueprint, and the two should be refactored
    
    let spritePosition = CGPointZero
    let edgeYT = Int(spritePosition.y + self.size.height * 64 / 2)
    let edgeYB = Int(spritePosition.y - self.size.height * 64 / 2)
    
    let edgeXL = Int(spritePosition.x - self.size.width * 64 / 2)
    let edgeXR = Int(spritePosition.x + self.size.width * 64 / 2)
    
    print(edgeXL)
    print(edgeXR)
    print(edgeYT)
    print(edgeYB)
    
    
    //    array of dictionaries needed for button creation
    
    let southEdge = possibleDoorLocationDrawingInstruction(axis: Game.axis.Vert, start: edgeXL, end: edgeXR, face: edgeYB, side: Game.rotation.South)
    let northEdge = possibleDoorLocationDrawingInstruction(axis: Game.axis.Vert, start: edgeXL, end: edgeXR, face: edgeYT, side: Game.rotation.North)
    
    let eastEdge = possibleDoorLocationDrawingInstruction(axis: Game.axis.Hroiz, start: edgeYB, end: edgeYT, face: edgeXR, side: Game.rotation.East)
    let westEdge = possibleDoorLocationDrawingInstruction(axis: Game.axis.Hroiz, start: edgeYB, end: edgeYT, face: edgeXL, side: Game.rotation.West)
    
    
    let edgeInstructions = [southEdge, northEdge, eastEdge, westEdge]
    
    for edgeInstruct in edgeInstructions {
      
      for x in edgeInstruct.start.stride(to:edgeInstruct.end, by: 64) {
        let texture = Game.sharedInstance.mainView?.textureFromNode(SKShapeNode(circleOfRadius: 32))
        let doorButton = Button(texture: texture!, touch_f: {
          print("door button touch")
          // andddd
        })
        
        let doorButtonSprite = doorButton.componentForClass(SpriteComponent)!.node
        
        doorButtonSprite.zPosition = (self.entity?.componentForClass(SpriteComponent)?.node.zPosition)! + 1
        doorButtonSprite.setScale(0.5)
        doorButtonSprite.name = "planning_room_door"
        
//        The next line needs to be a switch which includes side, as for each side you will need to add or subtract 32 from x or y
        
        doorButtonSprite.position = edgeInstruct.axis == Game.axis.Vert ? CGPoint(x: x + 32, y: edgeInstruct.face) : CGPoint(x: edgeInstruct.face, y: x + 32 )
        doorButtonSprite.color = SKColor.blueColor()
        doorButtonSprite.colorBlendFactor = 1
        let circle = SKShapeNode(circleOfRadius: 32)
        circle.strokeColor = SKColor.blueColor()
        circle.lineWidth = 2
        
        //TODO: make this button a single image sometime
        doorButtonSprite.addChild(circle)
        vertButton.componentForClass(SpriteComponent)?.addToNodeKey()
        self.componentForClass(SpriteComponent)?.node.addChild((vertButton.componentForClass(SpriteComponent)?.node)!)
        //      Game.sharedInstance.entityManager.add(vertButton, layer: ZPositionManager.WorldLayer.interaction)
      }
      
    }
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