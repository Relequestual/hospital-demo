//
//  ToolbarManager.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 09/11/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import HLSpriteKit
import SpriteKit

class ToolbarManager {
  var scene: HLScene

//  Replace all instances of Game.sharedInstance.gametoolbar with something else like current toolbar from
//  the toolbar manager. or more likely a function in the toolbar manager
  var existingToolbars: [Game.rotation: Array<HLToolbarNode>]
  var currentToolbars: [Game.rotation: HLToolbarNode] = [:]

  let locations = [Game.rotation.north, Game.rotation.east, Game.rotation.south, Game.rotation.west]

  init(scene: HLScene) {
    print("TOOLBAR MANAGER")
    self.scene = scene
    existingToolbars = [
      Game.rotation.north: [],
      Game.rotation.south: [],
      Game.rotation.east: [],
      Game.rotation.west: [],
    ]
  }

  func addToolbar(_ toolbar: HLToolbarNode, location: Game.rotation, shown: Bool = false) {
    print("Adding toolbar")
//    Extend this when needed to work for all rotations
//    toolbar.position = CGPoint(x: 0, y: -64)
    toolbar.position = positionForSide(side: location, shown: shown)
    toolbar.zPosition = CGFloat(ZPositionManager.WorldLayer.ui.zpos)

    toolbar.hlSetGestureTarget(toolbar)
//    Hide toolbars at location
    for tb in existingToolbars[location]! {
      tb.hide(animated: false)
    }
    existingToolbars[location]?.append(toolbar)
    if shown {
      toolbar.isHidden = true
      show(toolbar)
    }
  }

  func hideAnimated(_ side: Game.rotation, animated: Bool) {
    if existingToolbars[side] != nil {
      for toolbar in existingToolbars[side]! {
        toolbar.hide(animated: animated)
        toolbar.isHidden = true
      }
    }
  }

  func hideAnimated(toolbar: HLToolbarNode, animated: Bool = true) {
    toolbar.hide(animated: animated)
    toolbar.isHidden = true
  }

  func show(_ toolbar: HLToolbarNode) {
    var toolbarLocation: Game.rotation?
    for location in locations {
      if ((existingToolbars[location]?.contains(toolbar))) == true {
        toolbarLocation = location
        print("set as current toolbar")
        if currentToolbars[location] != nil {
          currentToolbars[location]!.isHidden = true
        }
        currentToolbars[location] = toolbar
      }
    }

    if toolbar.isHidden {
      toolbar.show(
        withOrigin: positionForSide(side: toolbarLocation!, shown: false),
        finalPosition: positionForSide(side: toolbarLocation!, shown: true),
        fullScale: 1.0, animated: true)
      toolbar.isHidden = false
      if (toolbar.parent) == nil {
        scene.camera!.addChild(toolbar)
        scene.registerDescendant(toolbar, withOptions: Set(arrayLiteral: HLSceneChildGestureTarget))
      }
    }
  }

  func hideAll() {
    for side in locations {
      hideAnimated(side, animated: true)
    }
  }

  func showAll() {
    for side in locations {
      if currentToolbars[side] != nil {
        show(currentToolbars[side]!)
      }
    }
  }

  func remove(_ location: Game.rotation, toolbar: HLToolbarNode) {
    toolbar.hide(animated: true)
    existingToolbars[location]!.remove(at: existingToolbars[location]!.index(of: toolbar)!)
    existingToolbars[location]!.last!.isHidden = true
    show(existingToolbars[location]!.last!)
//    Get the last toolbar and show.
  }

  //  Removes all toolbars but the first one for a side.
  func resetSide(_ side: Game.rotation) {
    if currentToolbars[side] != nil {
      currentToolbars[side]?.hide(animated: true)
      currentToolbars[side]?.isHidden = true
      let newExistingToolbars = existingToolbars[side]?.first
      existingToolbars[side] = [newExistingToolbars!]
      show(existingToolbars[side]!.first!)
    }
  }

  func positionForSide(side: Game.rotation, shown: Bool = false) -> CGPoint {
    let halfFrameHeight = Int(Game.sharedInstance.mainView!.bounds.height / 2)
    let halfFrameWidth = Int(Game.sharedInstance.mainView!.bounds.width / 2)
    let halftbsize = 64 / 2
    switch side {
    case .north:
      return CGPoint(x: 0, y: 0)
    case .east:
      return CGPoint(x: shown ? 0 + halfFrameWidth - halftbsize : 0 + halfFrameWidth, y: 0 + halftbsize)
    case .south:
      return CGPoint(x: 0, y: shown ? 0 - halfFrameHeight + halftbsize : 0 - halfFrameHeight)
    case .west:
      return CGPoint(x: 0, y: 0)
    }
  }

  func getDebugToolbar() -> HLToolbarNode? {
    return existingToolbars[.east]?.first(where: { (toolbar: HLToolbarNode) -> Bool in
      toolbar.isKind(of: DebugToolbar.self)
    })
  }
}
