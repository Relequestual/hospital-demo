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
      self.removeComponentForClass(SpriteComponent)
      self.addComponent(SpriteComponent(texture: self.createFloorplanTexture(size)))
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
        print("end drag room")
    }))

    self.addComponent(SpriteComponent(texture: self.createFloorplanTexture(self.size)))
    self.componentForClass(SpriteComponent)?.node.name = "planning_room_blueprint"
    
    self.componentForClass(SpriteComponent)!.addToNodeKey()
  }
  
  func dragStartHandler(point:CGPoint) {
    let spritePos = self.componentForClass(SpriteComponent)?.node.position
    self.dragOffset = CGPoint(x: spritePos!.x - point.x, y: spritePos!.y - point.y)
    
    var tile = getTileAtNode(CGPoint(x: spritePos!.x - tileOffset.x, y: spritePos!.y - tileOffset.y))
    self.anchorTile = tile
  }
  
  func dragMoveHandler(point:CGPoint) {
    let spritePos = self.componentForClass(SpriteComponent)?.node.position
    
    var tile = getTileAtNode(CGPoint(x: point.x + dragOffset!.x - tileOffset.x, y: point.y + dragOffset!.y - tileOffset.y))
    print(self.anchorTile)
    print(tile)
    if (self.anchorTile !== tile) {
      self.anchorTile = tile
      let tilePosition = tile?.componentForClass(PositionComponent)?.spritePosition
      self.componentForClass(SpriteComponent)?.node.position = CGPoint(x: tilePosition!.x + self.tileOffset.x, y: tilePosition!.y + self.tileOffset.y)
    }
    
  }
  
  
  func getTileAtNode(point: CGPoint) -> GKEntity? {
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

}
