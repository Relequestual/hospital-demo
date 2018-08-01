//
//  StateProtocols.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 01/08/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

protocol StateTileTouch {

  func touchTile(tile: Tile)
  func didEnter(from previousState: GKState?)
  func willExit(to nextState: GKState)
}


class RQTileTouchState: GKState, StateTileTouch {

  override func didEnter(from previousState: GKState?) {
    print("didEnter state for StateTileTouch")
    Game.sharedInstance.touchTile = self.touchTile
  }

  override func willExit(to nextState: GKState) {
    print("didExit state for StateTileTouch")
    Game.sharedInstance.touchTile = nil
  }

  func touchTile(tile: Tile) {
    // Noop
  }

}
