//
//  EntityManager.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 26/12/2015.
//  Copyright © 2015 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class EntityManager {
  var entities = Set<GKEntity>()
  let node: SKNode
  var toRemove = Set<GKEntity>()

  lazy var componentSystems: [GKComponentSystem] = {
    //        When there are moveable entities, look at this again.
    //        let moveSystem = GKComponentSystem(componentClass: MoveComponent.self)
    []
  }()

  init(node: SKNode) {
    self.node = node
  }

  func displayEntity(_ entity: GKEntity, _ layer: ZPositionManager.WorldLayer) {
    if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
      spriteNode.zPosition = CGFloat(layer.zpos)
      if (entity.component(ofType: PositionComponent.self)?.spritePosition) != nil {
        spriteNode.position = entity.component(ofType: PositionComponent.self)!.spritePosition!
      }
      //      spriteNode.zPosition = 1
      node.addChild(spriteNode)
    }
  }

  func add(_ entity: GKEntity, layer: ZPositionManager.WorldLayer) {
    print("adding entity")
    entities.insert(entity)
    if (entity.component(ofType: RoomSpecComponent.self) != nil) {
      Game.sharedInstance.roomManager!.add(entity)
    }

    displayEntity(entity, layer)

    for componentSystem in componentSystems {
      componentSystem.addComponent(foundIn: entity)
    }
  }

  func remove(_ entity: GKEntity) {
    if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
      spriteNode.removeFromParent()
    }

    entities.remove(entity)
    toRemove.insert(entity)
  }

  func update(_ deltaTime: CFTimeInterval) {
    for componentSystem in componentSystems {
      componentSystem.update(deltaTime: deltaTime)
    }

    for curRemove in toRemove {
      for componentSystem in componentSystems {
        componentSystem.removeComponent(foundIn: curRemove)
      }
    }
    toRemove.removeAll()
  }

  //    func moveComponentsForTeam(team: Team) -> [MoveComponent] {
  //        let entities = entitiesForTeam(team)
  //        var moveComponents = [MoveComponent]()
  //        for entity in entities {
  //            if let moveComponent = entity.componentForClass(MoveComponent.self) {
  //                moveComponents.append(moveComponent)
  //            }
  //        }
  //        return moveComponents
  //    }
}
