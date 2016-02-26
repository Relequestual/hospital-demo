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

  let area = [[0,0], [1,0]]

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

    let positionComponent = PositionComponent(x: Int(position.x), y: Int(position.y))
    addComponent(positionComponent)

    for blueprint in self.area {

      let x = Int(positionComponent.position.x) + blueprint[0]
      let y = Int(positionComponent.position.y) + blueprint[1]

      Game.sharedInstance.tilesAtCoords[x]![y]?.stateMachine.enterState(TilePlanState)

    }
    Game.sharedInstance.plannedBuildingObject = self
  }


}

