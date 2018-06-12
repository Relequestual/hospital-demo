//
//  ItemMenu.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 19/04/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

class ItemMenu: MenuProtocol {
  var menuNode: SKSpriteNode = Menu.makeMenuNode()

  var graphics: [String: SKTexture]
  var menuItems: [Menu.menuItem] = []

  init(menuItems: [GKEntity.Type] = [ReceptionDesk.self, ReceptionDesk.self, ReceptionDesk.self, ReceptionDesk.self]) {
    print("ItemMenu#init")

    graphics = menuItems.reduce(into: [:], { graphics, itemType in
      let item = itemType.init()
      let node = item.component(ofType: SpriteComponent.self)?.node ?? SKSpriteNode()
      let texture = SKView.init().texture(from: node)!
//      texture = Menu.resizeToMax(texture: texture)

      graphics[String(describing: itemType)] = texture
    })

    self.createMenuItems()
    Menu.layoutItems(menu: self)
  }

  func createMenuItems() {

    self.graphics.forEach { (key: String, texture: SKTexture) in
      let button = Button(texture: texture, touch_f: { (Button) in
        print("menu button!!!")
        Game.sharedInstance.gameStateMachine.enter(GSBuildItem.self)
        Game.sharedInstance.buildItemStateMachine.enter(BISPlan.self)
        Game.sharedInstance.placingObjectsQueue.append(ReceptionDesk.self)
        Game.sharedInstance.menuManager?.openMenu!.remove()
      })
      let item = Menu.menuItem(button: button, color: UIColor.blue)
      self.menuItems.append(item)
    }
  }

}
