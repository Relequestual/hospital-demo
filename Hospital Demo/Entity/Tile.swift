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

  var realPosition: CGPoint
  
  var previousState: GKState.Type?
  
  var isBuildingOn = false

  init(imageName: String, initState: TileState.Type, x: Int, y: Int) {

    self.realPosition = CGPoint(x: x, y: y)

    super.init()

    let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
    addComponent(spriteComponent)
    spriteComponent.addToNodeKey()

    stateMachine = GKStateMachine(states: [
        TileTileState(tile: self),
        TileGrassState(tile: self),
        TilePathState(tile: self),
      ])

    stateMachine.enterState(initState)

    let width = Int((spriteComponent.node.texture?.size().width)!)
    let x = width * x + width / 2
    let y = width * y + width / 2

    let positionComponent = PositionComponent(x: x, y: y)

    addComponent(positionComponent)
    
    spriteComponent.node.position = CGPoint(x: x, y: y)
    
    let touchableComponent = TouchableSpriteComponent(){
      self.handleTouch()

    }

    addComponent(touchableComponent)
    
    let spriteDebugComponent = SpriteDebugComponent(node: spriteComponent.node)
    addComponent(spriteDebugComponent)

  }
  
  func handleTouch() {
    // Do some more things like change state of another component
//    print(Game.sharedInstance.gameStateMachine.currentState)
    
    
    switch Game.sharedInstance.gameStateMachine.currentState {
      case is GSLevelEdit:
        self.stateMachine.enterState(self.nextSpriteState())
      
      default:
        print("State that we aren't interested in!")
        print(self.stateMachine.currentState)
    }
    
    switch Game.sharedInstance.buildStateMachine.currentState {
    case is BSPlaceItem:
      
      guard let placingObject: GKEntity.Type = Game.sharedInstance.placingObjectsQueue[0] else {
        //Cry
      }
      let plannedObject = placingObject.init()
      plannedObject.componentForClass(BlueprintComponent)?.planFunctionCall(self.realPosition)
      
//      Do the below but elsewhere, like using blueprint component
      var graphicNode = plannedObject.componentForClass(SpriteComponent)?.node
      graphicNode?.zPosition = 100
      
      let nodeArea = plannedObject.componentForClass(BlueprintComponent)?.area
      
//      This method of working the graphic offset will need to change to account for rotation
      
      let mx = nodeArea?.map({ ( coord: [Int] ) -> Int in
        return coord[0]
      }).maxElement()
      
      let my = nodeArea?.map({ ( coord: [Int] ) -> Int in
        return coord[1]
      }).maxElement()
      
      var nodePosition = self.componentForClass(SpriteComponent)?.node.position
      nodePosition = CGPoint(x: Int(nodePosition!.x) + 32 * mx!, y: Int(nodePosition!.y) + 32 * my!)
      
      
      graphicNode?.position = nodePosition!
      Game.sharedInstance.wolrdnode.contentNode.addChild(graphicNode!)
      
      
      


//      Get co-ords of tile here
      Game.sharedInstance.buildStateMachine.enterState(BSPlanedItem)
      

    default:
      print("State that we aren't interested in!")
      print(Game.sharedInstance.buildStateMachine.currentState)
    }

  }

}
