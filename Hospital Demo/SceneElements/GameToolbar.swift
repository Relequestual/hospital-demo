//
//  GameToolbar.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 06/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import HLSpriteKit

struct GameToolbarOption {
  private let tag: String
  private let node: SKSpriteNode
  private let handler: () -> Void
  
  init(tag: String, node: SKSpriteNode, handler: () -> Void) {
    self.tag = tag
    self.node = node
    self.handler = handler
  }
}

class GameToolbar: HLToolbarNode {
  static let defaultNodeSize = CGSize(width: 20, height: 20)
  
  private var options = [GameToolbarOption]()
  
  init(size: CGSize, baseScene: BaseScene) {
    super.init()
    
    self.anchorPoint = CGPoint(x: 0, y: 0)
    self.size = size
    self.position = CGPoint(x: 0, y: 0)
    self.zPosition = 999
    
    // add default options
    addOption("red", node: createNode(.redColor()), handler: GameToolbar.redTouch)
    addOption("green", node: createNode(.greenColor()), handler: GameToolbar.greenTouch)
    // can also pass a closure
    addOption("blue", node: createNode(.blueColor())) {
      GameToolbar.blueTouch()
    }
    
    
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
  
  class func redTouch() -> Void {
    Game.sharedInstance.gameStateMachine.enterState(GSLevelEdit)
  }
  
  class func greenTouch() -> Void {
    Game.sharedInstance.gameStateMachine.enterState(GSGeneral)
  }
  
  class func blueTouch() -> Void {
    
    if ( Game.sharedInstance.buildStateMachine.currentState is BSPlaceItem ) {
      Game.sharedInstance.gameStateMachine.enterState(GSGeneral)
      Game.sharedInstance.buildStateMachine.enterState(BSNoBuild)
    } else {
      Game.sharedInstance.gameStateMachine.enterState(GSBuild)
      Game.sharedInstance.buildStateMachine.enterState(BSPlaceItem)
      Game.sharedInstance.placingObjectsQueue.append(ReceptionDesk)
      
    }
  }
  
}