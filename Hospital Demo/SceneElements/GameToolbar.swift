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

class GameToolbar: HLToolbarNode {
  
  enum Option: String {
    case Red, Green, Blue
  }
  
  init(size: CGSize, baseScene: BaseScene) {
    super.init()
    
    self.anchorPoint = CGPoint(x: 0, y: 0)
    self.size = size
    self.position = CGPoint(x: 0, y: 0)
    self.zPosition = 999
    
    let redTool = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 20, height: 20))
    let greenTool = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: 20, height: 20))
    let blueTool = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: 20, height: 20))
    
    let toolNodes = [redTool, greenTool, blueTool]
    let tags = [Option.Red.rawValue, Option.Green.rawValue, Option.Blue.rawValue]
    self.setTools(toolNodes, tags: tags, animation:HLToolbarNodeAnimation.SlideUp)
    
    self.toolTappedBlock = {(tag: String!) -> Void in
      baseScene.HL_showMessage("Tapped \(tag) tool on HLToolbarNode.")

      GameToolbar.didTouch(tag)
      //Game.sharedInstance.stateMachine.enterState(GeneralState)
    }
    
    //self.registerDescendant(toolbarNode, withOptions: Set<AnyObject>.setWithObject(HLSceneChildGestureTarget))
    //baseScene.registerDescendant(self, withOptions: Set(arrayLiteral: HLSceneChildGestureTarget))
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  class func didTouch(tag: String) {
    guard let option = Option(rawValue: tag) else { return }
    switch option {
    case .Red:
      GameToolbar.redTouch()
    case .Green:
      GameToolbar.greenTouch()
    case .Blue:
      GameToolbar.blueTouch()
    }
  }
  
  class func redTouch() {
    Game.sharedInstance.gameStateMachine.enterState(GSLevelEdit)
  }
  
  class func greenTouch() {
    Game.sharedInstance.gameStateMachine.enterState(GSGeneral)
  }
  
  class func blueTouch() {
    
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