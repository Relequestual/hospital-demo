//
//  ItemMenu.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 19/04/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

class ItemMenu {
  let graphics: [String: SKSpriteNode]

  init(menuItems: [GKEntity.Type] = [ReceptionDesk.self]) {
    print("ItemMenu#init")

    graphics = menuItems.reduce(into: [:], { graphics, itemType in
      let item = itemType.init()
      let node = item.component(ofType: SpriteComponent.self)?.node ?? SKSpriteNode()
      graphics[String(describing: itemType)] = node
    })

    print(graphics)
  }
}
