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
  var menuNode: SKSpriteNode = Menu.makeMenuNode(CGSize(width: Game.sharedInstance.mainView!.bounds.width, height: Game.sharedInstance.mainView!.bounds.height / 2))

  var graphics: [String: SKTexture]
  var menuItems: [Menu.menuItem] = []

  init(menuItems: [ItemDefinitions.BaseItems] = [ItemDefinitions.BaseItems.ReceptionDesk, ItemDefinitions.BaseItems.ReceptionDesk]) {
    print("ItemMen#init")

    self.menuNode.anchorPoint = CGPoint(x: 0, y: 1)
    let size = CGSize(width: Game.sharedInstance.mainView!.bounds.width, height: Game.sharedInstance.mainView!.bounds.height)
//    self.menuNode.position = CGPoint(x: 0 - size.width / 2, y: 0 + size.height / 2)
    self.menuNode.position = CGPoint(x: 0 - size.width / 2, y: 0)

    let view = SKView.init()
    graphics = menuItems.reduce(into: [:], { graphics, itemType in
      let item = Game.sharedInstance.itemManager!.buildItem(itemType: itemType)
      let node = item.component(ofType: SpriteComponent.self)?.node ?? SKSpriteNode()
      let texture = view.texture(from: node)!
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
        Game.sharedInstance.placingObjectsQueue.append(ItemDefinitions.BaseItems.ReceptionDesk)
        Game.sharedInstance.menuManager?.openMenu!.remove()
      })
      let item = Menu.menuItem(button: button)
      self.menuItems.append(item)
    }
  }

}
