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
  
  var size:CGSize = CGSize(width: 1, height: 1) {
    didSet {
      print("==== didset size")
      let previousPosition = self.component(ofType: SpriteComponent.self)?.node.position
      Game.sharedInstance.entityManager.remove(self)
      self.removeComponent(ofType: SpriteComponent.self)
      self.addComponent(SpriteComponent(texture: self.createFloorplanTexture(size)))
      self.component(ofType: SpriteComponent.self)?.node.name = "planning_room_blueprint"
      self.component(ofType: SpriteComponent.self)?.node.position = previousPosition!
      self.component(ofType: SpriteComponent.self)!.addToNodeKey()
      Game.sharedInstance.entityManager.add(self, layer: ZPositionManager.WorldLayer.world)
    }
  }
  
  var room: GKEntity
  
  static var square = SKShapeNode(rectOf: CGSize(width: 64, height: 64))
  static var innerSquare = SKShapeNode(rectOf: CGSize(width: 55, height: 55))

  static var pattern : [CGFloat] = [4.0, 4.0]
  static let dashed = CGPath (__byDashing: square.path!, transform: nil, phase: 0, lengths: pattern, count: 2)
  static var dashedSquare = SKShapeNode(path: dashed!)
  
  
  static let combinedSqaure: SKSpriteNode = RoomBlueprint.compileAssets()
  static var assetsCompiled = false
  
  let tileOffset = CGPoint(x: 32, y: 32)
  
  var dragOffset: CGPoint?
  var anchorTile: GKEntity?
  
  init(size: CGSize, room: GKEntity) {
    self.room = room
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

    self.addComponent(SpriteComponent(texture: self.createFloorplanTexture(self.size)))
    self.component(ofType: SpriteComponent.self)?.node.name = "planning_room_blueprint"
    
    self.component(ofType: SpriteComponent.self)!.addToNodeKey()
    
    self.addComponent(PositionComponent(gridPosition: CGPoint.zero))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func dragStartHandler(_ point:CGPoint) {
    let spritePos = self.component(ofType: SpriteComponent.self)?.node.position
    self.dragOffset = CGPoint(x: spritePos!.x - point.x, y: spritePos!.y - point.y)
    
    let tile = getTileAtPoint(CGPoint(x: spritePos!.x - (self.size.width.truncatingRemainder(dividingBy: 2) == 0 ? 32 : 0), y: spritePos!.y - (self.size.height.truncatingRemainder(dividingBy: 2) == 0 ? 32 : 0)))
    self.anchorTile = tile
  }
  
  func dragMoveHandler(_ point:CGPoint) {
    let spritePos = self.component(ofType: SpriteComponent.self)?.node.position
    
    let tile = getTileAtPoint(CGPoint(x: point.x + self.dragOffset!.x - (self.size.width.truncatingRemainder(dividingBy: 2) == 0 ? 32 : 0), y: point.y + self.dragOffset!.y - (self.size.height.truncatingRemainder(dividingBy: 2) == 0 ? 32 : 0)))
//    print(self.anchorTile)
//    print(tile)
    if (self.anchorTile !== tile) {
      if (tile == nil || !tile!.isKind(of: Tile.self)) {
        return
      }
      self.anchorTile = tile
      let tilePosition = tile?.component(ofType: PositionComponent.self)?.spritePosition
//      Later, make genertic north south east west actions... maybe
      let moveAction = SKAction.move(to: self.getPointForSize(tilePosition!), duration: TimeInterval(0.1))
      moveAction.timingMode = SKActionTimingMode.easeInEaseOut
      self.component(ofType: SpriteComponent.self)?.node.run(moveAction, completion: {})
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
      self.anchorTile = self.getTileAtPoint(CGPoint(x: point.x, y: point.y + 32))
    case (Game.axis.vert, _, Game.numericalSignage.positive):
      self.handleDragEdge = Game.rotation.north
      self.anchorTile = self.getTileAtPoint(CGPoint(x: point.x, y: point.y - 32))
    case (Game.axis.hroiz, Game.numericalSignage.positive, _):
      self.handleDragEdge = Game.rotation.east
      self.anchorTile = self.getTileAtPoint(CGPoint(x: point.x - 32, y: point.y))
    case (Game.axis.hroiz, Game.numericalSignage.negative, _):
      self.handleDragEdge = Game.rotation.west
      self.anchorTile = self.getTileAtPoint(CGPoint(x: point.x + 32, y: point.y))
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
    let currentTile = self.getTileAtPoint(CGPoint(x: point.x + ((edge == Game.rotation.east) ? -32 : edge == Game.rotation.west ? 32 : 0), y: point.y + ((edge == Game.rotation.north) ? -32 : edge == Game.rotation.south ? 32 : 0)) )
    if (currentTile == nil || !currentTile!.isKind(of: Tile.self)) {
      return
    }

    pointSprite.strokeColor = UIColor.red
//    (currentTile as! Tile).highlight((currentTile!.componentForClass(SpriteComponent.self)?.node.position)!)
    pointSprite.position = CGPoint(x: point.x, y: point.y + 32)
    pointSprite.zPosition = 100000
    pointSprite.removeFromParent()
    Game.sharedInstance.entityManager.node.addChild(pointSprite)



    if (self.anchorTile !== currentTile) {
      
      let currentNodePosition = self.component(ofType: SpriteComponent.self)?.node.position
      
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
        
        if (self.handleDragAxis == Game.axis.vert) {
          self.component(ofType: SpriteComponent.self)?.node.position = CGPoint(x: currentNodePosition!.x, y: currentNodePosition!.y + ( direction == Game.rotation.south ? -32 : direction == Game.rotation.north ? 32 : 0))
        } else if (self.handleDragAxis == Game.axis.hroiz) {
          self.component(ofType: SpriteComponent.self)?.node.position = CGPoint(x: currentNodePosition!.x + ( (direction == Game.rotation.west) ? -32 : direction == Game.rotation.east ? 32 : 0), y: currentNodePosition!.y)
        }
        
        self.size = newSize
        
        self.anchorTile = currentTile
      }

      self.createResizeHandles()


    }
    
    self.handleDragPreviousMovePoint = point
    
  }
  
  func allowToPlaceDoor() {
    
    // The code at the start of this function is almost identical to that found in RoomBlueprint, and the two should be refactored
    
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
    
    for edgeInstruct in edgeInstructions {
      
      for x in stride(from: edgeInstruct.start, to:edgeInstruct.end, by: 64) {
        let texture = Game.sharedInstance.mainView?.texture(from: SKShapeNode(circleOfRadius: 32))
        let doorButton = Button(texture: texture!, touch_f: {
          print("door button touch")
          Game.sharedInstance.buildRoomStateMachine.enter(BRSDone.self)

          let doorPosition = CGPoint(x: x, y: edgeInstruct.face)
          let doorDirection = edgeInstruct.side
          
          let door = Door(room: self.room, gridPosition: doorPosition, direction: doorDirection)
          
        })
        
        let doorButtonSprite = doorButton.component(ofType: SpriteComponent.self)!.node
        
        doorButtonSprite.zPosition = (self.component(ofType: SpriteComponent.self)?.node.zPosition)! + 1
        doorButtonSprite.setScale(0.5)
        doorButtonSprite.name = "planning_room_door"
        
        doorButtonSprite.position = edgeInstruct.axis == Game.axis.vert ? CGPoint(x: x + 32, y: edgeInstruct.face) : CGPoint(x: edgeInstruct.face, y: x + 32 )
        doorButtonSprite.color = SKColor.orange
        doorButtonSprite.colorBlendFactor = 1
        
        doorButton.component(ofType: SpriteComponent.self)?.addToNodeKey()
        self.component(ofType: SpriteComponent.self)?.node.addChild((doorButton.component(ofType: SpriteComponent.self)?.node)!)
        // Game.sharedInstance.entityManager.add(doorButton, layer: ZPositionManager.WorldLayer.interaction)
      }
      
    }
  }
  
  func getTileAtPoint(_ point: CGPoint) -> GKEntity? {
    let nodesAtPoint = Game.sharedInstance.wolrdnode.contentNode.nodes(at: point)
    var tile: GKEntity?
    
    for node in nodesAtPoint {
      guard let entity: GKEntity = node.userData?["entity"] as? GKEntity else {continue}
      
      if (entity.isKind(of: Tile.self)) {
        tile = entity
      }
    }
    
    return tile
  }
  
  func createFloorplanTexture(_ roomSize: CGSize) -> SKTexture {
    let blueprintNode = SKSpriteNode()
    let base = 32
    let width = 64
    
    for x in 1...Int(roomSize.width) {
      for y in 1...Int(roomSize.height) {
        let squareNode = RoomBlueprint.combinedSqaure.copy() as! SKSpriteNode
        squareNode.position = CGPoint(x: x * width + base, y: y * width + base)
        blueprintNode.addChild(squareNode)
      }
    }
    blueprintNode.alpha = 0.5
    return SKView().texture(from: blueprintNode)!
  }

  
  static func compileAssets() -> SKSpriteNode {
    
    innerSquare.fillColor = UIColor.blue
    innerSquare.strokeColor = UIColor.init(white: 0, alpha: 0)
    dashedSquare.fillColor = UIColor.blue
    dashedSquare.strokeColor = UIColor.blue
    
    let view = SKView()
    let squareSprite = SKSpriteNode(texture: view.texture(from: innerSquare))
    let squareBorderSprite = SKSpriteNode(texture: view.texture(from: dashedSquare))
    
    let combinedNode = SKSpriteNode()
    combinedNode.addChild(squareSprite)
    combinedNode.addChild(squareBorderSprite)
    combinedNode.alpha = 0.5
    return combinedNode
  }
  
  func getPointForSize (_ point: CGPoint) -> CGPoint {
    return CGPoint(x: point.x + (self.size.width.truncatingRemainder(dividingBy: 2) == 0 ? 32 : 0), y: point.y + (self.size.height.truncatingRemainder(dividingBy: 2) == 0 ? 32 : 0))
  }

}
