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

  var menuNode: INSKScrollNode = Menu.makeMenuNode(CGSize(width: Game.sharedInstance.mainView!.bounds.width, height: Game.sharedInstance.mainView!.bounds.height / 2))
  var contentNode: SKSpriteNode = SKSpriteNode()

  var graphics: [ItemDefinitions.BaseItems: SKTexture]
  var menuItems: [Menu.menuItem] = []

  init(menuItems: [ItemDefinitions.BaseItems] = [.ReceptionDesk, .StaffDesk, .PateintChair, .ExamBed]) {

    self.menuNode.decelerationMode = .Decelerate

    contentNode.name = "content node"
    let size = CGSize(width: Game.sharedInstance.mainView!.bounds.width, height: Game.sharedInstance.mainView!.bounds.height)

    self.menuNode.position = CGPoint(x: 0 - size.width / 2 , y: 0 + size.height / 4)

    self.contentNode.size = size
    self.contentNode.anchorPoint = CGPoint(x: 0, y: 1)
    self.contentNode.position = CGPoint(x:0,y:0)
    self.menuNode.scrollContentNode.addChild(self.contentNode)
    self.menuNode.scrollContentSize = size

//    self.menuNode.position = CGPoint(x: 0 - size.width / 2, y: 0 + size.height / 2)

    let view = SKView.init()
    graphics = menuItems.reduce(into: [:], { graphics, itemType in
      let item = Game.sharedInstance.itemManager!.buildItem(itemType: itemType)
      let node = item.component(ofType: SpriteComponent.self)?.node ?? SKSpriteNode()
      let texture = view.texture(from: node)!

      graphics[itemType] = texture
    })

    self.createMenuItems()
    Menu.layoutItems(menu: self, layoutOptions: Menu.menuLayoutOptions(layout: Menu.Layout.grid, buttonSize: CGSize(width: 100, height: 80)))

    // Create custom crop node
    let cropMask = SKSpriteNode(color: UIColor.red, size: menuNode.scrollBackgroundNode.size)

    let cropNode = SKCropNode()
    cropNode.maskNode = cropMask
    cropNode.position = CGPoint(x: 0 + size.width / 2, y: 0 - size.height / 4)

    self.menuNode.contentCropNode = cropNode
    self.menuNode.clipContent = true
  }

  func createMenuItems() {

    self.graphics.forEach { (itemType: ItemDefinitions.BaseItems, texture: SKTexture) in
      let button = Button(texture: texture, touch_f: { (Button) in
        Game.sharedInstance.gameStateMachine.enter(GSBuildItem.self)
        Game.sharedInstance.buildItemStateMachine.enter(BISPlan.self)
        Game.sharedInstance.placingObjectsQueue.append(itemType)
        Game.sharedInstance.menuManager?.openMenu!.remove()
      })
      let item = Menu.menuItem(button: button)
      self.menuItems.append(item)
    }
  }

}
