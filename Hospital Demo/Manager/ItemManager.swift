//
//  ItemManager.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 04/08/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

// The ItemManager class is for creating items of different types based on their required properties and components, and keeping track of each item type
class ItemManager {

  var knownItemTypes: [ItemDefinitions.BaseItems: ItemDefinitions.ItemSpec]

  var knownItem: [ItemDefinitions.BaseItems:[GKEntity]] = [:]


  // Compile the set of known item types given an array of item specs
  init(itemTypes:[ItemDefinitions.BaseItems: ItemDefinitions.ItemSpec]) {

    self.knownItemTypes = itemTypes.reduce(into: [:]) { ( itemTypes: inout [ItemDefinitions.BaseItems: ItemDefinitions.ItemSpec], itemSpec) in
      let (key, value) = itemSpec
      itemTypes[key] = value
    }

    print(self.knownItemTypes)

  }

  func createEntity(itemType: ItemDefinitions.BaseItems) -> GKEntity {
    let entity = GKEntity()
    guard let itemDef = self.knownItemTypes[itemType] else {
      // Should throw error?
      fatalError("you really shouldn't be here - adding an entity type which isn't known to the game")
    }

    let itemSpecComponent = ItemSpecComponent(spec: itemDef)
    entity.addComponent(itemSpecComponent)

    let blueprint = ItemBlueprintComponent(itemSpec: itemSpecComponent)
    entity.addComponent(blueprint)

    entity.addComponent(DraggableSpriteComponent(start: BISPlan.dragStartHandler, move: BISPlan.dragMoveHandler, end: BISPlan.dragEndHandler))

    entity.addComponent(BuildItemComponent())


    let spriteComponent = SpriteComponent(texture: itemDef.texture)
    entity.addComponent(spriteComponent)

    return entity

  }

}
