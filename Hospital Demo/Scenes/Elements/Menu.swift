//
//  Menu.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 18/04/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import Foundation
import SpriteKit

// Utility class for menus and toolbars. Toolbars are a type of menu.
class Menu {

  struct menuLayoutOptions {
    var layout: Menu.Layout
    var padding: Int
    var buttonSize: CGSize

    init(layout: Menu.Layout? = Menu.Layout.grid, padding: Int? = 5, buttonSize: CGSize? = CGSize(width: 64, height: 64)) {
      self.layout = layout!
      self.padding = padding!
      self.buttonSize = buttonSize!
    }
    
  }

  struct menuItem {
    var button: Button
    var section: Int

    init(button: Button, section: Int = 0) {
      self.button = button
      self.section = section
    }
  }

  enum Layout {
    case grid
    case xSlide
  }

  static let buttonSize = 80

  static func makeMenuNode() -> INSKScrollNode {
    let size = CGSize(width: Game.sharedInstance.mainView!.bounds.width, height: Game.sharedInstance.mainView!.bounds.height)
    return Menu.makeMenuNode(size)
  }

  static func makeMenuNode(_ size: CGSize) -> INSKScrollNode {
    let menuBackgroundColor = SKColor.yellow


    let scrollNode = INSKScrollNode(scrollNodeSize: size)
    scrollNode.scrollBackgroundNode.color = menuBackgroundColor
    return scrollNode
  }


  static func getResizeScale(texture: SKTexture, maxSize: Int = 100) -> SKTexture{
    let xScale = CGFloat(Menu.buttonSize) / texture.size().width.rounded()
    let yScale = CGFloat(Menu.buttonSize) / texture.size().height.rounded()
    print(xScale)
    print(yScale)
    print(texture)

    let size: CGSize = texture.size()
    var scale: CGFloat

    if (xScale < 1 || yScale < 1) {
      scale = xScale < yScale ? xScale : yScale
    }

    return texture

  }

  static func layoutItems(menu: MenuProtocol, layoutOptions: menuLayoutOptions) {

    let padding = layoutOptions.padding
    let buttonSize = layoutOptions.buttonSize

    let contentHolderNode = SKNode()
    contentHolderNode.position = menu.contentNode.position

    // This offset is for taking away for x and y position starting at 0 0 in centre.
    // Applied to points that you want to position as if the menu anchor was top left.
//    let coordOffset = CGPoint(x: (0 - size.width / 2), y: (0 + size.height / 2))
    // Now set to 0,0 as anchor is changed to top left
    let coordOffset = CGPoint(x: 0, y: 0)

    // How much space a button requires
    let buttonSpace = Int(buttonSize.width) + padding * 2

    var maxNumPerRow = menu.contentNode.size.width / CGFloat(buttonSpace)
    maxNumPerRow.round(FloatingPointRoundingRule.down)
    let maxNumPerRowInt = Int(maxNumPerRow)

    let rowAutoPad = (menu.contentNode.size.width - CGFloat(buttonSpace) * maxNumPerRow) / maxNumPerRow / 2

    var y = 1
    var x = 1

    for i in 1...menu.menuItems.count {
      let menuItem = menu.menuItems[i - 1]
      let menuItemButtonNode = menuItem.button.component(ofType: SpriteComponent.self)?.node
      menuItemButtonNode?.zPosition = CGFloat(ZPositionManager.WorldLayer.ui.zpos)

      // right by half button space required, plus half for positioning anchor
      // TODO: Handle divide by 0 possible issue when using grid layout and width is less than button size!!
      var location = CGPoint.zero
      if (layoutOptions.layout == .xSlide) {
        location = CGPoint(x: coordOffset.x + CGFloat(buttonSpace * (i - 1)) + CGFloat(buttonSpace / 2), y: coordOffset.y - (buttonSize.height / 2))
      }
      if (layoutOptions.layout == .grid) {
        let leftPad = CGFloat((buttonSpace + (Int(rowAutoPad)) * 2) * (x - 1))
        location = CGPoint(
          x: coordOffset.x + rowAutoPad + leftPad + CGFloat(buttonSpace / 2),
//          x: coordOffset.x + rowAutoPad + CGFloat(buttonSpace * (i - (y / maxNumPerRowInt) - ( maxNumPerRowInt == 1 ? 0 : 1))) + CGFloat(buttonSpace / 2),
          y: coordOffset.y - CGFloat(buttonSpace * (y - 1)) - CGFloat(buttonSpace / 2)
        )
        if (i == maxNumPerRowInt) {
          y += 1
          x = 0
        }
      }
      x += 1
      menuItemButtonNode!.position = CGPoint(x: location.x, y: location.y)
      menuItemButtonNode?.removeFromParent()
      contentHolderNode.addChild(menuItemButtonNode!)
    }
    menu.contentNode.addChild(contentHolderNode)

// These next two blocks will be useful for calculating position on a y extneding menu
//    var numPerRow = menu.menuNode.size.width / CGFloat(buttonSpace)
//    numPerRow.round(FloatingPointRoundingRule.down)

//    var extraSpace = Int(menu.menuNode.size.width) - (Int(numPerRow) * buttonSpace)
//    let shift = CGFloat(extraSpace / Int(numPerRow))

//    let firstPoint = CGPoint(x: coordOffset.x + (buttonSize.width / 2) + shift, y: coordOffset.y - (buttonSize.height / 2))
//
//
//    menuItemButtonNode!.position = CGPoint(x: firstPoint.x, y: firstPoint.y)
//    menu.menuNode.addChild(menuItemButtonNode!)

  }


}
