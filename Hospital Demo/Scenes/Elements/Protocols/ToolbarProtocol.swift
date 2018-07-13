//
//  Menu.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 01/05/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import Foundation
import SpriteKit

protocol ToolbarProtocol: MenuProtocol {

  var location: Game.rotation? { get set }

  
}

extension ToolbarProtocol {

  func show() {
    Game.sharedInstance.toolbarManager?.show(self)
  }

  func hide() {
    Game.sharedInstance.toolbarManager?.hide(self)
  }

  func remove() {
    Game.sharedInstance.menuManager?.remove(self)
  }

  func isHidden() -> Bool {
    return self.menuNode.isHidden
  }


}
