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

    let graphicNode = SKShapeNode(rectOf: CGSize(width:128, height:64), cornerRadius: 0.2)
    graphicNode.fillColor = UIColor.purple
    let view = SKView()
    let graphicTexture: SKTexture = view.texture(from: graphicNode)!
    
    let spriteComponent = SpriteComponent(texture: graphicTexture)
    addComponent(spriteComponent)
    spriteComponent.addToNodeKey()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func dragStartHandler(_ point: CGPoint) {
    print("RD Start drag")
  }
  
  func dragMoveHandler(_ point: CGPoint) {
    print("RD Move drag")
    
    if (self.component(ofType: BlueprintComponent.self)?.status == BlueprintComponent.Status.built) {
      print("No dragging built items")
      return
    }
    
//    self.componentForClass(SpriteComponent.self)?.node.position = point
    let nodesAtPoint = Game.sharedInstance.wolrdnode.contentNode.nodes(at: point)
        
    for node in nodesAtPoint {
      guard let entity: GKEntity = node.userData?["entity"] as? GKEntity else {continue}
      
      if (entity.isKind(of: Tile.self)) {
        self.component(ofType: BlueprintComponent.self)?.planFunctionCall((entity.component(ofType: PositionComponent.self)?.gridPosition)!)
      }

    }
  }
  
  func dragEndHandler(_ point: CGPoint) {
    if( self.component(ofType: BlueprintComponent.self)?.status != BlueprintComponent.Status.built ){
      self.component(ofType: BlueprintComponent.self)?.displayBuildObjectConfirm()
    }
    print("RD End drag")
  }
  
  func planAtPoint(_ position: CGPoint){
    
//    Do function from build component
  }
  

}
