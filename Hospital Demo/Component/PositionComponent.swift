//
//  PositionComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 23/12/2015.
//  Copyright © 2015 Ben Hutton. All rights reserved.
//

import SpriteKit
import GameplayKit


class PositionComponent: GKComponent {

  var gridPosition: CGPoint
  var spritePosition: CGPoint?

  init(gridPosition: CGPoint, spritePosition: CGPoint?=nil) {
    self.gridPosition = gridPosition
    self.spritePosition = spritePosition
    super.init()
  }
  
  init(realPosition: CGPoint) {
    self.gridPosition = (PositionComponent.getTileAtPoint(realPosition)?.component(ofType: PositionComponent.self)?.gridPosition)!
    self.spritePosition = realPosition
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  static func getTileAtPoint(_ point: CGPoint) -> Tile? {
    let nodesAtPoint = Game.sharedInstance.wolrdnode.contentNode.nodes(at: point)
    var tile: GKEntity?
    
    for node in nodesAtPoint {
      guard let entity: GKEntity = node.userData?["entity"] as? GKEntity else {continue}
      
      if (entity.isKind(of: Tile.self)) {
        tile = entity
      }
    }
    
    return tile as? Tile
  }
}
