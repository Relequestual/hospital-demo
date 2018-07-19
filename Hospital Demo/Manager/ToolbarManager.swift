//
//  ToolbarManager.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 09/11/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import SpriteKit



class ToolbarManager {

  var scene: SKScene

  var existingToolbars: [Game.rotation: Array<ToolbarProtocol>]
  var currentToolbars: [Game.rotation: ToolbarProtocol] = [:]

  let locations = [Game.rotation.north, Game.rotation.east, Game.rotation.south, Game.rotation.west]

  init(scene: SKScene) {
    print("TOOLBAR MANAGER")
    existingToolbars = [
      Game.rotation.north: [],
      Game.rotation.south: [],
      Game.rotation.east: [],
      Game.rotation.west: [],
    ]
    self.scene = scene
  }

  func add(toolbar: ToolbarProtocol, location: Game.rotation, shown: Bool = false) {
    print("Adding toolbar")
//    Extend this when needed to work for all rotations
    let menuNode = toolbar.menuNode
    menuNode.position = positionFor(side: location, shown: shown)
    menuNode.zPosition = CGFloat(ZPositionManager.WorldLayer.ui.zpos + 1000)

    var newToolbar = toolbar
    newToolbar.location = location

//    Hide toolbars at location
    for tb in existingToolbars[location]! {
      tb.hide()
    }
    existingToolbars[location]?.append(newToolbar)

    if (newToolbar.menuNode.parent == nil) {
      scene.camera!.addChild(newToolbar.menuNode)
    }

    if shown {
      show(newToolbar)
    }
  }

  func remove(_ toolbar: ToolbarProtocol) {
    toolbar.menuNode.removeFromParent()
  }

  func show(_ toolbar: ToolbarProtocol) {

    guard let location = toolbar.location else {
      print("cannot show toolbar without a location")
      return
    }

    if (currentToolbars[location] != nil) {
      currentToolbars[location]!.hide()
    }
    currentToolbars[location] = toolbar

//      Function call to determine position based on side
    toolbar.menuNode.position = positionFor(side: location, shown: true)
    toolbar.menuNode.isHidden = false
  }

  func hide(_ toolbar: ToolbarProtocol) {
    guard let location = toolbar.location else {
      print("cannot hide toolbar without a location")
      return
    }

    if (!toolbar.isHidden()) {
      toolbar.menuNode.position = positionFor(side: location, shown: false)
      toolbar.menuNode.isHidden = true
    }
  }

  func hideAll() {
    for side in locations {
      if currentToolbars[side] != nil {
        hide(currentToolbars[side]!)
      }
    }
  }

  func showAll() {
    for side in locations {
      if currentToolbars[side] != nil {
        show(currentToolbars[side]!)
      }
    }
  }

  func remove(_ location: Game.rotation, toolbar: ToolbarProtocol) {
    toolbar.hide()
    existingToolbars[location]!.first { (candidate) -> Bool in
      return toolbar as AnyObject === candidate as AnyObject
    }?.remove()

    existingToolbars[location]!.last!.menuNode.isHidden = false
    show(existingToolbars[location]!.last!)
//    Get the last toolbar and show?
//    Currently not had any need to stack toolbars in this way
  }

  //  Removes all toolbars but the first one for a side.
  // Not sure when I intended to use this... =/
  func resetSide(_ side: Game.rotation) {
    if currentToolbars[side] != nil {
      currentToolbars[side]?.hide()
      let newExistingToolbar = existingToolbars[side]?.first
      existingToolbars[side] = [newExistingToolbar!]
      show(existingToolbars[side]!.first!)
    }
  }

  // Get the position for a toolbar based on location, default hidden
  func positionFor(side: Game.rotation, shown: Bool = false) -> CGPoint {
    return positionFor(side: side, shown: shown, size: 64)
  }

  // Get the position for a toolbar based on location, hidden or not, and size
  func positionFor(side: Game.rotation, shown: Bool, size: Int) -> CGPoint {
    let viewBounds = Game.sharedInstance.mainView!.bounds
    switch side {
    case .north:
      return CGPoint(x: 0, y: 0) // Not yet implemented
    case .east:
      return CGPoint(x: shown ? Int(viewBounds.width) / 2 - size : Int(viewBounds.width) / 2, y: Int(viewBounds.height / 2))
    case .south:
      return CGPoint(x: Int(0 - viewBounds.width / 2), y: Int(0 - viewBounds.height / 2) + (shown ? size : 0))
//      return CGPoint(x: 0, y: 0)
    case .west:
      return CGPoint(x: 0, y: 0) // Not yet implemented
    }
  }

  func getDebugToolbar() -> ToolbarProtocol? {
    return existingToolbars[.east]?.first(where: { (toolbar: ToolbarProtocol) -> Bool in
      toolbar is DebugToolbar
    })
  }
}
