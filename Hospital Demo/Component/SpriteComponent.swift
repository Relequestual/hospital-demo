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
    node = SKSpriteNode(texture: texture, color: SKColor.whiteColor(), size: texture.size())
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func addToNodeKey() {
    self.node.userData = NSMutableDictionary()
    guard self.entity != nil else {return}
    self.node.userData?.setObject(self.entity!, forKey: "entity")
  }
  
}
