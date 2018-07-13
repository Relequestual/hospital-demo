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
  
  var menuNode: SKSpriteNode = Menu.makeMenuNode(CGSize(width: Game.sharedInstance.mainView!.bounds.width, height: 64))
  
  var menuItems: [Menu.menuItem] = []
  
  static let defaultNodeSize = CGSize(width: 64, height: 64)

  var confirm: (() -> Void)?
  var cancel: (() -> Void)?

  let view = SKView.init()

  init() {

    self.location = .south
    self.menuNode.anchorPoint = CGPoint(x: 0, y: 1)

    menuItems.append(contentsOf: [
      Menu.menuItem(button: Button(texture: createNodeTexture(.green), touch_f: okTouch)),
      Menu.menuItem(button: Button(texture: createNodeTexture(.red), touch_f: cancelTouch))
    ])
    Menu.layoutItems(menu: self, layout: .xSlide)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func createNodeTexture(_ color: UIColor, size: CGSize = ConfirmToolbar.defaultNodeSize) -> SKTexture {
    let texture = view.texture(from: SKSpriteNode(color: color, size: size))!
    return texture
  }

//  fileprivate func createNode(_ texture: SKTexture, size: CGSize = GameToolbar.defaultNodeSize) -> SKSpriteNode {
//    return SKSpriteNode(texture: texture, size: size)
//  }

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
