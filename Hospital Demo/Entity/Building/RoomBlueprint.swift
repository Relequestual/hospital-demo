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
      let previousPosition = self.componentForClass(SpriteComponent)?.node.position
      Game.sharedInstance.entityManager.remove(self)
      self.removeComponentForClass(SpriteComponent)
      self.addComponent(SpriteComponent(texture: self.createFloorplanTexture(size)))
      self.componentForClass(SpriteComponent)?.node.name = "planning_room_blueprint"
      self.componentForClass(SpriteComponent)?.node.position = previousPosition!
      self.componentForClass(SpriteComponent)!.addToNodeKey()
      Game.sharedInstance.entityManager.add(self, layer: ZPositionManager.WorldLayer.world)
    }
  }
  
  static var square = SKShapeNode(rectOfSize: CGSize(width: 64, height: 64))
  static var innerSquare = SKShapeNode(rectOfSize: CGSize(width: 55, height: 55))

  static var pattern : [CGFloat] = [4.0, 4.0]
  static let dashed = CGPathCreateCopyByDashingPath (square.path, nil, 0, pattern, 2)
  static var dashedSquare = SKShapeNode(path: dashed!)
  
  
  static let combinedSqaure: SKSpriteNode = RoomBlueprint.compileAssets()
  static var assetsCompiled = false
  
  let tileOffset = CGPoint(x: 32, y: 32)
  
  var dragOffset: CGPoint?
  var anchorTile: GKEntity?
  
  init(size: CGSize?) {
    super.init()
//    self.dynamicType.dashedSquare.lineWidth = 2
    if (size != nil) {
      self.size = size!
    }
    self.addComponent(DraggableSpriteComponent(
      start: { (point: CGPoint) in
        print("start drag room")
        self.dragStartHandler(point)
      }, move: { (point: CGPoint) in
        self.dragMoveHandler(point)
        print("move drag room")
      }, end: { (point: CGPoint) in
        self.dragOffset = CGPointZero
        print("end drag room")
    }))

    self.addComponent(SpriteComponent(texture: self.createFloorplanTexture(self.size)))
    self.componentForClass(SpriteComponent)?.node.name = "planning_room_blueprint"
    
    self.componentForClass(SpriteComponent)!.addToNodeKey()
    
    self.addComponent(PositionComponent(gridPosition: CGPointZero))
  }
  
  func dragStartHandler(point:CGPoint) {
    let spritePos = self.componentForClass(SpriteComponent)?.node.position
    self.dragOffset = CGPoint(x: spritePos!.x - point.x, y: spritePos!.y - point.y)
    
    let tile = getTileAtPoint(CGPoint(x: spritePos!.x - (self.size.width % 2 == 0 ? 32 : 0), y: spritePos!.y - (self.size.height % 2 == 0 ? 32 : 0)))
    self.anchorTile = tile
  }
  
  func dragMoveHandler(point:CGPoint) {
    let spritePos = self.componentForClass(SpriteComponent)?.node.position
    
    let tile = getTileAtPoint(CGPoint(x: point.x + self.dragOffset!.x - (self.size.width % 2 == 0 ? 32 : 0), y: point.y + self.dragOffset!.y - (self.size.height % 2 == 0 ? 32 : 0)))
//    print(self.anchorTile)
//    print(tile)
    if (self.anchorTile !== tile) {
      if (tile == nil || !tile!.isKindOfClass(Tile)) {
        return
      }
      self.anchorTile = tile
      let tilePosition = tile?.componentForClass(PositionComponent)?.spritePosition
//      Later, make genertic north south east west actions... maybe
      let moveAction = SKAction.moveTo(self.getPointForSize(tilePosition!), duration: NSTimeInterval(0.1))
      moveAction.timingMode = SKActionTimingMode.EaseInEaseOut
      self.componentForClass(SpriteComponent)?.node.runAction(moveAction, completion: {})
    }
    
  }
  
  struct resizeHandleDrawingInstruction {
    var axis: Game.axis
    var start: Int
    var end: Int
    var face: Int
    var side: Game.rotation
  }
  
  
  func createResizeHandles() {
    let spritePosition = CGPointZero
    let edgeYT = Int(spritePosition.y + size.height * 64 / 2)
    let edgeYB = Int(spritePosition.y - size.height * 64 / 2)
    
    let edgeXL = Int(spritePosition.x - size.width * 64 / 2)
    let edgeXR = Int(spritePosition.x + size.width * 64 / 2)
    
    print(edgeXL)
    print(edgeXR)
    print(edgeYT)
    print(edgeYB)
    
    Game.sharedInstance.entityManager.node.enumerateChildNodesWithName("planning_room_blueprint_handles", usingBlock: { (node, stop) -> Void in
        node.removeFromParent()
    });
    
    
    
//    array of dictionaries needed for button creation
    
    let southEdge = resizeHandleDrawingInstruction(axis: Game.axis.Vert, start: edgeXL, end: edgeXR, face: edgeYB, side: Game.rotation.South)
    let northEdge = resizeHandleDrawingInstruction(axis: Game.axis.Vert, start: edgeXL, end: edgeXR, face: edgeYT, side: Game.rotation.North)
    
    let eastEdge = resizeHandleDrawingInstruction(axis: Game.axis.Hroiz, start: edgeYB, end: edgeYT, face: edgeXR, side: Game.rotation.East)
    let westEdge = resizeHandleDrawingInstruction(axis: Game.axis.Hroiz, start: edgeYB, end: edgeYT, face: edgeXL, side: Game.rotation.West)


    let edgeInstructions = [southEdge, northEdge, eastEdge, westEdge]
    
    for edgeInstruct in edgeInstructions {
      
      for x in edgeInstruct.start.stride(to:edgeInstruct.end, by: 64) {
        let texture_vert = SKTexture(imageNamed: edgeInstruct.axis == Game.axis.Vert ? "Graphics/drag_vert" : "Graphics/drag_hroz")
        let vertButton = Button(texture: texture_vert, touch_start_f: { (point: CGPoint) in
          self.handleDragStart(point, axis: edgeInstruct.axis)
          print("handle drag start")
          }, touch_move_f: { (point) in
            print("handle drag move")
            self.handleDragMove(point, edge: edgeInstruct.side)
          }, touch_end_f: { (point) in
            //          handleDragend(point: point)
        })
        let buttonVertSprite = vertButton.componentForClass(SpriteComponent)!.node
        
        buttonVertSprite.zPosition = (self.componentForClass(SpriteComponent)?.node.zPosition)! + 1
        buttonVertSprite.setScale(0.5)
        buttonVertSprite.name = "planning_room_blueprint_handles"
        buttonVertSprite.position = edgeInstruct.axis == Game.axis.Vert ? CGPoint(x: x + 32, y: edgeInstruct.face) : CGPoint(x: edgeInstruct.face, y: x + 32 )
        buttonVertSprite.color = SKColor.blueColor()
        buttonVertSprite.colorBlendFactor = 1
        let circle = SKShapeNode(circleOfRadius: 32)
        circle.strokeColor = SKColor.blueColor()
        circle.lineWidth = 2
        
        //TODO: make this button a single image sometime
        buttonVertSprite.addChild(circle)
        vertButton.componentForClass(SpriteComponent)?.addToNodeKey()
        self.componentForClass(SpriteComponent)?.node.addChild((vertButton.componentForClass(SpriteComponent)?.node)!)
        //      Game.sharedInstance.entityManager.add(vertButton, layer: ZPositionManager.WorldLayer.interaction)
      }
    }
  }
  

//  Not really happy about this, but...
  var handleDragAxis: Game.axis = Game.axis.Hroiz
  var handleDragXSign: Game.numericalSignage = Game.numericalSignage.positive
  var handleDragYSign: Game.numericalSignage = Game.numericalSignage.positive
  var handleDragEdge: Game.rotation = Game.rotation.North
  var handleDragPreviousMovePoint: CGPoint = CGPointZero
  
  func handleDragStart (point: CGPoint, axis: Game.axis) {
    self.handleDragAxis = axis
    self.handleDragPreviousMovePoint = point
//    Determine edge is being dragged
    let centerOfRoom = self.componentForClass(SpriteComponent)?.node.position
    self.handleDragXSign = (point.x < centerOfRoom!.x) ? Game.numericalSignage.negative : Game.numericalSignage.positive
    self.handleDragYSign = (point.y < centerOfRoom!.y) ? Game.numericalSignage.negative : Game.numericalSignage.positive
    
    switch (self.handleDragAxis, self.handleDragXSign, self.handleDragYSign) {
    case (Game.axis.Vert, _, Game.numericalSignage.negative):
      self.handleDragEdge = Game.rotation.South
      self.anchorTile = self.getTileAtPoint(CGPoint(x: point.x, y: point.y + 32))
    case (Game.axis.Vert, _, Game.numericalSignage.positive):
      self.handleDragEdge = Game.rotation.North
      self.anchorTile = self.getTileAtPoint(CGPoint(x: point.x, y: point.y - 32))
    case (Game.axis.Hroiz, Game.numericalSignage.positive, _):
      self.handleDragEdge = Game.rotation.East
      self.anchorTile = self.getTileAtPoint(CGPoint(x: point.x - 32, y: point.y))
    case (Game.axis.Hroiz, Game.numericalSignage.negative, _):
      self.handleDragEdge = Game.rotation.West
      self.anchorTile = self.getTileAtPoint(CGPoint(x: point.x + 32, y: point.y))
    default:
      print("huh")
    }

  }
  
  let pointSprite = SKShapeNode(circleOfRadius: 5)
  //    pointSprite.fillColor = UIColor.redColor()

  func handleDragMove (point: CGPoint, edge: Game.rotation) {
    print("___handleDragMove point is")
    print(point)
    print(edge)
    let currentTile = self.getTileAtPoint(CGPoint(x: point.x + ((edge == Game.rotation.East) ? -32 : edge == Game.rotation.West ? 32 : 0), y: point.y + ((edge == Game.rotation.North) ? -32 : edge == Game.rotation.South ? 32 : 0)) )
    if (currentTile == nil || !currentTile!.isKindOfClass(Tile)) {
      return
    }

    pointSprite.strokeColor = UIColor.redColor()
//    (currentTile as! Tile).highlight((currentTile!.componentForClass(SpriteComponent)?.node.position)!)
    pointSprite.position = CGPoint(x: point.x, y: point.y + 32)
    pointSprite.zPosition = 100000
    pointSprite.removeFromParent()
    Game.sharedInstance.entityManager.node.addChild(pointSprite)



    if (self.anchorTile !== currentTile) {
      
      let currentNodePosition = self.componentForClass(SpriteComponent)?.node.position
      
//      Check  what direction was dragged when tile was changed
      var direction: Game.rotation = Game.rotation.North
      let anchorTileGridPos = self.anchorTile?.componentForClass(PositionComponent)?.gridPosition
      let currentTileGridPos = currentTile!.componentForClass(PositionComponent)?.gridPosition
      if (self.handleDragAxis == Game.axis.Vert){
        if (anchorTileGridPos!.y == currentTileGridPos!.y) {
          return
        }
        if (point.y < self.handleDragPreviousMovePoint.y) {
          if (anchorTileGridPos!.y - 1 != currentTileGridPos!.y) {
            return
          }
          direction = Game.rotation.South
        } else {
          if (anchorTileGridPos!.y + 1 != currentTileGridPos!.y) {
            return
          }
          direction = Game.rotation.North
        }
      } else if (self.handleDragAxis == Game.axis.Hroiz) {
        if (anchorTileGridPos!.x == currentTileGridPos!.x) {
          return
        }
        if (point.x < self.handleDragPreviousMovePoint.x) {
          if (anchorTileGridPos!.x - 1 != currentTileGridPos!.x) {
            return
          }
          direction = Game.rotation.West
        } else {
          if (anchorTileGridPos!.x + 1 != currentTileGridPos!.x) {
            return
          }
          direction = Game.rotation.East
        }
      }
      
      print("direction is")
      print(direction)

      var newSize = CGSizeZero
      
      
      switch self.handleDragEdge {
      case .South:
        newSize = CGSize(width: self.size.width, height: self.size.height + (direction == Game.rotation.South ? 1 : direction == Game.rotation.North ? -1 : 0))
      case .North:
        newSize = CGSize(width: self.size.width, height: self.size.height + (direction == Game.rotation.North ? 1 : direction == Game.rotation.South ? -1 : 0))
      case .East:
        newSize = CGSize(width: self.size.width + (direction == Game.rotation.East ? 1 : direction == Game.rotation.West ? -1 : 0), height: self.size.height)
      case .West:
        newSize = CGSize(width: self.size.width + (direction == Game.rotation.West ? 1 : direction == Game.rotation.East ? -1 : 0), height: self.size.height)
      default:
        print("wat?")
      }
      
      if (newSize.width != 0 && newSize.height != 0) {
        
        if (self.handleDragAxis == Game.axis.Vert) {
          self.componentForClass(SpriteComponent)?.node.position = CGPoint(x: currentNodePosition!.x, y: currentNodePosition!.y + ( direction == Game.rotation.South ? -32 : direction == Game.rotation.North ? 32 : 0))
        } else if (self.handleDragAxis == Game.axis.Hroiz) {
          self.componentForClass(SpriteComponent)?.node.position = CGPoint(x: currentNodePosition!.x + ( (direction == Game.rotation.West) ? -32 : direction == Game.rotation.East ? 32 : 0), y: currentNodePosition!.y)
        }
        
        self.size = newSize
        
        self.anchorTile = currentTile
      }

      self.createResizeHandles()


    }
    
    self.handleDragPreviousMovePoint = point
    
  }
  
  
  func getTileAtPoint(point: CGPoint) -> GKEntity? {
    let nodesAtPoint = Game.sharedInstance.wolrdnode.contentNode.nodesAtPoint(point)
    var tile: GKEntity?
    
    for node in nodesAtPoint {
      guard let entity: GKEntity = node.userData?["entity"] as? GKEntity else {continue}
      
      if (entity.isKindOfClass(Tile)) {
        tile = entity
      }
    }
    
    return tile
  }
  
  func createFloorplanTexture(roomSize: CGSize) -> SKTexture {
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
    return SKView().textureFromNode(blueprintNode)!
  }

  
  static func compileAssets() -> SKSpriteNode {
    
    innerSquare.fillColor = UIColor.blueColor()
    innerSquare.strokeColor = UIColor.init(white: 0, alpha: 0)
    dashedSquare.fillColor = UIColor.blueColor()
    dashedSquare.strokeColor = UIColor.blueColor()
    
    let view = SKView()
    let squareSprite = SKSpriteNode(texture: view.textureFromNode(innerSquare))
    let squareBorderSprite = SKSpriteNode(texture: view.textureFromNode(dashedSquare))
    
    let combinedNode = SKSpriteNode()
    combinedNode.addChild(squareSprite)
    combinedNode.addChild(squareBorderSprite)
    combinedNode.alpha = 0.5
    return combinedNode
  }
  
  func getPointForSize (point: CGPoint) -> CGPoint {
    return CGPoint(x: point.x + (self.size.width % 2 == 0 ? 32 : 0), y: point.y + (self.size.height % 2 == 0 ? 32 : 0))
  }

}
