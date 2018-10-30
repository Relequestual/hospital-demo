//
//  DebugToolbar.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 06/10/2017.
//  Copyright © 2017 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class DebugToolbar: ToolbarProtocol {
  var location: Game.rotation?
  
  var menuNode = Menu.makeMenuNode(CGSize(width: 64, height: Game.sharedInstance.mainView!.bounds.height))
  var contentNode: SKSpriteNode

  var menuItems: [Menu.menuItem] = []
  
  static let defaultNodeSize = CGSize(width: 40, height: 40)

  let view = SKView.init()

  var zoomOut:Bool = false {
    didSet {
      let zoomAction = SKAction.scale(to: zoomOut ? 2 : 1, duration: 0.5)
      Game.sharedInstance.mainView?.scene?.camera?.run(zoomAction)
    }
  }

//  fileprivate var options = [GameToolbarOption]()

  init(size: CGSize) {

    self.location = .east
    self.contentNode = SKSpriteNode(color: UIColor.blue, size: size)
    self.contentNode.anchorPoint = CGPoint(x: 0, y: 1)

//    self.position = CGPoint(x: Game.sharedInstance.mainView!.bounds.width, y: 0)
//    self.position = CGPoint(x: 50, y: 0)

//    let zPosition = CGFloat(ZPositionManager.WorldLayer.ui.zpos) + 1.0

    menuItems.append(contentsOf: [
      Menu.menuItem(button: Button(texture: createNodeTexture(.orange), touch_f: zoom)),
      Menu.menuItem(button: Button(texture: createNodeTexture(.darkGray), touch_f: clearBK))
    ])
    var layoutOptions = Menu.menuLayoutOptions()
    layoutOptions.buttonSize = DebugToolbar.defaultNodeSize
    Menu.layoutItems(menu: self, layoutOptions: layoutOptions)


//    self.contentNode.removeFromParent()
    self.menuNode.scrollContentNode.addChild(self.contentNode)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func createNodeTexture(_ color: UIColor, size: CGSize = DebugToolbar.defaultNodeSize) -> SKTexture {
    return view.texture(from: SKSpriteNode(color: color, size: size))!
  }

  func zoom(){
    self.zoomOut = !self.zoomOut
  }

  func showPOUs() {
  }

  func clearBK() {
//    backgroundColor = UIColor.clear
  }
}
