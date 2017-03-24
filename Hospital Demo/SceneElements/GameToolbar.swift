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
  let tag: String
  let node: SKSpriteNode
  let handler: () -> Void
  
  init(tag: String, node: SKSpriteNode, handler: @escaping () -> Void) {
    self.tag = tag
    self.node = node
    self.handler = handler
  }
}

class GameToolbar: HLToolbarNode {
  static let defaultNodeSize = CGSize(width: 20, height: 20)
  
  fileprivate var options = [GameToolbarOption]()
  
  init(size: CGSize) {
    super.init()
    
    self.size = size
    self.anchorPoint = CGPoint(x: 0, y: 0)
    
    // add default options
    addOption("build_room", node: createNode(SKTexture(imageNamed: "Graphics/build_room")), handler: GameToolbar.buildRoomTouch)
    addOption("build", node: createNode(SKTexture(imageNamed: "Graphics/build_item")), handler: GameToolbar.buildTouch)
    addOption("green", node: createNode(.green), handler: GameToolbar.greenTouch)
    // can also pass a closure
    
    
    self.toolTappedBlock = { tag in self.didTapBlock(tag!) }
    
    let tags = options.reduce([String]()) { (tags, option) in
      return tags + [option.tag]
    }
    
    let nodes = options.reduce([SKSpriteNode]()) { (nodes, option) in
      return nodes + [option.node]
    }
    
    self.setTools(nodes, tags: tags, animation:HLToolbarNodeAnimation.slideUp)
    
    //baseScene.registerDescendant(self, withOptions: Set(arrayLiteral: HLSceneChildGestureTarget))
    //self.registerDescendant(toolbarNode, withOptions: Set<AnyObject>.setWithObject(HLSceneChildGestureTarget))
    
    
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
  
  class func buildRoomTouch() -> Void {
        
    Game.sharedInstance.gameStateMachine.enter(GSBuildRoom)
    Game.sharedInstance.buildRoomStateMachine.enter(BRSPrePlan)
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
      Game.sharedInstance.gameStateMachine.enter(GSBuildItem)
      Game.sharedInstance.buildItemStateMachine.enter(BISPlan)
      Game.sharedInstance.placingObjectsQueue.append(ReceptionDesk)
      
    }
  }
  
}
