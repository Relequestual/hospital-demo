//
//  Convert.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 29/03/2017.
//  Copyright © 2017 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

class UtilConvert {
  class func gridToSpritePosition(gridPosition: CGPoint) -> CGPoint? {
    guard let tile = Game.sharedInstance.tilesAtCoords[Int(gridPosition.x)]?[Int(gridPosition.y)] else {
      // No tile at this position
      return nil
    }
    return (tile.component(ofType: PositionComponent.self)?.spritePosition.self)!
  }
}
