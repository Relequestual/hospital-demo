//
//  BuildItemComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 08/07/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import GameplayKit
import SpriteKit

class BuildItemComponent: GKComponent {
  func planAtPoint(_ position: CGPoint) {
    guard let entity = self.entity else { return }

    print("removing planned_object nodes")
    Game.sharedInstance.entityManager.node.enumerateChildNodes(withName: "planned_object", using: { (node, _) -> Void in
      node.removeFromParent()
    })

    // Check can place object at location
    guard entity.component(ofType: ItemBlueprintComponent.self)!.canPlanAtPoint(position) else {
      // Nope
      return
    }

    let area = (entity.component(ofType: ItemSpecComponent.self)?.area)!
    let pous = (entity.component(ofType: ItemSpecComponent.self)?.pous)!

    let positionComponent = PositionComponent(gridPosition: CGPoint(x: position.x, y: position.y))
    entity.addComponent(positionComponent)

    for blueprint in area {
      let x = Int(positionComponent.gridPosition!.x + blueprint.x)
      let y = Int(positionComponent.gridPosition!.y + blueprint.y)

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
      let x = Int(positionComponent.gridPosition!.x + blueprint.x)
      let y = Int(positionComponent.gridPosition!.y + blueprint.y)

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
    print(Game.sharedInstance.buildItemStateMachine.itemBuilding as Any)
  }

  func build() {
    guard let entity = self.entity else { return }

    let area = (entity.component(ofType: ItemSpecComponent.self)?.area)!
    let pous = (entity.component(ofType: ItemSpecComponent.self)?.pous)!

    let positionComponent = entity.component(ofType: PositionComponent.self)!

    for blueprint in area {
      let x = Int(positionComponent.gridPosition!.x + blueprint.x)
      let y = Int(positionComponent.gridPosition!.y + blueprint.y)

      guard let tile = Game.sharedInstance.tilesAtCoords[x]![y] else {
        // No tile at this position
        return
      }
      tile.blocked = true
      tile.isBuildingOn = false
      print("blocking tile")
    }
    for blueprint in pous {
      let x = Int(positionComponent.gridPosition!.x + blueprint.x)
      let y = Int(positionComponent.gridPosition!.y + blueprint.y)

      guard let tile = Game.sharedInstance.tilesAtCoords[x]![y] else {
        // No tile at this position
        return
      }

      tile.unbuildable = true
      tile.isBuildingOn = false
    }
    self.entity?.removeComponent(ofType: DraggableSpriteComponent.self)
    Game.sharedInstance.gameStateMachine.enter(GSGeneral.self)
  }

  //  Optimisation of these would require moving all generated textures to a graphics class.
  //  And checking that it would actually be worth it!

  func createPlannedTexture(_ unbuildable: Bool = false) -> SKTexture {
    let node = SKShapeNode(rectOf: CGSize(width: 32, height: 32))
    node.lineWidth = 0
    node.fillColor = unbuildable ? UIColor.red : UIColor.cyan
    return SKView().texture(from: node)!
  }

  func createPlannedPOUTexture(_ unbuildable: Bool = false) -> SKTexture {
    let node = SKShapeNode(circleOfRadius: 24)
    node.lineWidth = 0
    node.fillColor = unbuildable ? UIColor.red : UIColor.orange
    return SKView().texture(from: node)!
  }
}
