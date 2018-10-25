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

  init(menuItems: [ItemDefinitions.BaseItems] = [ItemDefinitions.BaseItems.ReceptionDesk, ItemDefinitions.BaseItems.StaffDesk, ItemDefinitions.BaseItems.PateintChair]) {
    print("ItemMen#init")

    self.menuNode.decelerationMode = .Decelerate

    contentNode.name = "content node"
    let size = CGSize(width: Game.sharedInstance.mainView!.bounds.width, height: Game.sharedInstance.mainView!.bounds.height)

    self.menuNode.position = CGPoint(x: 0 - size.width / 2 , y: 0 + size.height / 4)

    self.contentNode.size = size
    self.contentNode.anchorPoint = CGPoint(x: 0, y: 1)
//    contentNode.setPosition(position: CGPoint(x: 0, y: 0), forAnchor: CGPoint(x: 0.5, y: 0.5))
    self.contentNode.position = CGPoint(x:0,y:0)
    self.menuNode.scrollContentNode.addChild(self.contentNode)
    self.menuNode.scrollContentSize = size

//    self.menuNode.position = CGPoint(x: 0 - size.width / 2, y: 0 + size.height / 2)

    let view = SKView.init()
    graphics = menuItems.reduce(into: [:], { graphics, itemType in
      let item = Game.sharedInstance.itemManager!.buildItem(itemType: itemType)
      let node = item.component(ofType: SpriteComponent.self)?.node ?? SKSpriteNode()
      let texture = view.texture(from: node)!
//      texture = Menu.resizeToMax(texture: texture)

      graphics[itemType] = texture
    })

    self.createMenuItems()
    Menu.layoutItems(menu: self, layoutOptions: Menu.menuLayoutOptions(layout: Menu.Layout.grid, buttonSize: CGSize(width: 100, height: 80)))

    // Create custom crop node, but don't activate clipping, yet, but DO active it now.

    //    SKSpriteNode *cropMask = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(self.scrollNode.scrollNodeSize.width*2/3, self.scrollNode.scrollNodeSize.height*2/3)];

    let cropMask = SKSpriteNode(color: UIColor.red, size: menuNode.scrollBackgroundNode.size)
//    cropMask.anchorPoint = CGPoint(x: 0.5, y: 0.5)

    let cropNode = SKCropNode()
    cropNode.maskNode = cropMask
//    cropNode.position = CGPoint(x: self.menuNode.scrollNodeSize.width / 2, y: self.menuNode.scrollNodeSize.height / 4)
    cropNode.position = CGPoint(x: 0 + size.width / 2, y: 0 - size.height / 4)
//    cropNode.position = CGPoint(x: 0 , y: 0)
//    cropNode.position = self.menuNode.position

    self.menuNode.contentCropNode = cropNode
    self.menuNode.clipContent = true


//    SKCropNode *cropNode = [[SKCropNode alloc] init];
//    [cropNode setMaskNode:cropMask];
//    cropNode.position = CGPointMake(self.scrollNode.scrollNodeSize.width/2, -self.scrollNode.scrollNodeSize.height/2);
//    self.scrollNode.contentCropNode = cropNode;


  }

  func createMenuItems() {

    self.graphics.forEach { (itemType: ItemDefinitions.BaseItems, texture: SKTexture) in
      let button = Button(texture: texture, touch_f: { (Button) in
        print("menu button!!!")
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
