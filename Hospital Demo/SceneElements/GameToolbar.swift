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

  let options = [
    "red": { GameToolbar.redTouch() },
    "green": { GameToolbar.greenTouch() },
    "blue": { GameToolbar.blueTouch() }
  ]


  init(size: CGSize, baseScene: BaseScene) {
    super.init()

    self.anchorPoint = CGPoint(x: 0, y: 0)
    self.size = size
    self.position = CGPoint(x: 0, y: 0)
    self.zPosition = 999

    let toolNodes = NSMutableArray()

    let redTool = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 20, height: 20))
    let greenTool = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: 20, height: 20))
    let blueTool = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: 20, height: 20))


    toolNodes.addObject(redTool)
    toolNodes.addObject(greenTool)
    toolNodes.addObject(blueTool)
    self.setTools(toolNodes as [AnyObject], tags: ["red", "green", "blue"], animation:HLToolbarNodeAnimation.SlideUp)

    self.toolTappedBlock = {(toolTag: String!) -> Void in
      baseScene.HL_showMessage("Tapped \(toolTag) tool on HLToolbarNode.")

      if let closure = self.options[toolTag] {
        closure()
      }

//      Game.sharedInstance.stateMachine.enterState(GeneralState)
    }

    //    self.registerDescendant(toolbarNode, withOptions: Set<AnyObject>.setWithObject(HLSceneChildGestureTarget))
//    baseScene.registerDescendant(self, withOptions: Set(arrayLiteral: HLSceneChildGestureTarget))

  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  class func redTouch() {
    Game.sharedInstance.gameStateMachine.enterState(GSLevelEdit)
  }

  class func greenTouch() {
    Game.sharedInstance.gameStateMachine.enterState(GSGeneral)
  }

  class func blueTouch() {
    Game.sharedInstance.gameStateMachine.enterState(GSBuild)
    Game.sharedInstance.buildStateMachine.enterState(BSPlaceItem)
  }


}