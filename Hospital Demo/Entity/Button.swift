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

  init(texture: SKTexture, touch_f:() -> Void) {
    super.init()
    
    let spriteComponent = SpriteComponent(texture: texture)
    addComponent(spriteComponent)
    spriteComponent.addToNodeKey()
    
    
    let touchComponent = TouchableSpriteComponent(){
      touch_f()
    }
    addComponent(touchComponent)
    
  }
  
  
  init(texture: SKTexture, touch_start_f:(CGPoint) -> Void, touch_move_f:(CGPoint) -> Void, touch_end_f:(CGPoint) -> Void) {
    super.init()
    
    let spriteComponent = SpriteComponent(texture: texture)
    addComponent(spriteComponent)
    spriteComponent.addToNodeKey()
    
    
    let dragComponent = DraggableSpriteComponent(start: touch_start_f, move: touch_move_f, end: touch_end_f)
    addComponent(dragComponent)
    
  }

}