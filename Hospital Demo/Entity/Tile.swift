//
//  Tile.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 19/12/2015.
//  Copyright © 2015 Ben Hutton. All rights reserved.
//

import SpriteKit
import GameplayKit

class Tile: GKEntity {

  var stateMachine: GKStateMachine!

  init(imageName: String, initState: TileState.Type, x: Int, y: Int) {
    super.init()

    let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
    addComponent(spriteComponent)
    spriteComponent.addToNodeKey()

    stateMachine = GKStateMachine(states: [
        TileTileState(tile: self),
        TileGrassState(tile: self),
        TilePathState(tile: self)
      ])

    stateMachine.enterState(TileState)

    let width = Int((spriteComponent.node.texture?.size().width)!)
    let x = width * x + width / 2
    let y = width * y + width / 2

    let positionComponent = PositionComponent(x: x, y: y)

    addComponent(positionComponent)
    
    spriteComponent.node.position = CGPoint(x: x, y: y)
    
    let touchableComponent = TouchableSpriteComponent(){
      print("function of spritecomponent?")
      self.handleTouch()
      
    }
    addComponent(touchableComponent)
    
    let spriteDebugComponent = SpriteDebugComponent(node: spriteComponent.node)
    addComponent(spriteDebugComponent)

  }
  
  func handleTouch() {
    print("I am a TILE!")
    print(self.componentForClass(PositionComponent)?.x)
    print(self.componentForClass(PositionComponent)?.y)
    // Do some more things like change state of another component
  }
}
