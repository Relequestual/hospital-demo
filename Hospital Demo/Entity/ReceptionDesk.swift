//
//  ReceptionDesk.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 08/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import SpriteKit
import GameplayKit

class ReceptionDesk: GKEntity {

  var area = [[0,0], [1,0]]
  
  var pous = [[0,-1], [1,-1]]

//  var position: CGPoint?
  
  override init() {
    super.init()

    let blueprint = BlueprintComponent(area: area, pous: pous, pf: { position in
      self.planAtPoint(position)
    })
    self.addComponent(blueprint)
//    Add position component somewhere?
  }
  
  func planAtPoint(position: CGPoint){
    
    // Check can place object at location
    self.area = (self.componentForClass(BlueprintComponent)?.area)!
    self.pous = (self.componentForClass(BlueprintComponent)?.pous)!
    
//    Probably a nicer way of doing this... but hey ho
    for coord in self.area + self.pous {
      guard (Game.sharedInstance.tilesAtCoords[Int(position.x) + coord[0]] != nil) else {
        return
      }
      guard (Game.sharedInstance.tilesAtCoords[Int(position.x) + coord[0]]![Int(position.y) + coord[1]] != nil) else {
        return
      }
    }
    
    
    Game.sharedInstance.entityManager.node.enumerateChildNodesWithName("planned_object", usingBlock: { (node, stop) -> Void in
      node.removeFromParent()
    });

    let positionComponent = PositionComponent(x: Int(position.x), y: Int(position.y))
    addComponent(positionComponent)

    let texture = createPlannedTexture()
    let texturePOU = createPlannedPOUTexture()

    for blueprint in self.area {
      let x = Int(positionComponent.position.x) + blueprint[0]
      let y = Int(positionComponent.position.y) + blueprint[1]

      let tile = Game.sharedInstance.tilesAtCoords[x]![y]
      let node = SKSpriteNode(texture: texture)
      node.alpha = 0.6
      node.position = (tile?.componentForClass(PositionComponent)?.position)!
      
      node.zPosition = 10
      node.name = "planned_object"
      Game.sharedInstance.entityManager.node.addChild(node)
      
      tile?.stateMachine.enterState(TilePlanState)
    }
    
    for blueprint in self.pous {
      let x = Int(positionComponent.position.x) + blueprint[0]
      let y = Int(positionComponent.position.y) + blueprint[1]
      
      let tile = Game.sharedInstance.tilesAtCoords[x]![y]
      let node = SKSpriteNode(texture: texturePOU)
      node.alpha = 0.4
      node.position = (tile?.componentForClass(PositionComponent)?.position)!
      
      node.zPosition = 10
      node.name = "planned_object"
      Game.sharedInstance.entityManager.node.addChild(node)
      
      tile?.stateMachine.enterState(TilePlanState)
      
    }
    

    
//    addComponent(spriteComponent)
    
//    Game.sharedInstance.entityManager.add(self)
    
    Game.sharedInstance.plannedBuildingObject = self
  }

  func createPlannedTexture() -> SKTexture {
    let node = SKShapeNode(rectOfSize: CGSize(width: 32, height: 32))
    node.lineWidth = 0
    node.fillColor = UIColor.cyanColor()
    return SKView().textureFromNode(node)!
  }
  
  func createPlannedPOUTexture() -> SKTexture {
    let node = SKShapeNode(circleOfRadius: 24)
    node.lineWidth = 0
    node.fillColor = UIColor.orangeColor()
    return SKView().textureFromNode(node)!
  }

}

