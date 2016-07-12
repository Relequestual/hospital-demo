//
//  BuildComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 08/07/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//


import SpriteKit
import GameplayKit

class BuildComponent: GKComponent {

  func planAtPoint(position: CGPoint) {

    guard let entity = self.entity else {
      // WOAH there
      return
    }

    // Check can place object at location
    guard entity.componentForClass(BlueprintComponent)!.canPlanAtPoint(position) else {
      // Nope
      return
    }

    var area = (entity.componentForClass(BlueprintComponent)?.area)!
    var pous = (entity.componentForClass(BlueprintComponent)?.pous)!


    Game.sharedInstance.entityManager.node.enumerateChildNodesWithName("planned_object", usingBlock: { (node, stop) -> Void in
      node.removeFromParent()
    });

    let positionComponent = PositionComponent(gridPosition: CGPoint(x: position.x, y: position.y))
    entity.addComponent(positionComponent)

    let texture = createPlannedTexture()
    let texturePOU = createPlannedPOUTexture()

    for blueprint in area {
      let x = Int(positionComponent.gridPosition.x) + blueprint[0]
      let y = Int(positionComponent.gridPosition.y) + blueprint[1]

      guard let tile = Game.sharedInstance.tilesAtCoords[x]![y] else {
        // No tile at this position
        return
      }
      let node = SKSpriteNode(texture: texture)
      node.alpha = 0.6
      node.position = (tile.componentForClass(PositionComponent)?.spritePosition)!

      node.zPosition = 10
      node.name = "planned_object"
      Game.sharedInstance.entityManager.node.addChild(node)

      tile.isBuildingOn = true

      if (tile.blocked) {
        self.drawBlockedNode(node.position)
      }

      tile.isBuildingOn = true
    }

    for blueprint in pous {
      let x = Int(positionComponent.gridPosition.x) + blueprint[0]
      let y = Int(positionComponent.gridPosition.y) + blueprint[1]

      guard let tile = Game.sharedInstance.tilesAtCoords[x]![y] else {
        // No tile at this position
        return
      }
      let node = SKSpriteNode(texture: texturePOU)
      node.alpha = 0.4
      node.position = (tile.componentForClass(PositionComponent)?.spritePosition)!

      node.zPosition = 10
      node.name = "planned_object"
      Game.sharedInstance.entityManager.node.addChild(node)

      tile.isBuildingOn = true

      if (tile.blocked) {
        self.drawBlockedNode(node.position)
      }
    }
    Game.sharedInstance.plannedBuildingObject = entity
  }

  func build() {
    guard let entity = self.entity else {
      // WOAH there
      return
    }

    let area = (entity.componentForClass(BlueprintComponent)?.area)!
    let pous = (entity.componentForClass(BlueprintComponent)?.pous)!

    let positionComponent = entity.componentForClass(PositionComponent)!

    for blueprint in area {
      let x = Int(positionComponent.gridPosition.x) + blueprint[0]
      let y = Int(positionComponent.gridPosition.y) + blueprint[1]

      guard let tile = Game.sharedInstance.tilesAtCoords[x]![y] else {
        // No tile at this position
        return
      }
      tile.blocked = true
    }

  }

  //  Optimisation of these would require moving all generated textures to a graphics class.
  //  And checking that it would actually be worth it!

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

  func drawBlockedNode(position: CGPoint) -> Void {
    let blockedTexture = createBlockedTexture()
    let blockedNode = SKSpriteNode(texture: blockedTexture)

    blockedNode.alpha = 0.8
    blockedNode.position = position
    blockedNode.name = "planned_object"
    blockedNode.zPosition = 8
    Game.sharedInstance.entityManager.node.addChild(blockedNode)
  }


  
  
}