//
//  Game.Tile.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 26/07/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import Foundation

extension Game {

  // Global wrapper function for a variable function which is called when a tile is touched
  func touchTile(tile: Tile) {
    guard self.touchTile != nil else {
      return
    }

    self.touchTile!(tile)
  }

}
