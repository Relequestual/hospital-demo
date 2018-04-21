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
  static let menuItems: Array<GKEntity.Type> = [ReceptionDesk.self]

  var menuItems: Array<GKEntity.Type>

  var graphics: [String: SKSpriteNode] = [:]

  init(menuItems: Array<GKEntity.Type> = ItemMenu.menuItems) {
    self.menuItems = menuItems

    for itemType in self.menuItems {
      let itemEntity = itemType.init()

      let graphicsNode = itemEntity.component(ofType: SpriteComponent.self)?.node

      graphics.updateValue(graphicsNode ?? SKSpriteNode(), forKey: String(describing: itemType))
    }

    print(graphics)
  }
}
