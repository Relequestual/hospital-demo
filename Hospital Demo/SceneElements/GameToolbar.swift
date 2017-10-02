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
    addOption("build_item", node: createNode(SKTexture(imageNamed: "Graphics/build_item")), handler: GameToolbar.buildItemTouch)
    addOption("build_door", node: createNode(SKTexture(imageNamed: "Graphics/door")), handler: GameToolbar.buildDoorTouch)
    addOption("debug",      node: createNode(SKTexture(imageNamed: "Graphics/debug")), handler: {})

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
  
  static func buildRoomTouch() -> Void {
        
    Game.sharedInstance.gameStateMachine.enter(GSBuildRoom.self)
    Game.sharedInstance.buildRoomStateMachine.enter(BRSPrePlan.self)
    print("gamestate is...")
    print(Game.sharedInstance.gameStateMachine.currentState!)
//    Game.sharedInstance.buildStateMachine.enterState(BRSPlan)
    
  }
  
  static func buildItemTouch() -> Void {

    if ( Game.sharedInstance.buildItemStateMachine.currentState is BISPlace ) {
//      Game.sharedInstance.gameStateMachine.enterState(GSGeneral)
//      Game.sharedInstance.buildStateMachine
    } else {
      Game.sharedInstance.gameStateMachine.enter(GSBuildItem.self)
      Game.sharedInstance.buildItemStateMachine.enter(BISPlan.self)
      Game.sharedInstance.placingObjectsQueue.append(ReceptionDesk.self)
      
    }
  }
  
  static func buildDoorTouch() -> Void {
    Game.sharedInstance.gameStateMachine.enter(GSBuildDoor.self)
  }
  
}
