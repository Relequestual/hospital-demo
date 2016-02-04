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

  var tile : Tile
  var view : SKView

  init( tile: Tile ) {
    self.tile = tile
    self.view = SKView()
  }

}



class TileTileState: TileState {

  override func didEnterWithPreviousState(previousState: GKState?) {
    super.didEnterWithPreviousState(previousState)
    tile.componentForClass(SpriteComponent)?.node.texture = SKTexture(imageNamed: "Grey Tile.png")
  }

}

class TileGrassState: TileState {

  override func didEnterWithPreviousState(previousState: GKState?) {
    super.didEnterWithPreviousState(previousState)

    let node = SKShapeNode(rectOfSize: CGSize(width: 32, height: 32))
    node.fillColor = UIColor.greenColor()
    let texture = view.textureFromNode(node)
    tile.componentForClass(SpriteComponent)?.node.texture = texture
  }

}

class TilePathState: TileState {

}

