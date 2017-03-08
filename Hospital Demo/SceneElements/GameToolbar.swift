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
    self.zPosition = CGFloat(ZPositionManager.WorldLayer.ui.zpos)
    
    // add default options
    addOption("build_room", node: createNode(SKTexture(imageNamed: "Graphics/build_room")), handler: GameToolbar.buildRoomTouch)
    addOption("build", node: createNode(SKTexture(imageNamed: "Graphics/build_item"))) {
      GameToolbar.buildTouch()
    }
    addOption("green", node: createNode(.greenColor()), handler: GameToolbar.greenTouch)
    // can also pass a closure
    
    
    self.toolTappedBlock = { tag in self.didTapBlock(tag) }
    
    let tags = options.reduce([String]()) { (tags, option) in
      return tags + [option.tag]
    }
    
    let nodes = options.reduce([SKSpriteNode]()) { (nodes, option) in
      return nodes + [option.node]
    }
    
    self.setTools(nodes, tags: tags, animation:HLToolbarNodeAnimation.SlideUp)
    
    //baseScene.registerDescendant(self, withOptions: Set(arrayLiteral: HLSceneChildGestureTarget))
    //self.registerDescendant(toolbarNode, withOptions: Set<AnyObject>.setWithObject(HLSceneChildGestureTarget))
    
    
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
  
  class func buildRoomTouch() -> Void {
        
    Game.sharedInstance.gameStateMachine.enterState(GSBuildRoom)
    Game.sharedInstance.buildRoomStateMachine.enterState(BRSPrePlan)
    print("gamestate is...")
    print(Game.sharedInstance.gameStateMachine.currentState)
//    Game.sharedInstance.buildStateMachine.enterState(BRSPlan)
    Game.sharedInstance.buildRoomStateMachine.roomType = GPOffice.self
    
  }
  
  class func greenTouch() -> Void {

  }
  
  class func buildTouch() -> Void {

    if ( Game.sharedInstance.buildItemStateMachine.currentState is BISPlace ) {
//      Game.sharedInstance.gameStateMachine.enterState(GSGeneral)
//      Game.sharedInstance.buildStateMachine
    } else {
      Game.sharedInstance.gameStateMachine.enterState(GSBuildItem)
      Game.sharedInstance.buildItemStateMachine.enterState(BISPlan)
      Game.sharedInstance.placingObjectsQueue.append(ReceptionDesk)
      
    }
  }
  
}