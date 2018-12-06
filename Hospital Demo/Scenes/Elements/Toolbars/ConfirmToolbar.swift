//
//  ConfirmToolbar.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 02/11/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class ConfirmToolbar: ToolbarProtocol {

  var location: Game.rotation?

  var menuNode: INSKScrollNode

  var contentNode: SKSpriteNode

  var menuItems: [Menu.menuItem] = []
  
  static let defaultNodeSize = CGSize(width: 64, height: 64)

  var confirm: (() -> Void)?
  var cancel: (() -> Void)?

  let view = SKView.init()

  init(addMenuItems: [Menu.menuItem] = []) {

    self.location = .south

    self.menuNode = Menu.makeMenuNode(CGSize(width: Game.sharedInstance.mainView!.bounds.width, height: 64))

    self.contentNode = SKSpriteNode(color: UIColor.blue, size: self.menuNode.scrollNodeSize)
    self.contentNode.anchorPoint = CGPoint(x: 0, y: 1)

    menuItems.append(contentsOf: [
      Menu.menuItem(button: Button(texture: createNodeTexture(.green), touch_f: okTouch)),
      Menu.menuItem(button: Button(texture: createNodeTexture(.red), touch_f: cancelTouch))
    ])
    menuItems.append(contentsOf: addMenuItems)
    Menu.layoutItems(menu: self, layoutOptions: Menu.menuLayoutOptions(layout: .xSlide))

    self.contentNode.removeFromParent()
    self.menuNode.scrollContentNode.addChild(self.contentNode)
    self.menuNode.scrollContentSize = CGSize(width: self.contentNode.size.width, height: self.contentNode.size.height)

  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func createNodeTexture(_ color: UIColor, size: CGSize = ConfirmToolbar.defaultNodeSize) -> SKTexture {
    let texture = view.texture(from: SKSpriteNode(color: color, size: size))!
    return texture
  }

  func okTouch() {
    print("ok touch")
    if confirm != nil {
      confirm!()
    }
  }

  func cancelTouch() {
    print("cancel touch")
    if cancel != nil {
      cancel!()
    }
  }
}
