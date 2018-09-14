//
//  Menu.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 01/05/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import Foundation
import SpriteKit

protocol MenuProtocol {

  var menuNode: SKSpriteNode { get set }
  var menuItems: [Menu.menuItem] { get set }

  func show()

  func hide()

}

extension MenuProtocol {

  init() {
    self.init()
    self.menuNode.anchorPoint = CGPoint(x: 0, y: 1)
  }

  func show() {
    Game.sharedInstance.menuManager?.show(self)
  }

  func hide() {
    
  }

  func remove() {
    Game.sharedInstance.menuManager?.remove(self)
  }

  func isHidden() -> Bool {
    return self.menuNode.isHidden
  }

  
}
