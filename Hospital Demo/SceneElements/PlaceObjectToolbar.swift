//
//  PlaceObjectToolbar.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 10/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import HLSpriteKit

class PlaceObjectToolbar: HLToolbarNode {

  static var sharedInstance: PlaceObjectToolbar? = nil;
  
  let options = [
    "red": { PlaceObjectToolbar.redTouch() },
    "green": { PlaceObjectToolbar.greenTouch() },
    "blue": { PlaceObjectToolbar.blueTouch() }
  ]
  
  class func construct(size: CGSize, baseScene: BaseScene) -> PlaceObjectToolbar? {
    
    PlaceObjectToolbar.sharedInstance = PlaceObjectToolbar(size: size, baseScene: baseScene);
    
    return PlaceObjectToolbar.sharedInstance;
    
  }
  
  private init(size: CGSize, baseScene: BaseScene) {
    super.init()
    
    let topPoint = baseScene.view?.bounds.height
    self.anchorPoint = CGPoint(x: 0, y: 1)
    self.size = size
    self.position = CGPoint(x: 0, y: topPoint!)
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
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  class func redTouch() {
    print("red")
  }
  
  class func greenTouch() {
    print("green")
  }
  
  class func blueTouch() {
    print("blue")
  }
  
  
}