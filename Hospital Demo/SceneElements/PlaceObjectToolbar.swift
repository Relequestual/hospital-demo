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
    "left": { PlaceObjectToolbar.leftTouch() },
    "up": { PlaceObjectToolbar.upTouch() },
    "down": { PlaceObjectToolbar.downTouch() },
    "right": { PlaceObjectToolbar.rightTouch() },
    "rotate": { PlaceObjectToolbar.rotateTouch() },
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

    let arrowTexture = PlaceObjectToolbar.arrowTexture()

    let rotateBy90 = SKAction.rotateByAngle(CGFloat(GLKMathDegreesToRadians(90.0)), duration: 0)
    let rotateBy180 = SKAction.rotateByAngle(CGFloat(GLKMathDegreesToRadians(180.0)), duration: 0)
    let rotateBy270 = SKAction.rotateByAngle(CGFloat(GLKMathDegreesToRadians(270.0)), duration: 0)


    let leftArrowTool = SKSpriteNode(texture: arrowTexture, size: CGSize(width: 20, height: 20))
    leftArrowTool.runAction(rotateBy90)
    toolNodes.addObject(leftArrowTool)

    let upArrowTool = SKSpriteNode(texture: arrowTexture, size: CGSize(width: 20, height: 20))
    toolNodes.addObject(upArrowTool)

    let downArrowTool = SKSpriteNode(texture: arrowTexture, size: CGSize(width: 20, height: 20))
    downArrowTool.runAction(rotateBy180)
    toolNodes.addObject(downArrowTool)

    let rightArrowTool = SKSpriteNode(texture: arrowTexture, size: CGSize(width: 20, height: 20))
    rightArrowTool.runAction(rotateBy270)
    toolNodes.addObject(rightArrowTool)

    let size = CGSize(width: 20, height: 20)
    let rotateNode = SKShapeNode(ellipseOfSize: size)
    let view = SKView()
    let rotateTexture: SKTexture = view.textureFromNode(rotateNode)!
    let rotateTool = SKSpriteNode(texture: rotateTexture, size: CGSize(width: 20, height: 20))

    toolNodes.addObject(rotateTool)


    self.setTools(toolNodes as [AnyObject], tags: ["left", "up", "down", "right", "rotate"], animation:HLToolbarNodeAnimation.SlideUp)
    
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
  
  class func upTouch() {
    print("up")
  }

  class func downTouch() {
    print("down")
  }

  class func leftTouch() {
    print("left")
  }

  class func rightTouch() {
    print("right")
  }

  class func rotateTouch() {
    print("rotate")
  }


  class func arrowTexture() -> SKTexture {

    let arrow = CGPathCreateMutable()

    CGPathAddLines(arrow, nil, [
      CGPoint(x: 10, y: 0),
      CGPoint(x: 10, y: 20),
      CGPoint(x: 0, y: 20),
      CGPoint(x: 15, y: 35),
      CGPoint(x: 30, y: 20),
      CGPoint(x: 20, y: 20),
      CGPoint(x: 20, y: 0),
      CGPoint(x: 10, y: 0),
    ], 8)

    let shape = SKShapeNode()
    shape.path = arrow
    let view = SKView()
    let arrowTexture: SKTexture = view.textureFromNode(shape)!

    return arrowTexture

  }
  
  
}