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
    node = Touchable(texture: texture, color: SKColor.whiteColor(), size: texture.size())
    node.userInteractionEnabled = true
  }
}


class Touchable: SKSpriteNode {

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    print("touched!")
  }

}