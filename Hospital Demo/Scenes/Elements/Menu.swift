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

  struct menuLayoutOptions {
    var layout: Menu.Layout = Menu.Layout.grid
    var padding: Int = 5
    var buttonSize: CGSize = CGSize(width: 64, height: 64)

    init(){}

    init(layout: Menu.Layout) {
      self.layout = layout
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

  static func makeMenuNode() -> SKSpriteNode {
    let size = CGSize(width: Game.sharedInstance.mainView!.bounds.width, height: Game.sharedInstance.mainView!.bounds.height)
    return Menu.makeMenuNode(size)
  }

  static func makeMenuNode(_ size: CGSize) -> SKSpriteNode {
    let menuBackgroundColor = SKColor.cyan

    let node = SKShapeNode(rectOf: size)
    node.fillColor = menuBackgroundColor
    return SKSpriteNode(texture: SKView.init().texture(from: node))
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

  static func layoutItems(menu: MenuProtocol, layoutOptions: menuLayoutOptions = Menu.menuLayoutOptions()) {

    let padding = layoutOptions.padding
    let buttonSize = layoutOptions.buttonSize

//    menuNode.anchorPoint = CGPoint(x: 0, y: 0)

    // This offset is for taking away for x and y position starting at 0 0 in centre.
    // Applied to points that you want to position as if the menu anchor was top left.
//    let coordOffset = CGPoint(x: (0 - size.width / 2), y: (0 + size.height / 2))
    // Now set to 0,0 as anchor is changed to top left
    let coordOffset = CGPoint(x: 0, y: 0)

    // How much space a button requires
    let buttonSpace = Int(buttonSize.width) + padding * 2

    var maxNumPerRow = menu.menuNode.size.width / CGFloat(buttonSpace)
    maxNumPerRow.round(FloatingPointRoundingRule.down)
    let maxNumPerRowInt = Int(maxNumPerRow)

    let rowAutoPad = (menu.menuNode.size.width - CGFloat(buttonSpace) * maxNumPerRow) / maxNumPerRow / 2

    var y = 1

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
        location = CGPoint(x: coordOffset.x + rowAutoPad + CGFloat(buttonSpace * (i - (y / maxNumPerRowInt) - ( maxNumPerRowInt == 1 ? 0 : 1))) + CGFloat(buttonSpace / 2), y: coordOffset.y - CGFloat(buttonSpace * (y - 1)) - CGFloat(buttonSpace / 2))
        if (i == maxNumPerRowInt) {
          y += 1
        }
      }
      menuItemButtonNode!.position = CGPoint(x: location.x, y: location.y)
      menu.menuNode.addChild(menuItemButtonNode!)

    }

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
