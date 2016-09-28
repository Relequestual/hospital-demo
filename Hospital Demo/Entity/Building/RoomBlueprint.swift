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
      self.anchorTile = tile
      let tilePosition = tile?.componentForClass(PositionComponent)?.spritePosition
//      Later, make genertic north south east west actions... maybe
      let moveAction = SKAction.moveTo(self.getPointForSize(tilePosition!), duration: NSTimeInterval(0.1))
      moveAction.timingMode = SKActionTimingMode.EaseInEaseOut
      self.componentForClass(SpriteComponent)?.node.runAction(moveAction, completion: {})
    }
    
  }
  
  func createResizeHandles() {
    let spritePosition = CGPointZero
    let edgeYT = spritePosition.y + size.height * 64 / 2
    let edgeYB = spritePosition.y - size.height * 64 / 2
    let edgeXL = spritePosition.x - size.width * 64 / 2
    let edgeXR = spritePosition.x + size.width * 64 / 2
    
    print(edgeXL)
    print(edgeXR)
    print(edgeYT)
    print(edgeYB)
    
    Game.sharedInstance.entityManager.node.enumerateChildNodesWithName("planning_room_blueprint_handles", usingBlock: { (node, stop) -> Void in
        node.removeFromParent()
    });

    
    for x in edgeXL.stride(to:edgeXR, by: 64) {
      let texture_vert = SKTexture(imageNamed: "Graphics/drag_vert")
      let vertButton = Button(texture: texture_vert, touch_start_f: { (point: CGPoint) in
          self.handleDragStart(point, axis: Game.axis.Vert)
          print("handle drag start")
        }, touch_move_f: { (point) in
          print("handle drag move")
          self.handleDragMove(point)
        }, touch_end_f: { (point) in
//          handleDragend(point: point)
      })
      let buttonVertSprite = vertButton.componentForClass(SpriteComponent)!.node
      
      buttonVertSprite.zPosition = (self.componentForClass(SpriteComponent)?.node.zPosition)! + 1
      buttonVertSprite.setScale(0.5)
      buttonVertSprite.name = "planning_room_blueprint_handles"
      buttonVertSprite.position = CGPoint(x: x + 32, y: edgeYB)
      vertButton.componentForClass(SpriteComponent)?.addToNodeKey()
      self.componentForClass(SpriteComponent)?.node.addChild((vertButton.componentForClass(SpriteComponent)?.node)!)
//      Game.sharedInstance.entityManager.add(vertButton, layer: ZPositionManager.WorldLayer.interaction)
    }
  }
  

//  Not really happy about this, but...
  var handleDragAxis: Game.axis = Game.axis.Hroiz
  var handleDragXSign: Game.numericalSignage = Game.numericalSignage.positive
  var handleDragYSign: Game.numericalSignage = Game.numericalSignage.positive
  var handleDragEdge: Game.rotation = Game.rotation.North
  
  func handleDragStart (point: CGPoint, axis: Game.axis) {
    self.handleDragAxis = axis
//    Determine edge is being dragged
    let centerOfRoom = self.componentForClass(SpriteComponent)?.node.position
    self.handleDragXSign = (point.x < centerOfRoom!.x) ? Game.numericalSignage.negative : Game.numericalSignage.positive
    self.handleDragYSign = (point.y < centerOfRoom!.y) ? Game.numericalSignage.negative : Game.numericalSignage.positive
    
    switch (self.handleDragAxis, self.handleDragXSign, self.handleDragYSign) {
    case (Game.axis.Vert, _, Game.numericalSignage.negative):
      self.handleDragEdge = Game.rotation.South
      self.anchorTile = self.getTileAtPoint(CGPoint(x: point.x, y: point.y - 32))
    case (Game.axis.Vert, _, Game.numericalSignage.positive):
      self.handleDragEdge = Game.rotation.North
      self.anchorTile = self.getTileAtPoint(CGPoint(x: point.x, y: point.y + 32))
    case (Game.axis.Hroiz, Game.numericalSignage.negative, _):
      self.handleDragEdge = Game.rotation.East
      self.anchorTile = self.getTileAtPoint(CGPoint(x: point.x - 32, y: point.y))
    case (Game.axis.Hroiz, Game.numericalSignage.positive, _):
      self.handleDragEdge = Game.rotation.West
      self.anchorTile = self.getTileAtPoint(CGPoint(x: point.x + 32, y: point.y))
    default:
      print("huh")
    }

  }
  
  let pointSprite = SKShapeNode(circleOfRadius: 5)
  //    pointSprite.fillColor = UIColor.redColor()

  func handleDragMove (point: CGPoint) {
    let currentTile = self.getTileAtPoint(CGPoint(x: point.x, y: point.y + 32))
    pointSprite.strokeColor = UIColor.redColor()
    pointSprite.position = CGPoint(x: point.x, y: point.y + 32)
    pointSprite.zPosition = 100000
    pointSprite.removeFromParent()
    Game.sharedInstance.wolrdnode.addChild(pointSprite)




//    print(point)
//    print("-=-= grid position of current tile =-=-")
//    print(currentTile?.componentForClass(PositionComponent)?.gridPosition)
    if (self.anchorTile !== currentTile) {
//      Check  what direction was dragged when tile was changed
      var direction: Game.rotation = Game.rotation.North
      if (self.handleDragAxis == Game.axis.Vert){
        if (self.anchorTile?.componentForClass(PositionComponent)?.gridPosition.y < currentTile!.componentForClass(PositionComponent)?.gridPosition.y) {
          direction = Game.rotation.South
        } else {
          direction = Game.rotation.North
        }
      }
      print("direction is")
      print(direction)

      let currentNodePosition = self.componentForClass(SpriteComponent)?.node.position
      switch self.handleDragEdge {
      case .South:
        self.size = CGSize(width: self.size.width, height: self.size.height + (direction == Game.rotation.South ? 1 : -1))
        self.componentForClass(SpriteComponent)?.node.position = CGPoint(x: currentNodePosition!.x, y: currentNodePosition!.y + ( (direction == Game.rotation.South) ? -32 : 32))
      case .North:
        self.size = CGSize(width: self.size.width, height: self.size.height + (direction == Game.rotation.North ? 1 : -1))
        self.componentForClass(SpriteComponent)?.node.position = CGPoint(x: currentNodePosition!.x, y: currentNodePosition!.y - ( (direction == Game.rotation.North) ? 32 : -32))
      default:
        print("wat?")
      }

      self.createResizeHandles()

      print(self.size)
      self.anchorTile = currentTile
//      self
    }
    
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
