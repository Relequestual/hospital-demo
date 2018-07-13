//
//  MenuManager.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 18/04/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import Foundation
import SpriteKit

class MenuManager {
  var scene: SKScene

  var openMenu: MenuProtocol?
//  var menuStack: [Menu] = []

  init(scene: SKScene) {
    print("MENU MANAGER")
    self.scene = scene
  }

  func show(_ menu: MenuProtocol) {

    if (menu.menuNode.parent == nil) {
      menu.menuNode.zPosition = CGFloat(ZPositionManager.WorldLayer.ui.zpos + 1000)
      scene.camera!.addChild(menu.menuNode)
    }
    self.openMenu = menu

    if (menu.menuNode.isHidden) {
//      show somehow?
    }
  }

  func remove(_ menu: MenuProtocol) {
    menu.menuNode.removeFromParent()
    self.openMenu = nil
  }

}
