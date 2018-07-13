//
//  DebugToolbar.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 06/10/2017.
//  Copyright © 2017 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit
import HLSpriteKit
import SpriteKit

class DebugToolbar: ToolbarProtocol {
  var location: Game.rotation?
  
  var menuNode: SKSpriteNode = Menu.makeMenuNode(CGSize(width: 64, height: Game.sharedInstance.mainView!.bounds.height))
  
  var menuItems: [Menu.menuItem] = []
  
  static let defaultNodeSize = CGSize(width: 20, height: 20)

    let view = SKView.init()

//  fileprivate var options = [GameToolbarOption]()

  init(size: CGSize) {
    self.location = .east

//    self.position = CGPoint(x: Game.sharedInstance.mainView!.bounds.width, y: 0)
//    self.position = CGPoint(x: 50, y: 0)

//    let zPosition = CGFloat(ZPositionManager.WorldLayer.ui.zpos) + 1.0

    menuItems.append(contentsOf: [
      Menu.menuItem(button: Button(texture: createNodeTexture(.orange), touch_f: showPOUs)),
      Menu.menuItem(button: Button(texture: createNodeTexture(.darkGray), touch_f: clearBK))
    ])

   
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func createNodeTexture(_ color: UIColor, size: CGSize = GameToolbar.defaultNodeSize) -> SKTexture {
    return view.texture(from: SKSpriteNode(color: color, size: size))!
  }

  func showPOUs() {
  }

  func clearBK() {
//    backgroundColor = UIColor.clear
  }
}
