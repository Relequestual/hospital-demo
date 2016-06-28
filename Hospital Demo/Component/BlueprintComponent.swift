//
//  BlueprintComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 10/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//


import SpriteKit
import GameplayKit

class BlueprintComponent: GKComponent {
  
  var area : [[Int]]
  var pous : [[Int]]
  var confirm = CGPoint(x: 0,y: 1)
  var deny = CGPoint(x: 1, y: 1)
  
  var baring = Game.rotation.North

  var planFunction: (position: CGPoint)->Void;
  
  enum Status {
    case Planning
    case Planned
    case Built
  }

  var status = Status.Planning
  
  init(area: [[Int]], pous: [[Int]], pf:(position: CGPoint) -> Void) {
    self.area = area
    self.pous = pous
    self.planFunction = pf
  }

  func planFunctionCall(position: CGPoint) {
    self.planFunction(position: position)
    
    var plannedObject = self.entity!
    
    var graphicNode = plannedObject.componentForClass(SpriteComponent)?.node
    graphicNode?.zPosition = 100
    graphicNode?.name = "planned_object"
    graphicNode?.alpha = 0.6
    
    let nodeArea = plannedObject.componentForClass(BlueprintComponent)?.area
    
    //      This method of working the graphic offset will need to change to account for rotation
    
    print(nodeArea)
    
    var max = nodeArea?.map({ ( coord: [Int] ) -> Int in
      return coord[0]
    }).maxElement()
    
    var may = nodeArea?.map({ ( coord: [Int] ) -> Int in
      return coord[1]
    }).maxElement()
    
    var mix = nodeArea?.map({ ( coord: [Int] ) -> Int in
      return coord[0]
    }).minElement()
    
    var miy = nodeArea?.map({ ( coord: [Int] ) -> Int in
      return coord[1]
    }).minElement()
    
    var x: Int
    var y: Int
    
    switch self.baring {
      case Game.rotation.North:
        x = max!
        y = may!
      case Game.rotation.East:
        x = max!
        y = miy!
      case Game.rotation.South:
        x = mix!
        y = miy!
      case Game.rotation.West:
        x = max!
        y = may!
    }
    print(self.baring)
    print ("x is")
    print (x)
    print ("y is")
    print (y)

    var nodePosition = Game.sharedInstance.tilesAtCoords[Int(position.x)]![Int(position.y)]!.componentForClass(PositionComponent)?.spritePosition
    nodePosition = CGPoint(x: Int(nodePosition!.x) + 32 * x, y: Int(nodePosition!.y) + 32 * y)
    
    
    graphicNode?.position = nodePosition!
    Game.sharedInstance.wolrdnode.contentNode.addChild(graphicNode!)
    
  }
  
  func rotate(var previousRotation: Game.rotation) {
    previousRotation.next()

    let currentRotaton = self.entity?.componentForClass(SpriteComponent)?.node.zRotation
    var action = SKAction.rotateToAngle(currentRotaton! - CGFloat(M_PI / 2) , duration: NSTimeInterval(0.1))


    self.entity?.componentForClass(SpriteComponent)?.node.runAction(action, withKey: "rotate")


    let newRotation = previousRotation
    

      for var i = 0; i < self.area.count; i++ {
        var coord = self.area[i]
        coord = [coord[1], -coord[0]]
        self.area[i] = coord
      }
      for var i = 0; i < self.pous.count; i++ {
        var coord = self.pous[i]
        coord = [coord[1], -coord[0]]
        self.pous[i] = coord
      }
//        print(self.area)


    self.baring = newRotation
  }
  
  func canPlanAtPoint(point: CGPoint) -> Bool {
    
    for coord in self.area + self.pous {
      guard (Game.sharedInstance.tilesAtCoords[Int(point.x) + coord[0]] != nil) else {
        return false
      }
      guard let tile = Game.sharedInstance.tilesAtCoords[Int(point.x) + coord[0]]![Int(point.y) + coord[1]] else {
        return false
      }

//      if !(tile.stateMachine.currentState is TileTileState) {
//        return false
//      }
    }
    
    return true
  }
  
  func displayBuildObjectConfirm() {
    
    let gridPosition = entity?.componentForClass(PositionComponent)?.gridPosition
    let tickPosition = entity?.componentForClass(BlueprintComponent)?.confirm
    let crossPosition = entity?.componentForClass(BlueprintComponent)?.deny
    
    var finalTickPosition = CGPoint(x: gridPosition!.x + tickPosition!.x, y: gridPosition!.y + tickPosition!.y)
    finalTickPosition = CGPoint(x: finalTickPosition.x * 64 + 32, y: finalTickPosition.y * 64 + 32)
    
    var finalCrossPosition = CGPoint(x: gridPosition!.x + crossPosition!.x, y: gridPosition!.y + crossPosition!.y)
    finalCrossPosition = CGPoint(x: finalCrossPosition.x * 64 + 32, y: finalCrossPosition.y * 64 + 32)
    
    //    re colouring black is not easy. Will just make actual green / red colour graphics. Makes sense anyway. =/
    var tickTexture = SKTexture(imageNamed: "Graphics/tick.png")
//    var tickNode = SKSpriteNode(texture: tickTexture, size: CGSize(width: tickTexture.size().width / 2, height: tickTexture.size().height / 2))
    
    var tickEntity = Button(texture: tickTexture, f: {
      self.confirmPlan()
    })
    var tickNode = tickEntity.componentForClass(SpriteComponent)!.node
    
    tickNode.size = CGSize(width: tickTexture.size().width / 2, height: tickTexture.size().height / 2)
    tickNode.position = finalTickPosition
    tickNode.name = "planned_object"
    tickNode.zPosition = 20
    
    Game.sharedInstance.entityManager.node.addChild(tickNode)

    var crossTexture = SKTexture(imageNamed: "Graphics/cross.png")
    var crossEntity = Button(texture: crossTexture, f: {
      print("tap cross")
      self.cancelPlan()
    })
    
    var crossNode = crossEntity.componentForClass(SpriteComponent)!.node
    crossNode.texture = crossTexture
    crossNode.size = CGSize(width: crossTexture.size().width / 2, height: crossTexture.size().height / 2)
    crossNode.position = finalCrossPosition
    crossNode.name = "planned_object"
    crossNode.zPosition = 20
    
    Game.sharedInstance.entityManager.node.addChild(crossNode)
    
  }
  
  func confirmPlan() {
    
    let node: SKSpriteNode = (Game.sharedInstance.plannedBuildingObject?.componentForClass(SpriteComponent)?.node)!
    self.clearPlan()
    node.alpha = 1
    node.name = ""
    self.status = Status.Built
    Game.sharedInstance.entityManager.add(self.entity!)
  }
  
  func cancelPlan() {
    self.clearPlan()
  }
  
  func clearPlan() {
    Game.sharedInstance.entityManager.node.enumerateChildNodesWithName("planned_object", usingBlock: { (node, stop) -> Void in
      node.removeFromParent()
    });
    Game.sharedInstance.plannedBuildingObject = nil
    Game.sharedInstance.draggingEntiy = nil
    Game.sharedInstance.placingObjectsQueue.removeFirst()
    Game.sharedInstance.buildStateMachine.enterState(BSNoBuild)

  }
  
}
