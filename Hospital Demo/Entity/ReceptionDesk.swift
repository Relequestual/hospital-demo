//
//  ReceptionDesk.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 08/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import SpriteKit
import GameplayKit

class ReceptionDesk: GKEntity {

  var area = [[0,0], [1,0]]
  
  var pous = [[0,-1], [1,-1]]

//  var position: CGPoint?
  
  override init() {
    super.init()

    let blueprint = BlueprintComponent(area: area, pous: pous, pf: { position in
      self.planAtPoint(position)
    })
    self.addComponent(blueprint)
//    Add position component somewhere?

    let draggableComponent = DraggableSpriteComponent(
      start: self.dragStartHandler,
      move: self.dragMoveHandler,
      end: self.dragEndHandler
    )
    self.addComponent(draggableComponent)
    print(self.componentForClass(DraggableSpriteComponent))
    
    let graphicNode = SKShapeNode(rectOfSize: CGSize(width:128, height:64), cornerRadius: 0.2)
    graphicNode.fillColor = UIColor.whiteColor()
//    graphicNode.alpha = 0.6
    let view = SKView()
    let graphicTexture: SKTexture = view.textureFromNode(graphicNode)!
    
    let spriteComponent = SpriteComponent(texture: graphicTexture)
    addComponent(spriteComponent)
    spriteComponent.addToNodeKey()
    
  }

  func dragStartHandler() {
    print("RD Start drag")
  }
  
  func dragMoveHandler(point: CGPoint) {
    print("RD Move drag")
    
//    self.componentForClass(SpriteComponent)?.node.position = point
    let nodesAtPoint = Game.sharedInstance.wolrdnode.contentNode.nodesAtPoint(point)
    
    for node in nodesAtPoint {
      guard let entity: GKEntity = node.userData?["entity"] as? GKEntity else {continue}
      
      if (entity.isKindOfClass(Tile)) {
        self.componentForClass(BlueprintComponent)?.planFunctionCall((entity.componentForClass(PositionComponent)?.gridPosition)!)
      }

    }
  }
  
  func dragEndHandler() {
    print("RD End drag")
    
  }
  
  func planAtPoint(position: CGPoint){
    
    // Check can place object at location
    guard self.componentForClass(BlueprintComponent)!.canPlanAtPoint(position) else {
      // Nope
      return
    }
    
    self.area = (self.componentForClass(BlueprintComponent)?.area)!
    self.pous = (self.componentForClass(BlueprintComponent)?.pous)!
    
    
    Game.sharedInstance.entityManager.node.enumerateChildNodesWithName("planned_object", usingBlock: { (node, stop) -> Void in
      node.removeFromParent()
    });

    let positionComponent = PositionComponent(gridPosition: CGPoint(x: position.x, y: position.y))
    addComponent(positionComponent)

    let texture = createPlannedTexture()
    let texturePOU = createPlannedPOUTexture()

    for blueprint in self.area {
      let x = Int(positionComponent.gridPosition.x) + blueprint[0]
      let y = Int(positionComponent.gridPosition.y) + blueprint[1]

      let tile = Game.sharedInstance.tilesAtCoords[x]![y]
      let node = SKSpriteNode(texture: texture)
      node.alpha = 0.6
      node.position = (tile?.componentForClass(PositionComponent)?.spritePosition)!
      
      node.zPosition = 10
      node.name = "planned_object"
      Game.sharedInstance.entityManager.node.addChild(node)
      
      tile?.isBuildingOn = true
      
      if !(tile?.stateMachine.currentState is TileTileState) {
        setBlockedNode(node.position)
      }
      
      tile?.isBuildingOn = true
    }
    
    for blueprint in self.pous {
      let x = Int(positionComponent.gridPosition.x) + blueprint[0]
      let y = Int(positionComponent.gridPosition.y) + blueprint[1]
      
      let tile = Game.sharedInstance.tilesAtCoords[x]![y]
      let node = SKSpriteNode(texture: texturePOU)
      node.alpha = 0.4
      node.position = (tile?.componentForClass(PositionComponent)?.spritePosition)!
      
      node.zPosition = 10
      node.name = "planned_object"
      Game.sharedInstance.entityManager.node.addChild(node)
      
      tile?.isBuildingOn = true
      
      if !(tile?.stateMachine.currentState is TileTileState) {
        setBlockedNode(node.position)
      }
    }
    Game.sharedInstance.plannedBuildingObject = self
  }
  
  func setBlockedNode(position: CGPoint) -> Void {
    let blockedTexture = createBlockedTexture()
    let blockedNode = SKSpriteNode(texture: blockedTexture)
    
    blockedNode.alpha = 0.8
    blockedNode.position = position
    blockedNode.name = "planned_object"
    blockedNode.zPosition = 8
    Game.sharedInstance.entityManager.node.addChild(blockedNode)
  }

  func createPlannedTexture() -> SKTexture {
    let node = SKShapeNode(rectOfSize: CGSize(width: 32, height: 32))
    node.lineWidth = 0
    node.fillColor = UIColor.cyanColor()
    return SKView().textureFromNode(node)!
  }
  
  func createPlannedPOUTexture() -> SKTexture {
    let node = SKShapeNode(circleOfRadius: 24)
    node.lineWidth = 0
    node.fillColor = UIColor.orangeColor()
    return SKView().textureFromNode(node)!
  }
  
  func createBlockedTexture() -> SKTexture {
    let node = SKShapeNode(rectOfSize: CGSize(width: 60, height: 60))
    node.lineWidth = 0
    node.fillColor = UIColor.redColor()
    return SKView().textureFromNode(node)!
  }

}

