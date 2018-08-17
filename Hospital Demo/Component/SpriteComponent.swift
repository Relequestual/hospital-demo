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
  var node: SKSpriteNode

  static let view = SKView()

  //  If using a texture
  init(texture: SKTexture) {
    node = SKSpriteNode(texture: texture, color: SKColor.white, size: texture.size())
    super.init()
  }

  convenience init(shapeNode: SKShapeNode, color: UIColor) {
    shapeNode.fillColor = UIColor.purple
    self.init(texture: SpriteComponent.view.texture(from: shapeNode)!)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func didAddToEntity() {
    node.userData = NSMutableDictionary()
    guard entity != nil else { return }
    node.userData?.setObject(entity!, forKey: "entity" as NSCopying)
  }
}
