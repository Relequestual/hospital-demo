//
//  RoomBlueprint.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 15/08/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class RoomBlueprint: GKEntity {
  
  var size:CGSize
  
  var room: Room
  
  static var square = SKShapeNode(rectOf: CGSize(width: 64, height: 64))
  static var innerSquare = SKShapeNode(rectOf: CGSize(width: 55, height: 55))

  static var pattern : [CGFloat] = [4.0, 4.0]
  static let dashed = CGPath (__byDashing: square.path!, transform: nil, phase: 0, lengths: pattern, count: 2)
  static var dashedSquare = SKShapeNode(path: dashed!)
  
  
  static let combinedSqaure: SKSpriteNode = RoomBlueprint.compileAssets(color: nil)
  static let combinedSqaureRed: SKSpriteNode = RoomBlueprint.compileAssets(color: UIColor.red)
  static var assetsCompiled = false
  
  let tileOffset = CGPoint(x: 32, y: 32)
  
  var dragOffset: CGPoint?
  var anchorTile: GKEntity?
  
  init(size: CGSize, room: Room) {
    self.room = room
    self.size = size
    super.init()
//    self.dynamicType.dashedSquare.lineWidth = 2
    
    self.addComponent(DraggableSpriteComponent(
      start: { (point: CGPoint) in
        print("start drag room")
        self.dragStartHandler(point)
      }, move: { (point: CGPoint) in
        self.dragMoveHandler(point)
        print("move drag room")
      }, end: { (point: CGPoint) in
        self.dragOffset = CGPoint.zero
        print("end drag room")
    }))

    self.addComponent(SpriteComponent(texture: self.createFloorplanTexture(roomSize: self.size)))
    self.component(ofType: SpriteComponent.self)?.node.name = "planning_room_blueprint"
    
    self.component(ofType: SpriteComponent.self)!.addToNodeKey()
    
    self.addComponent(PositionComponent(gridPosition: CGPoint.zero))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func dragStartHandler(_ point:CGPoint) {
  
    let gridPos = self.component(ofType: PositionComponent.self)?.gridPosition
    let roomTileAnchor = Game.sharedInstance.tilesAtCoords[Int(gridPos!.x)]![Int(gridPos!.y)]
   
    let tileSpritePos = roomTileAnchor?.component(ofType: PositionComponent.self)?.spritePosition
    self.dragOffset = CGPoint(x: (tileSpritePos?.x)! - point.x, y: (tileSpritePos?.y)! - point.y)
    
    self.anchorTile = roomTileAnchor

    Game.sharedInstance.initDebugNode(name: "offset")
    Game.sharedInstance.updateDebugNode(name: "offset", position: dragOffset!)
    
  }
  
  func dragMoveHandler(_ point:CGPoint) {
    let offsetPoint = CGPoint(x: point.x + (dragOffset?.x)!, y: point.y + (dragOffset?.y)!)
    let tile = PositionComponent.getTileAtPoint(offsetPoint)
    
    Game.sharedInstance.updateDebugNode(name: "offset", position: offsetPoint)

    if (self.anchorTile !== tile) {
      if (tile == nil || !tile!.isKind(of: Tile.self)) {
        return
      }
      self.anchorTile = tile
      
      self.room.component(ofType: BuildRoomComponent.self)?.planAtPoint((tile?.component(ofType: PositionComponent.self)?.gridPosition)!, true)
    }
  }
  
  
  struct resizeHandleDrawingInstruction {
    var axis: Game.axis
    var start: Int
    var end: Int
    var face: Int
    var side: Game.rotation
  }
  
  struct possibleDoorLocationDrawingInstruction {
    var axis: Game.axis
    var start: Int
    var end: Int
    var face: Int
    var side: Game.rotation
  }
  
  
  func createResizeHandles() {
    self.removeResizeHandles()
    let spritePosition = CGPoint.zero
    let edgeYT = Int(spritePosition.y + size.height * 64 / 2)
    let edgeYB = Int(spritePosition.y - size.height * 64 / 2)
    
    let edgeXL = Int(spritePosition.x - size.width * 64 / 2)
    let edgeXR = Int(spritePosition.x + size.width * 64 / 2)
    
    print(edgeXL)
    print(edgeXR)
    print(edgeYT)
    print(edgeYB)
    
//    array of dictionaries needed for button creation
    
    let southEdge = resizeHandleDrawingInstruction(axis: Game.axis.vert, start: edgeXL, end: edgeXR, face: edgeYB, side: Game.rotation.south)
    let northEdge = resizeHandleDrawingInstruction(axis: Game.axis.vert, start: edgeXL, end: edgeXR, face: edgeYT, side: Game.rotation.north)
    
    let eastEdge = resizeHandleDrawingInstruction(axis: Game.axis.hroiz, start: edgeYB, end: edgeYT, face: edgeXR, side: Game.rotation.east)
    let westEdge = resizeHandleDrawingInstruction(axis: Game.axis.hroiz, start: edgeYB, end: edgeYT, face: edgeXL, side: Game.rotation.west)


    let edgeInstructions = [southEdge, northEdge, eastEdge, westEdge]
    
    for edgeInstruct in edgeInstructions {
      
      for x in stride(from: edgeInstruct.start, to:edgeInstruct.end, by: 64) {
        let texture_vert = SKTexture(imageNamed: edgeInstruct.axis == Game.axis.vert ? "Graphics/drag_vert" : "Graphics/drag_hroz")
        let vertButton = Button(texture: texture_vert, touch_start_f: { (point: CGPoint) in
          self.handleDragStart(point, axis: edgeInstruct.axis)
          print("handle drag start")
          }, touch_move_f: { (point) in
            print("handle drag move")
            self.handleDragMove(point, edge: edgeInstruct.side)
          }, touch_end_f: { (point) in
            //          handleDragend(point: point)
        })
        let buttonVertSprite = vertButton.component(ofType: SpriteComponent.self)!.node
        
        buttonVertSprite.zPosition = (self.component(ofType: SpriteComponent.self)?.node.zPosition)! + 1
        buttonVertSprite.setScale(0.5)
        buttonVertSprite.name = "planning_room_blueprint_handles"
        buttonVertSprite.position = edgeInstruct.axis == Game.axis.vert ? CGPoint(x: x + 32, y: edgeInstruct.face) : CGPoint(x: edgeInstruct.face, y: x + 32 )
        buttonVertSprite.color = SKColor.blue
        buttonVertSprite.colorBlendFactor = 1
        let circle = SKShapeNode(circleOfRadius: 32)
        circle.strokeColor = SKColor.blue
        circle.lineWidth = 2
        
        //TODO: make this button a single image sometime
        buttonVertSprite.addChild(circle)
        vertButton.component(ofType: SpriteComponent.self)?.addToNodeKey()
        self.component(ofType: SpriteComponent.self)?.node.addChild((vertButton.component(ofType: SpriteComponent.self)?.node)!)
        //      Game.sharedInstance.entityManager.add(vertButton, layer: ZPositionManager.WorldLayer.interaction)
      }
    }
  }
  

//  Not really happy about this, but...
  var handleDragAxis: Game.axis = Game.axis.hroiz
  var handleDragXSign: Game.numericalSignage = Game.numericalSignage.positive
  var handleDragYSign: Game.numericalSignage = Game.numericalSignage.positive
  var handleDragEdge: Game.rotation = Game.rotation.north
  var handleDragPreviousMovePoint: CGPoint = CGPoint.zero
  
  func handleDragStart (_ point: CGPoint, axis: Game.axis) {
    self.handleDragAxis = axis
    self.handleDragPreviousMovePoint = point
//    Determine edge is being dragged
    let centerOfRoom = self.component(ofType: SpriteComponent.self)?.node.position
    self.handleDragXSign = (point.x < centerOfRoom!.x) ? Game.numericalSignage.negative : Game.numericalSignage.positive
    self.handleDragYSign = (point.y < centerOfRoom!.y) ? Game.numericalSignage.negative : Game.numericalSignage.positive
    
    switch (self.handleDragAxis, self.handleDragXSign, self.handleDragYSign) {
    case (Game.axis.vert, _, Game.numericalSignage.negative):
      self.handleDragEdge = Game.rotation.south
      self.anchorTile = PositionComponent.getTileAtPoint(CGPoint(x: point.x, y: point.y + 32))
    case (Game.axis.vert, _, Game.numericalSignage.positive):
      self.handleDragEdge = Game.rotation.north
      self.anchorTile = PositionComponent.getTileAtPoint(CGPoint(x: point.x, y: point.y - 32))
    case (Game.axis.hroiz, Game.numericalSignage.positive, _):
      self.handleDragEdge = Game.rotation.east
      self.anchorTile = PositionComponent.getTileAtPoint(CGPoint(x: point.x - 32, y: point.y))
    case (Game.axis.hroiz, Game.numericalSignage.negative, _):
      self.handleDragEdge = Game.rotation.west
      self.anchorTile = PositionComponent.getTileAtPoint(CGPoint(x: point.x + 32, y: point.y))
    default:
      print("huh")
    }

  }
  
  //  Remove child nodes from the sprite of this node that are the planning handles
  //  I realised that the function enumerateChildNodesWithName only does child and not descendant nodes. Not a deep action.
  func removeResizeHandles() {
    print("remvoing resize handles")
      self.component(ofType: SpriteComponent.self)?.node.enumerateChildNodes(withName: "planning_room_blueprint_handles", using: { (node, stop) -> Void in
      node.removeFromParent()
    });
  }
  
  let pointSprite = SKShapeNode(circleOfRadius: 5)
  //    pointSprite.fillColor = UIColor.redColor()

  func handleDragMove (_ point: CGPoint, edge: Game.rotation) {
    print("___handleDragMove point is")
    print(point)
    print(edge)
    let currentTile = PositionComponent.getTileAtPoint(CGPoint(x: point.x + ((edge == Game.rotation.east) ? -32 : edge == Game.rotation.west ? 32 : 0), y: point.y + ((edge == Game.rotation.north) ? -32 : edge == Game.rotation.south ? 32 : 0)) )
    if (currentTile == nil || !currentTile!.isKind(of: Tile.self)) {
      return
    }

    pointSprite.strokeColor = UIColor.red
    pointSprite.position = CGPoint(x: point.x, y: point.y + 32)
    pointSprite.zPosition = 100000
    pointSprite.removeFromParent()
    Game.sharedInstance.entityManager.node.addChild(pointSprite)



    if (self.anchorTile !== currentTile) {
      
//      Check  what direction was dragged when tile was changed
      var direction: Game.rotation = Game.rotation.north
      let anchorTileGridPos = self.anchorTile?.component(ofType: PositionComponent.self)?.gridPosition
      let currentTileGridPos = currentTile!.component(ofType: PositionComponent.self)?.gridPosition
      if (self.handleDragAxis == Game.axis.vert){
        if (anchorTileGridPos!.y == currentTileGridPos!.y) {
          return
        }
        if (point.y < self.handleDragPreviousMovePoint.y) {
          if (anchorTileGridPos!.y - 1 != currentTileGridPos!.y) {
            return
          }
          direction = Game.rotation.south
        } else {
          if (anchorTileGridPos!.y + 1 != currentTileGridPos!.y) {
            return
          }
          direction = Game.rotation.north
        }
      } else if (self.handleDragAxis == Game.axis.hroiz) {
        if (anchorTileGridPos!.x == currentTileGridPos!.x) {
          return
        }
        if (point.x < self.handleDragPreviousMovePoint.x) {
          if (anchorTileGridPos!.x - 1 != currentTileGridPos!.x) {
            return
          }
          direction = Game.rotation.west
        } else {
          if (anchorTileGridPos!.x + 1 != currentTileGridPos!.x) {
            return
          }
          direction = Game.rotation.east
        }
      }
      
      print("direction is")
      print(direction)

      var newSize = CGSize.zero
      
      
      switch self.handleDragEdge {
      case .south:
        newSize = CGSize(width: self.size.width, height: self.size.height + (direction == Game.rotation.south ? 1 : direction == Game.rotation.north ? -1 : 0))
      case .north:
        newSize = CGSize(width: self.size.width, height: self.size.height + (direction == Game.rotation.north ? 1 : direction == Game.rotation.south ? -1 : 0))
      case .east:
        newSize = CGSize(width: self.size.width + (direction == Game.rotation.east ? 1 : direction == Game.rotation.west ? -1 : 0), height: self.size.height)
      case .west:
        newSize = CGSize(width: self.size.width + (direction == Game.rotation.west ? 1 : direction == Game.rotation.east ? -1 : 0), height: self.size.height)
      }
      
      if (newSize.width != 0 && newSize.height != 0) {

        let oldGridPos = self.component(ofType: PositionComponent.self)?.gridPosition
        let newGridPos: CGPoint
        if(self.handleDragEdge == .south || self.handleDragEdge == .west) {
          let sizeChange = CGSize(width: self.size.width - newSize.width, height: self.size.height - newSize.height)
          newGridPos = CGPoint(x: (oldGridPos?.x)! + sizeChange.width, y: (oldGridPos?.y)! + sizeChange.height)
        } else {
          newGridPos = oldGridPos!
        }
        
        self.size = newSize
        
        self.room.component(ofType: BuildRoomComponent.self)?.planAtPoint(newGridPos)
        
        self.anchorTile = currentTile
      }

      self.createResizeHandles()
      
    }
    
    self.handleDragPreviousMovePoint = point
    
  }
  
  func allowToPlaceDoor() {
    
    //TODO: The code at the start of this function is almost identical to createResizeHandles, and the two should be refactored to use the same code
    
    let spritePosition = CGPoint.zero
    let edgeYT = Int(spritePosition.y + self.size.height * 64 / 2)
    let edgeYB = Int(spritePosition.y - self.size.height * 64 / 2)
    
    let edgeXL = Int(spritePosition.x - self.size.width * 64 / 2)
    let edgeXR = Int(spritePosition.x + self.size.width * 64 / 2)
    
    print(edgeXL)
    print(edgeXR)
    print(edgeYT)
    print(edgeYB)
    
    
    //    array of dictionaries needed for button creation
    
    let southEdge = possibleDoorLocationDrawingInstruction(axis: Game.axis.vert, start: edgeXL, end: edgeXR, face: edgeYB, side: Game.rotation.south)
    let northEdge = possibleDoorLocationDrawingInstruction(axis: Game.axis.vert, start: edgeXL, end: edgeXR, face: edgeYT, side: Game.rotation.north)
    
    let eastEdge = possibleDoorLocationDrawingInstruction(axis: Game.axis.hroiz, start: edgeYB, end: edgeYT, face: edgeXR, side: Game.rotation.east)
    let westEdge = possibleDoorLocationDrawingInstruction(axis: Game.axis.hroiz, start: edgeYB, end: edgeYT, face: edgeXL, side: Game.rotation.west)
    
    
    let edgeInstructions = [southEdge, northEdge, eastEdge, westEdge]
    let roomPosition = self.component(ofType: SpriteComponent.self)?.node.position
    
    for edgeInstruct in edgeInstructions {
      
      let doorDirection = edgeInstruct.side
      
      for x in stride(from: edgeInstruct.start, to:edgeInstruct.end, by: 64) {
        let doorPosition = edgeInstruct.axis == Game.axis.vert ? CGPoint(x: x + 32, y: edgeInstruct.face) : CGPoint(x: edgeInstruct.face, y: x + 32 )
//        let texture = Game.sharedInstance.mainView?.texture(from: SKShapeNode(circleOfRadius: 32))
        
        let realPosition = CGPoint(x: (roomPosition?.x)! + doorPosition.x, y: (roomPosition?.y)! + doorPosition.y)
        
        
        let door = Door(room: self.room, realPosition: realPosition, direction: doorDirection)
        
        self.room.addDoor(door: door)
        
        
//        let doorButtonSprite = doorButton.component(ofType: SpriteComponent.self)!.node
//        
//        doorButtonSprite.zPosition = (self.component(ofType: SpriteComponent.self)?.node.zPosition)! + 1
//        doorButtonSprite.setScale(0.5)
//        doorButtonSprite.name = "planning_room_door"
//        
//        doorButtonSprite.position = doorPosition
//        doorButtonSprite.color = SKColor.orange
//        doorButtonSprite.colorBlendFactor = 1
//        
//        doorButton.component(ofType: SpriteComponent.self)?.addToNodeKey()
//        self.component(ofType: SpriteComponent.self)?.node.addChild((doorButton.component(ofType: SpriteComponent.self)?.node)!)
        // Game.sharedInstance.entityManager.add(doorButton, layer: ZPositionManager.WorldLayer.interaction)
      }
      
    }
  }
  

  
  func createFloorplanTexture(roomSize: CGSize, blockedTiles: [(x: Int,y: Int)]?=[]) -> SKTexture {
    let blueprintNode = SKSpriteNode()
    let base = 32
    let width = 64
    
    for x in 1...Int(roomSize.width) {
      for y in 1...Int(roomSize.height) {
        var squareNode: SKSpriteNode
        
        if (blockedTiles?.contains(where: { (coords: (x: Int, y: Int)) -> Bool in
          return Bool(x == coords.x && y == coords.y)
        }))! {
          squareNode = RoomBlueprint.combinedSqaureRed.copy() as! SKSpriteNode
        } else {
          squareNode = RoomBlueprint.combinedSqaure.copy() as! SKSpriteNode
        }
        
        squareNode.position = CGPoint(x: x * width + base, y: y * width + base)
        blueprintNode.addChild(squareNode)
      }
    }
    blueprintNode.alpha = 0.6
    return SKView().texture(from: blueprintNode)!
  }

  
  static func compileAssets(color: UIColor?) -> SKSpriteNode {
    
    let mycolor: UIColor! = (color != nil) ? color : UIColor.blue
    
    innerSquare.fillColor = mycolor
    innerSquare.strokeColor = UIColor.init(white: 0, alpha: 0)
    dashedSquare.fillColor = mycolor
    dashedSquare.strokeColor = mycolor
    
    let view = SKView()
    let squareSprite = SKSpriteNode(texture: view.texture(from: innerSquare))
    let squareBorderSprite = SKSpriteNode(texture: view.texture(from: dashedSquare))
    
    let combinedNode = SKSpriteNode()
    combinedNode.addChild(squareSprite)
    combinedNode.addChild(squareBorderSprite)
    combinedNode.alpha = 0.6
    return combinedNode
  }
  


}
