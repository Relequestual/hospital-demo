//
//  Menu.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 18/04/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import Foundation
import SpriteKit

class Menu {

  struct menuItem {
    var color: UIColor
    var button: Button
    var section: Int

    init(button: Button, color: UIColor, section: Int = 0) {
      self.button = button
      self.color = color
      self.section = section
    }
  }

  enum Layout {
    case grid
  }

  static let buttonSize = 80

  static func makeMenuNode() -> SKSpriteNode {
    let menuBackgroundColor = SKColor.cyan
    let size = CGSize(width: Game.sharedInstance.mainView!.bounds.width, height: Game.sharedInstance.mainView!.bounds.height)

    let node = SKShapeNode(rectOf: size)
    node.fillColor = menuBackgroundColor
    return SKSpriteNode(texture: SKView.init().texture(from: node))
  }



  static func layoutItems(menu: MenuProtocol, layout: Menu.Layout = Menu.Layout.grid) {

    let size = CGSize(width: Game.sharedInstance.mainView!.bounds.width, height: Game.sharedInstance.mainView!.bounds.height)
    let padding = 10
    let buttonSize = CGSize(width: 80, height: 50)

    let menuNode = menu.menuNode
//    menuNode.anchorPoint = CGPoint(x: 0, y: 0)

    let x = padding + Int(buttonSize.width)
    let y = padding + Int(buttonSize.height)

    let menuItem = menu.menuItems.first
    let menuItemButtonNode = menuItem?.button.component(ofType: SpriteComponent.self)?.node
    menuItemButtonNode?.zPosition = CGFloat(ZPositionManager.WorldLayer.ui.zpos)


    // This offset is for taking away for x and y position starting at 0 0 in centre.
    // Applied to points that you want to position as if the menu anchor was top left.
    let coordOffset = CGPoint(x: (0 - size.width / 2), y: (0 + size.height / 2))
    let buttonSpace = Int(buttonSize.width) + padding * 2

    var numPerRow = size.width / CGFloat(menu.menuItems.count * buttonSpace)
    numPerRow.round(FloatingPointRoundingRule.down)
    var extraSpace = Int(size.width) - (Int(numPerRow) * buttonSpace)

    let shift = CGFloat(extraSpace / Int(numPerRow))

    let firstPoint = CGPoint(x: coordOffset.x + (buttonSize.width / 2) + shift, y: coordOffset.y - (buttonSize.height / 2))


    menuItemButtonNode!.position = CGPoint(x: firstPoint.x, y: firstPoint.y)
    menuNode.addChild(menuItemButtonNode!)


//    for items in menu.menuItems {
//
//    }
  }


}
