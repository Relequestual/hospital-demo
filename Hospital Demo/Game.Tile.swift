//
//  Game.Tile.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 26/07/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import Foundation

extension Game {

//  Kept as an example of how to do extensions

  // Global wrapper function for a variable function which is called when a tile is touched
  func touchTile(tile: Tile) {
    self.touchTileDelegate?.touchTile(tile: tile)
  }

}
