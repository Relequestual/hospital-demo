//
//  GameScene.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 13/11/2015.
//  Copyright (c) 2015 Ben Hutton. All rights reserved.
//

import SpriteKit

class GameScene: BaseScene {

  override func didMoveToView(view: SKView) {

    super.didMoveToView(view)

    //        /* Setup your scene here */
    //        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    //        myLabel.text = "Hello Hospital!";
    //        myLabel.fontSize = 45;
    //        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
    //
    //        self.addChild(myLabel)


  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    /* Called when a touch begins */

    for touch in touches {
      let location = touch.locationInNode(self)
      print(location)

      let sprite = SKSpriteNode(imageNamed:"Grey Tile.png")

      sprite.xScale = 0.5
      sprite.yScale = 0.5
      sprite.position = location

      let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)

      sprite.runAction(SKAction.repeatActionForever(action))

      self.addChild(sprite)
    }



  }

  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
  }
}
