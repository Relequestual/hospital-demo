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

    print("removing planned_object nodes")
    Game.sharedInstance.entityManager.node.enumerateChildNodesWithName("planned_object", usingBlock: { (node, stop) -> Void in
      node.removeFromParent()
    });

    // Check can place object at location
    guard entity.componentForClass(BlueprintComponent)!.canPlanAtPoint(position) else {
      // Nope
      return
    }
    Game.sharedInstance.canAutoScroll = true

    var area = (entity.componentForClass(BlueprintComponent)?.area)!
    var pous = (entity.componentForClass(BlueprintComponent)?.pous)!


    let positionComponent = PositionComponent(gridPosition: CGPoint(x: position.x, y: position.y))
    entity.addComponent(positionComponent)

    for blueprint in area {
      let x = Int(positionComponent.gridPosition.x) + blueprint[0]
      let y = Int(positionComponent.gridPosition.y) + blueprint[1]

      guard let tile = Game.sharedInstance.tilesAtCoords[x]![y] else {
        // No tile at this position
        return
      }
      let node = SKSpriteNode(texture: createPlannedTexture(tile.unbuildable))
      node.alpha = 0.6
      node.position = (tile.componentForClass(PositionComponent)?.spritePosition)!

      node.zPosition = CGFloat(ZPositionManager.WorldLayer.interaction.zpos)
      node.name = "planned_object"


      Game.sharedInstance.entityManager.node.addChild(node)
      tile.isBuildingOn = true

    }

    for blueprint in pous {
      let x = Int(positionComponent.gridPosition.x) + blueprint[0]
      let y = Int(positionComponent.gridPosition.y) + blueprint[1]

//      This is how we get the spriteposition from grid position!
      guard let tile = Game.sharedInstance.tilesAtCoords[x]![y] else {
        // No tile at this position
        return
      }
      let node = SKSpriteNode(texture: createPlannedPOUTexture(tile.unbuildable))
      node.alpha = 0.4
      node.position = (tile.componentForClass(PositionComponent)?.spritePosition)!

      node.zPosition = CGFloat(ZPositionManager.WorldLayer.interaction.zpos)
      node.name = "planned_object"
      Game.sharedInstance.entityManager.node.addChild(node)

    }
    Game.sharedInstance.plannedBuildingObject = entity
    print("entity planned!")
    print(Game.sharedInstance.plannedBuildingObject)
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
      tile.isBuildingOn = false
      print("blocking tile")
    }
    for blueprint in pous {
      let x = Int(positionComponent.gridPosition.x) + blueprint[0]
      let y = Int(positionComponent.gridPosition.y) + blueprint[1]
      
      guard let tile = Game.sharedInstance.tilesAtCoords[x]![y] else {
        // No tile at this position
        return
      }
      
      tile.unbuildable = true
      tile.isBuildingOn = false
      
    }

  }

  //  Optimisation of these would require moving all generated textures to a graphics class.
  //  And checking that it would actually be worth it!

  func createPlannedTexture(unbuildable:Bool = false) -> SKTexture {
    let node = SKShapeNode(rectOfSize: CGSize(width: 32, height: 32))
    node.lineWidth = 0
    node.fillColor = unbuildable ? UIColor.redColor() : UIColor.cyanColor()
    return SKView().textureFromNode(node)!
  }

  func createPlannedPOUTexture(unbuildable:Bool = false) -> SKTexture {
    let node = SKShapeNode(circleOfRadius: 24)
    node.lineWidth = 0
    node.fillColor = unbuildable ? UIColor.redColor() : UIColor.orangeColor()
    return SKView().textureFromNode(node)!
  }

}