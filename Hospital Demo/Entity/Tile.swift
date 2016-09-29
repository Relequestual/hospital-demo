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

  enum tileTypes {
    case Tile
    case Grass
    case Path
  }
  var tileType: tileTypes
  
  var realPosition: CGPoint
  var isBuildingOn = false
  var unbuildable: Bool
  var blocked: Bool {
    didSet {
      if (blocked == true) {
        self.unbuildable = true
      }
    }
  }

  init(imageName: String, initType: tileTypes = tileTypes.Tile , x: Int, y: Int) {

    self.realPosition = CGPoint(x: x, y: y)
    self.tileType = initType
    
    switch initType {
    case tileTypes.Tile:
      self.unbuildable = false
      self.blocked = false
    case _ where (initType == tileTypes.Grass || initType == tileTypes.Path) :
      self.unbuildable = true
      self.blocked = true
    default:
      self.unbuildable = false
      self.blocked = false
    }

    super.init()

    let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
    addComponent(spriteComponent)
    spriteComponent.addToNodeKey()


    let width = Int((spriteComponent.node.texture?.size().width)!)
    let x = width * x + width / 2
    let y = width * y + width / 2

    let positionComponent = PositionComponent(gridPosition: self.realPosition, spritePosition: CGPoint(x: x, y: y))

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
    
    
//    switch Game.sharedInstance.gameStateMachine.currentState {
////      case is GSLevelEdit:
////        self.stateMachine.enterState(self.nextSpriteState())
//      
//      default:
//        print("State that we aren't interested in!")
//    }

    switch Game.sharedInstance.gameStateMachine.currentState {
    case is GSBuild:
      buildItemStateTouch()
    case is GSBuildRoom:
      buildRoomStateTouch()
    default:
      print("Game state is not of interest")
    }

  }
  
  func buildItemStateTouch() {

    switch Game.sharedInstance.buildStateMachine.currentState {
    case is BISPlan:
      print("touch with BISPlan")
      guard let placingObject: GKEntity.Type = Game.sharedInstance.placingObjectsQueue[0] else {
        //Cry
      }
      let plannedObject = placingObject.init()
      Game.sharedInstance.draggingEntiy = plannedObject
      plannedObject.componentForClass(BlueprintComponent)?.planFunctionCall((self.componentForClass(PositionComponent)?.gridPosition)!)
      
    //      Game.sharedInstance.buildStateMachine.enterState(BISPlaned)
    default:
      print("State that we aren't interested in!")
      print(Game.sharedInstance.buildStateMachine.currentState)
    }
    
  }
  
  func buildRoomStateTouch() {
    print("-- Gets to room state touch")
    guard let buildingRoom: GKEntity.Type = Game.sharedInstance.plannedRoom else {
      //Cry
      return
    }
    
    switch Game.sharedInstance.buildRoomStateMachine.currentState {
    case is BRSPrePlan:
      let plannedRoom = buildingRoom.init()
      print("planned room is")
      print(plannedRoom)
      plannedRoom.componentForClass(BuildRoomComponent)?.clearPlan()
      plannedRoom.componentForClass(BuildRoomComponent)?.planAtPoint((self.componentForClass(PositionComponent)?.gridPosition)!)
      Game.sharedInstance.buildRoomStateMachine.enterState(BRSPlan)
    default:
      print("Some state that's not accounted for yet")
      print(Game.sharedInstance.buildRoomStateMachine.currentState)
    }
    
    
  }
  
  var debugNode: SKShapeNode?
  
  func highlight (position: CGPoint, colour: UIColor = UIColor.yellowColor()) {
    
//    let position = self.componentForClass(PositionComponent)?.spritePosition
    self.debugNode = SKShapeNode(rectOfSize: CGSize(width: 50, height: 50))
    self.debugNode!.position = position
    self.debugNode!.strokeColor = colour
    self.debugNode!.zPosition = 1000000
    Game.sharedInstance.entityManager.node.addChild(self.debugNode!)
    print("====highlighting tile")
    
  }
  
  
}
