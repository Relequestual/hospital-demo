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

  var staffPous = [[0, 1], [1, 1]]

  override init() {
    super.init()

    let blueprint = BlueprintComponent(area: area, pous: pous, staffPous: staffPous, pf: { position in
      self.planAtPoint(position)
    })
    self.addComponent(blueprint)

    let draggableComponent = DraggableSpriteComponent(
      start: self.dragStartHandler,
      move: self.dragMoveHandler,
      end: self.dragEndHandler
    )
    self.addComponent(draggableComponent)
    self.addComponent(BuildComponent())

    let graphicNode = SKShapeNode(rectOfSize: CGSize(width:128, height:64), cornerRadius: 0.2)
    graphicNode.fillColor = UIColor.purpleColor()
    let view = SKView()
    let graphicTexture: SKTexture = view.textureFromNode(graphicNode)!
    
    let spriteComponent = SpriteComponent(texture: graphicTexture)
    addComponent(spriteComponent)
    spriteComponent.addToNodeKey()
    
  }

  func dragStartHandler() {
    print("RD Start drag")
  }
  
  func dragMoveHandler(point: CGPoint) {
    print("RD Move drag")
    
    if (self.componentForClass(BlueprintComponent)?.status == BlueprintComponent.Status.Built) {
      print("No dragging built items")
      return
    }
    
//    self.componentForClass(SpriteComponent)?.node.position = point
    let nodesAtPoint = Game.sharedInstance.wolrdnode.contentNode.nodesAtPoint(point)
    
    for node in nodesAtPoint {
      guard let entity: GKEntity = node.userData?["entity"] as? GKEntity else {continue}
      
      if (entity.isKindOfClass(Tile)) {
        self.componentForClass(BlueprintComponent)?.planFunctionCall((entity.componentForClass(PositionComponent)?.gridPosition)!)
      }

    }
  }
  
  func dragEndHandler() {
    if( self.componentForClass(BlueprintComponent)?.status != BlueprintComponent.Status.Built ){
      self.componentForClass(BlueprintComponent)?.displayBuildObjectConfirm()
    }
    print("RD End drag")
  }
  
  func planAtPoint(position: CGPoint){
    
//    Do function from build component
  }
  

}

