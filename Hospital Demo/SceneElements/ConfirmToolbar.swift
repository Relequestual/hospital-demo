//
//  ConfirmToolbar.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 02/11/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//


import Foundation
import SpriteKit
import GameplayKit
import HLSpriteKit


class ConfirmToolbar: HLToolbarNode {
  static let defaultNodeSize = CGSize(width: 20, height: 20)
  
  private var options = [GameToolbarOption]()
  var confirm: (()->Void)?
  var cancel: (()->Void)?
  
  init(size: CGSize) {
    super.init()
    
    self.anchorPoint = CGPoint(x: 0, y: 0)
    self.size = size
    self.position = CGPoint(x: 0, y: 0)
    self.zPosition = CGFloat(ZPositionManager.WorldLayer.ui.zpos)
    
    // add default options
    addOption("ok", node: createNode(.greenColor()), handler: self.okTouch)
    addOption("cancel", node: createNode(.redColor()), handler: self.cancelTouch)

    
    self.toolTappedBlock = { tag in self.didTapBlock(tag) }
    
    let tags = options.reduce([String]()) { (tags, option) in
      return tags + [option.tag]
    }
    
    let nodes = options.reduce([SKSpriteNode]()) { (nodes, option) in
      return nodes + [option.node]
    }
    
    self.setTools(nodes, tags: tags, animation:HLToolbarNodeAnimation.SlideUp)
    
    //self.registerDescendant(toolbarNode, withOptions: Set<AnyObject>.setWithObject(HLSceneChildGestureTarget))
    //baseScene.registerDescendant(self, withOptions: Set(arrayLiteral: HLSceneChildGestureTarget))
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addOption(tag: String, node: SKSpriteNode, handler: () -> Void) {
    let option = GameToolbarOption(tag: tag, node: node, handler: handler)
    options.append(option)
  }
  
  private func didTapBlock(tag: String) {
    let nodes = options.filter { $0.tag == tag }
    nodes.forEach { $0.handler() }
  }
  
  private func createNode(color: UIColor, size: CGSize = GameToolbar.defaultNodeSize) -> SKSpriteNode {
    return SKSpriteNode(color: color, size: size)
  }
  
  private func createNode(texture: SKTexture, size: CGSize = GameToolbar.defaultNodeSize) -> SKSpriteNode {
    return SKSpriteNode(texture: texture, size: size)
  }
  
  func okTouch() -> Void {
    print("ok touch")
    if (self.confirm != nil) {
      self.confirm!()
    }
  }
  
  func cancelTouch() -> Void {
    print("cancel touch")
    if (self.cancel != nil) {
      self.cancel!()
    }
  }
 
  
  
}
