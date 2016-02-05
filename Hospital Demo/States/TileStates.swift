//
//  TileStates.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 03/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class TileState : GKState{

  var tile : Tile?

  init( tile: Tile ) {
    super.init()
    self.tile = tile
  }
  
  static func createColoredTileTexture(color: UIColor) -> SKTexture {
    let node = SKShapeNode(rectOfSize: CGSize(width: 32, height: 32))
    node.lineWidth = 0
    node.fillColor = color
    return SKView().textureFromNode(node)!
  }
}


class TileTileState: TileState {

  override func didEnterWithPreviousState(previousState: GKState?) {
    super.didEnterWithPreviousState(previousState)
    tile?.componentForClass(SpriteComponent)?.node.texture = SKTexture(imageNamed: "Grey Tile.png")
  }

}

class TileGrassState: TileState {

  override func didEnterWithPreviousState(previousState: GKState?) {
    super.didEnterWithPreviousState(previousState)

    let texture = TileState.self.createColoredTileTexture(UIColor.greenColor())
    tile?.componentForClass(SpriteComponent)?.node.texture = texture
  }

}

class TilePathState: TileState {
  
  override func didEnterWithPreviousState(previousState: GKState?) {
    super.didEnterWithPreviousState(previousState)
    
    let texture = TileState.self.createColoredTileTexture(UIColor.grayColor())
    tile?.componentForClass(SpriteComponent)?.node.texture = texture
  }
  
}

extension Tile {
  
  func nextSpriteState() -> TileState.Type {
    switch self.stateMachine?.currentState {
      case is TileTileState:
        return TileGrassState.self
      case is TileGrassState:
        return TilePathState.self
      case is TilePathState:
        return TileTileState.self
      default :
        return TileTileState.self
    }
  }
  
}