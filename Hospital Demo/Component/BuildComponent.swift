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

  func planAtPoint(_ position: CGPoint) {

    guard let entity = self.entity else {
      // WOAH there
      return
    }

    print("removing planned_object nodes")
    Game.sharedInstance.entityManager.node.enumerateChildNodes(withName: "planned_object", using: { (node, stop) -> Void in
      node.removeFromParent()
    });

    // Check can place object at location
    guard entity.component(ofType: BlueprintComponent.self)!.canPlanAtPoint(position) else {
      // Nope
      return
    }
    Game.sharedInstance.canAutoScroll = true

    let area = (entity.component(ofType: BlueprintComponent.self)?.area)!
    let pous = (entity.component(ofType: BlueprintComponent.self)?.pous)!


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
      node.position = (tile.component(ofType: PositionComponent.self)?.spritePosition.self)!

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
      node.position = (tile.component(ofType: PositionComponent.self)?.spritePosition.self)!

      node.zPosition = CGFloat(ZPositionManager.WorldLayer.interaction.zpos)
      node.name = "planned_object"
      Game.sharedInstance.entityManager.node.addChild(node)

    }
    Game.sharedInstance.buildItemStateMachine.itemBuilding = entity
    print("entity planned!")
    print(Game.sharedInstance.buildItemStateMachine.itemBuilding)
  }

  func build() {
    guard let entity = self.entity else {
      // WOAH there
      return
    }

    let area = (entity.component(ofType: BlueprintComponent.self)?.area)!
    let pous = (entity.component(ofType: BlueprintComponent.self)?.pous)!

    let positionComponent = entity.component(ofType: PositionComponent.self)!

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
    Game.sharedInstance.gameStateMachine.enter(GSGeneral)
  }

  //  Optimisation of these would require moving all generated textures to a graphics class.
  //  And checking that it would actually be worth it!

  func createPlannedTexture(_ unbuildable:Bool = false) -> SKTexture {
    let node = SKShapeNode(rectOf: CGSize(width: 32, height: 32))
    node.lineWidth = 0
    node.fillColor = unbuildable ? UIColor.red : UIColor.cyan
    return SKView().texture(from: node)!
  }

  func createPlannedPOUTexture(_ unbuildable:Bool = false) -> SKTexture {
    let node = SKShapeNode(circleOfRadius: 24)
    node.lineWidth = 0
    node.fillColor = unbuildable ? UIColor.red : UIColor.orange
    return SKView().texture(from: node)!
  }

}
