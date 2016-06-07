//
//  Button.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 05/06/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import SpriteKit
import GameplayKit


class Button: GKEntity {
  
  var enabled = true
  
//  var entityTouch: ()->Void

  init(texture: SKTexture, f:() -> Void) {
    super.init()
    
    let spriteComponent = SpriteComponent(texture: texture)
    addComponent(spriteComponent)
    spriteComponent.addToNodeKey()
    
    
    let touchComponent = TouchableSpriteComponent(){
      f()
    }
    addComponent(touchComponent)
    
  }

}