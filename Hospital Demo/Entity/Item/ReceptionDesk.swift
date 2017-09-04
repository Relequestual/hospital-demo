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

  var area = [CGPoint(x:0,y:0), CGPoint(x:1,y:0)]
  
  var pous = [CGPoint(x:0,y:-1), CGPoint(x:1,y:-1)]

  var staffPous = [CGPoint(x:0,y:1), CGPoint(x:1,y:1)]

  override init() {
    super.init()
    let blueprint = ItemBlueprintComponent(area: area, pous: pous, staffPous: staffPous, pf: { position in
      self.planAtPoint(position)
    })
    self.addComponent(blueprint)

    let draggableComponent = DraggableSpriteComponent(
      start: self.dragStartHandler,
      move: self.dragMoveHandler,
      end: self.dragEndHandler
    )
    self.addComponent(draggableComponent)
    self.addComponent(BuildItemComponent())

    let graphicNode = SKShapeNode(rectOf: CGSize(width:110, height:55), cornerRadius: 0.2)
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
    
    if (self.component(ofType: ItemBlueprintComponent.self)?.status == ItemBlueprintComponent.Status.built) {
      print("No dragging built items")
      return
    }
    
//    self.componentForClass(SpriteComponent.self)?.node.position = point
    let nodesAtPoint = Game.sharedInstance.wolrdnode.contentNode.nodes(at: point)
        
    for node in nodesAtPoint {
      guard let entity: GKEntity = node.userData?["entity"] as? GKEntity else {continue}
      
      if (entity.isKind(of: Tile.self)) {
        self.component(ofType: ItemBlueprintComponent.self)?.planFunctionCall((entity.component(ofType: PositionComponent.self)?.gridPosition)!)
      }

    }
  }
  
  func dragEndHandler(_ point: CGPoint) {
    if( self.component(ofType: ItemBlueprintComponent.self)?.status != ItemBlueprintComponent.Status.built ){
      self.component(ofType: ItemBlueprintComponent.self)?.displayBuildObjectConfirm()
    }
    print("RD End drag")
  }
  
  func planAtPoint(_ position: CGPoint){
    
//    Do function from build component
  }
  

}

