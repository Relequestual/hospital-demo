//
//  PlaceObjectToolbar.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 10/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import HLSpriteKit

struct ToolbarOption {
  let tag: String
  let node: SKSpriteNode
  let handler: () -> Void
}

enum BlueprintMovementDirection {
  case Up, Down, Left, Right, None
  
  func coordinatesForDirection(currentCoordinates: CGPoint) -> CGPoint {
    switch self {
    case .Up:
      return CGPoint(x: currentCoordinates.x, y: currentCoordinates.y + 1)
    case .Down:
      return CGPoint(x: currentCoordinates.x, y: currentCoordinates.y - 1)
    case .Left:
      return CGPoint(x: currentCoordinates.x - 1, y: currentCoordinates.y)
    case .Right:
      return CGPoint(x: currentCoordinates.x + 1, y: currentCoordinates.y)
    case .None:
      return currentCoordinates
    }
  }
}

class PlaceObjectToolbar: HLToolbarNode {

  static var arrowTexture: SKTexture {
    let arrow = CGPathCreateMutable()
    
    CGPathAddLines(arrow, nil, [
      CGPoint(x: 10, y: 0),
      CGPoint(x: 10, y: 20),
      CGPoint(x: 0, y: 20),
      CGPoint(x: 15, y: 35),
      CGPoint(x: 30, y: 20),
      CGPoint(x: 20, y: 20),
      CGPoint(x: 20, y: 0),
      CGPoint(x: 10, y: 0),
      ], 8)
    
    let shape = SKShapeNode()
    shape.path = arrow
    let view = SKView()
    let arrowTexture: SKTexture = view.textureFromNode(shape)!
    
    return arrowTexture
    
  }
  
  static let defaultNodeSize = CGSize(width: 20, height: 20)
  
  static let rotate90 = SKAction.rotateByAngle(CGFloat(GLKMathDegreesToRadians(90.0)), duration: 0)
  static let rotate180 = SKAction.rotateByAngle(CGFloat(GLKMathDegreesToRadians(180.0)), duration: 0)
  static let rotate270 = SKAction.rotateByAngle(CGFloat(GLKMathDegreesToRadians(270.0)), duration: 0)
  
  static var sharedInstance: PlaceObjectToolbar?
  
  var options = [ToolbarOption]()
  
  init(size: CGSize = GameToolbar.defaultNodeSize, baseScene: BaseScene) {
    self.options = [ToolbarOption]()
    super.init()
    
    // If we don't have a shared instance yet, make this the shared instance
    if PlaceObjectToolbar.sharedInstance == nil {
      PlaceObjectToolbar.sharedInstance = self
    }
      
    let topPoint = baseScene.view?.bounds.height
    self.anchorPoint = CGPoint(x: 0, y: 1)
    self.size = size
    self.position = CGPoint(x: 0, y: topPoint!)
    self.zPosition = 999
    
    
    let arrowTexture = PlaceObjectToolbar.arrowTexture
    
    let leftArrowNode = makeNode(arrowTexture)
    leftArrowNode.runAction(PlaceObjectToolbar.rotate90)
    addOption("left", node: leftArrowNode) { _ in
      PlaceObjectToolbar.movePlannedObject(.Left)
    }
    let upArrowNode = makeNode(arrowTexture)
    addOption("up", node: upArrowNode) { _ in
      PlaceObjectToolbar.movePlannedObject(.Up)
    }
    let downArrowNode = makeNode(arrowTexture)
    downArrowNode.runAction(PlaceObjectToolbar.rotate180)
    addOption("down", node: downArrowNode) { _ in
      PlaceObjectToolbar.movePlannedObject(.Down)
    }
    let rightArrowNode = makeNode(arrowTexture)
    rightArrowNode.runAction(PlaceObjectToolbar.rotate270)
    addOption("right", node: rightArrowNode) { _ in
      PlaceObjectToolbar.movePlannedObject(.Right)
    }

    if let rotateTexture = SKView().textureFromNode(SKShapeNode(ellipseOfSize: size)) {
      let rotateNode = makeNode(rotateTexture)
      addOption("rotate", node: rotateNode) { _ in
        PlaceObjectToolbar.rotatePlannedObject()
      }
    }
  
    let nodes = options.reduce([SKSpriteNode]()) { nodes, option in
      return nodes + [option.node]
    }
    
    let tags = options.reduce([String]()) { tags, option in
      return tags + [option.tag]
    }
    self.setTools(nodes, tags: tags, animation:HLToolbarNodeAnimation.SlideUp)
    
    self.toolTappedBlock = { tag in
      baseScene.HL_showMessage("[PlaceObjectToolbar] tapped \(tag)")
      let optionsForTag = self.options.filter { $0.tag == tag }
      optionsForTag.forEach { $0.handler() }
    }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func makeNode(texture: SKTexture, size: CGSize = PlaceObjectToolbar.defaultNodeSize) -> SKSpriteNode {
    return SKSpriteNode(texture: texture, size: size)
  }
  
  private func addOption(tag: String, node: SKSpriteNode, handler: () -> Void) {
    let option = ToolbarOption(tag: tag, node: node, handler: handler)
    options.append(option)
  }
  
  private func nodeForTag(tag: String) -> SKSpriteNode? {
    let nodes = options.filter { $0.tag == tag }
    if nodes.count < 1 { return nil }
    return nodes[0].node
  }

  class func rotateTouch() {
    rotatePlannedObject()
  }

  class func movePlannedObject(direction: BlueprintMovementDirection) {

    guard let thisObject = Game.sharedInstance.plannedBuildingObject else {
      return
    }
    
    for tile in Game.sharedInstance.plannedBuildingTiles {
      tile.isBuildingOn = false
    }
    
    guard let oldPosition = thisObject.componentForClass(PositionComponent)?.gridPosition else { return }
    let newPosition = direction.coordinatesForDirection(oldPosition)
    
    guard thisObject.componentForClass(BlueprintComponent)!.canPlanAtPoint(newPosition) else {
      return
    }
    
    
    thisObject.componentForClass(PositionComponent)?.gridPosition = newPosition
    thisObject.componentForClass(BlueprintComponent)?.planFunctionCall(newPosition)
    
  }
  
  class func rotatePlannedObject() {
    let thisObject = Game.sharedInstance.plannedBuildingObject
    let blueprintComponent = thisObject?.componentForClass(BlueprintComponent)
    blueprintComponent?.rotate((blueprintComponent?.baring)!)
    
    PlaceObjectToolbar.movePlannedObject(.None)
  }
}