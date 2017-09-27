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
    case tile
    case grass
    case path
  }

  var tileType: tileTypes
  
  var isBuildingOn = false
  var unbuildable: Bool
  var isRoomFloor = false
  var blocked: Bool {
    didSet {
      if (blocked == true) {
        self.unbuildable = true
        walls.setAll(toBool: true)
      }
    }
  }
  
  var walls = sides_blocked_status()
  
  struct sides_blocked_status {
    
    var index = [
      Game.rotation.north: false,
      Game.rotation.east: false,
      Game.rotation.south: false,
      Game.rotation.west: false
    ]
    
    var sprites: Dictionary<Game.rotation, SKShapeNode?> = [:]
    
    mutating func addWall(ofBaring: Game.rotation) {
      index[ofBaring] = true
      
    }
    
    mutating func removeWall(ofBaring: Game.rotation) {
      index[ofBaring] = false
    }
    
    
    func get(baring: Game.rotation) -> Bool {
      return index[baring]!
    }
    
    mutating func setAll(toBool: Bool) {
      for i in index.keys {
        index[i] = toBool
      }
    }
    
    func anyBlocked() -> Bool {
      return index.values.contains(true)
    }
  }

  let wallVert = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 5, height: 64))
  let wallHoriz = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 64, height: 5))


  func addWall(ofBaring: Game.rotation, room: Room) {
    self.walls.addWall(ofBaring: ofBaring)
    let sprite: SKShapeNode
    if (ofBaring == .north || ofBaring == .south) {
      sprite = wallHoriz.copy() as! SKShapeNode
    }else{
      sprite = wallVert.copy() as! SKShapeNode
    }
    sprite.fillColor = UIColor.black
    sprite.position = (self.component(ofType: PositionComponent.self)?.spritePosition)!
    switch ofBaring {
    case .north:
      sprite.position = CGPoint(x: sprite.position.x - 32, y: sprite.position.y + 32 - 5)
    case .south:
      sprite.position = CGPoint(x: sprite.position.x - 32, y: sprite.position.y - 32)
    case .east:
      sprite.position = CGPoint(x: sprite.position.x + 32 - 5, y: sprite.position.y - 32)
    case .west:
      sprite.position = CGPoint(x: sprite.position.x - 32, y: sprite.position.y - 32)
    }
    
    sprite.zPosition = CGFloat(ZPositionManager.WorldLayer.world.zpos + 1)
    self.walls.sprites[ofBaring] = sprite
    Game.sharedInstance.entityManager.node.addChild(sprite)
    room.walls.append(sprite)
  }


  init(imageName: String, initType: tileTypes = tileTypes.tile , x: Int, y: Int) {

    self.tileType = initType
    
    switch initType {
    case tileTypes.tile:
      self.unbuildable = false
      self.blocked = false
    case _ where (initType == tileTypes.grass || initType == tileTypes.path) :
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
    let sx = width * x + width / 2
    let sy = width * y + width / 2

    let positionComponent = PositionComponent(gridPosition: CGPoint(x: x, y: y), spritePosition: CGPoint(x: sx, y: sy))

    addComponent(positionComponent)
    
    spriteComponent.node.position = CGPoint(x: x, y: y)
    
    let touchableComponent = TouchableSpriteComponent(){
      self.handleTouch()

    }

    addComponent(touchableComponent)
    
    let spriteDebugComponent = SpriteDebugComponent(node: spriteComponent.node)
    addComponent(spriteDebugComponent)

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    case is GSBuildItem:
      buildItemStateTouch()
    case is GSBuildRoom:
      buildRoomStateTouch()
    default:
      print("Game state is not of interest")
    }

  }
  
  func buildItemStateTouch() {
    switch Game.sharedInstance.buildItemStateMachine.currentState {
    case is BISPlan:

      guard let placingObject: GKEntity.Type = Game.sharedInstance.placingObjectsQueue.first else {
        return
      }

      let plannedObject = placingObject.init()
      Game.sharedInstance.draggingEntiy = plannedObject
      plannedObject.component(ofType: ItemBlueprintComponent.self)?.planFunctionCall((self.component(ofType: PositionComponent.self)?.gridPosition)!)
      
      
    //      Game.sharedInstance.buildStateMachine.enterState(BISPlaned)
    default:
      print("State that we aren't interested in!")
      print(Game.sharedInstance.buildItemStateMachine.currentState!)
    }
    
  }
  
  func buildRoomStateTouch() {
    print("Tile#buildRoomStateTouch")
    print("-- Gets to room state touch")

    switch Game.sharedInstance.buildRoomStateMachine.currentState {
    case is BRSPrePlan:
      let plannedRoom = Room.init()
      print("planned room is")
      print(plannedRoom)
      plannedRoom.component(ofType: BuildRoomComponent.self)?.clearPlan()
      plannedRoom.component(ofType: BuildRoomComponent.self)?.planAtPoint((self.component(ofType: PositionComponent.self)?.gridPosition)!)
      plannedRoom.component(ofType: BuildRoomComponent.self)?.needConfirmBounds()
      Game.sharedInstance.buildRoomStateMachine.enter(BRSPlan.self)
      Game.sharedInstance.buildRoomStateMachine.roomBuilding = plannedRoom
      
    default:
      print("Some state that's not accounted for yet")
      print(Game.sharedInstance.buildRoomStateMachine.currentState ?? "No current state")
    }
    
    
  }
  
  var debugNode: SKShapeNode?
  
  func highlight (_ position: CGPoint, colour: UIColor = UIColor.yellow) {
    
//    let position = self.componentForClass(PositionComponent.self)?.spritePosition
    self.debugNode = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
    self.debugNode!.position = position
    self.debugNode!.strokeColor = colour
    self.debugNode!.zPosition = 1000000
    Game.sharedInstance.entityManager.node.addChild(self.debugNode!)
    print("====highlighting tile")
    
  }
  
  
}
