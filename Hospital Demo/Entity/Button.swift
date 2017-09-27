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
  
  var toggle: Bool?
  
//  var entityTouch: ()->Void

  init(texture: SKTexture, touch_f:@escaping (Button) -> Void) {
    super.init()
    
    let spriteComponent = SpriteComponent(texture: texture)
    addComponent(spriteComponent)
    spriteComponent.addToNodeKey()
    
    
    let touchComponent = TouchableSpriteComponent(){
      touch_f(self)
    }
    addComponent(touchComponent)
    
  }
  
  
  init(texture: SKTexture, touch_start_f:@escaping (CGPoint) -> Void, touch_move_f:@escaping (CGPoint) -> Void, touch_end_f:@escaping (CGPoint) -> Void) {
    super.init()
    
    let spriteComponent = SpriteComponent(texture: texture)
    addComponent(spriteComponent)
    spriteComponent.addToNodeKey()
    
    
    let dragComponent = DraggableSpriteComponent(start: touch_start_f, move: touch_move_f, end: touch_end_f)
    addComponent(dragComponent)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
