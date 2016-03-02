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
  
  var pous = [[0,1], [1,1]]

//  var position: CGPoint?
  
  override init() {
    super.init()

    let blueprint = BlueprintComponent(area: area, pf: { position in
      self.planAtPoint(position)
    })
    self.addComponent(blueprint)
//    Add position component somewhere?
  }
  
  func planAtPoint(position: CGPoint){
    print("planning reception desk at ")
    print(position)
    Game.sharedInstance.entityManager.node.enumerateChildNodesWithName("planned_object", usingBlock: { (node, stop) -> Void in
      node.removeFromParent()
      
    });

    let positionComponent = PositionComponent(x: Int(position.x), y: Int(position.y))
    addComponent(positionComponent)

    let texture = createPlannedTexture()

    for blueprint in self.area {
      let x = Int(positionComponent.position.x) + blueprint[0]
      let y = Int(positionComponent.position.y) + blueprint[1]

      let tile = Game.sharedInstance.tilesAtCoords[x]![y]
      let node = SKSpriteNode(texture: texture)
      node.alpha = 0.7
      node.position = (tile?.componentForClass(PositionComponent)?.position)!
      
      node.zPosition = 10
      node.name = "planned_object"
//      self.componentForClass(BlueprintComponent)?.plannedNodes.insert(node)
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

}

