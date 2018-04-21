//
//  SpriteComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 19/12/2015.
//  Copyright © 2015 Ben Hutton. All rights reserved.
//

import GameplayKit
import SpriteKit

class SpriteComponent: GKComponent {
  let node: SKSpriteNode

  init(texture: SKTexture) {
    node = SKSpriteNode(texture: texture, color: SKColor.white, size: texture.size())
    super.init()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func addToNodeKey() {
    node.userData = NSMutableDictionary()
    guard entity != nil else { return }
    node.userData?.setObject(entity!, forKey: "entity" as NSCopying)
  }
}
