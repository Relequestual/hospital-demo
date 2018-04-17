//
//  DebugToolbar.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 06/10/2017.
//  Copyright © 2017 Ben Hutton. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import HLSpriteKit


class DebugToolbar: HLToolbarNode {
  static let defaultNodeSize = CGSize(width: 20, height: 20)

  fileprivate var options = [GameToolbarOption]()

  init(size: CGSize) {
    super.init()

    self.size = size
//    self.position = CGPoint(x: Game.sharedInstance.mainView!.bounds.width, y: 0)
//    self.position = CGPoint(x: 50, y: 0)

    print("debug toolbar position is")
    print(self.position)
    print("---")
    self.zPosition = CGFloat(ZPositionManager.WorldLayer.ui.zpos) + 1.0

    // add default options
    addOption("showDoorPOUs", node: createNode(.orange), handler: self.showPOUs)
    addOption("clearBackground", node: createNode(.darkGray), handler: self.clearBK)


    self.toolTappedBlock = { tag in self.didTapBlock(tag!) }

    let tags = options.reduce([String]()) { (tags, option) in
      return tags + [option.tag]
    }

    let nodes = options.reduce([SKSpriteNode]()) { (nodes, option) in
      return nodes + [option.node]
    }

    self.setTools(nodes, tags: tags, animation:HLToolbarNodeAnimation.slideLeft)

    //self.registerDescendant(toolbarNode, withOptions: Set<AnyObject>.setWithObject(HLSceneChildGestureTarget))
    //baseScene.registerDescendant(self, withOptions: Set(arrayLiteral: HLSceneChildGestureTarget))

//    self.backgroundColor = UIColor.clear

  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func addOption(_ tag: String, node: SKSpriteNode, handler: @escaping () -> Void) {
    let option = GameToolbarOption(tag: tag, node: node, handler: handler)
    options.append(option)
  }

  fileprivate func didTapBlock(_ tag: String) {
    let nodes = options.filter { $0.tag == tag }
    nodes.forEach { $0.handler() }
  }

  fileprivate func createNode(_ color: UIColor, size: CGSize = GameToolbar.defaultNodeSize) -> SKSpriteNode {
    return SKSpriteNode(color: color, size: size)
  }

  fileprivate func createNode(_ texture: SKTexture, size: CGSize = GameToolbar.defaultNodeSize) -> SKSpriteNode {
    return SKSpriteNode(texture: texture, size: size)
  }


  func showPOUs() {
    
  }

  func clearBK() {
    self.backgroundColor = UIColor.clear
  }

}
