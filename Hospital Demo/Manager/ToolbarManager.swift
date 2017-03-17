//
//  ToolbarManager.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 09/11/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import SpriteKit
import HLSpriteKit

class ToolbarManager {
  
  var scene: HLScene

//  Replace all instances of Game.sharedInstance.gametoolbar with something else like current toolbar from
//  the toolbar manager. or more likely a function in the toolbar manager
  var existingToolbars: [Game.rotation : Array<HLToolbarNode>]
  var currentToolbars: [Game.rotation : HLToolbarNode] = [:]
  
  let locations = [Game.rotation.North, Game.rotation.East, Game.rotation.South, Game.rotation.West]
  
  init(scene: HLScene) {
    print("TOOLBAR MANAGER")
    self.scene = scene
    self.existingToolbars = [
      Game.rotation.North: [],
      Game.rotation.South: [],
      Game.rotation.East: [],
      Game.rotation.West: [],
    ]
  }
  
  
  func addToolbar(toolbar: HLToolbarNode, location: Game.rotation, shown: Bool = false) -> Void{
    print("Adding toolbar")
//    Extend this when needed to work for all rotations
    if (location == Game.rotation.South) {
      
      toolbar.position = CGPoint(x: 0, y: -64)
      toolbar.zPosition = CGFloat(ZPositionManager.WorldLayer.ui.zpos)
    }
    
    toolbar.hlSetGestureTarget(toolbar)
//    Hide toolbars at location
    for tb in self.existingToolbars[location]! {
      tb.hideAnimated(false)
    }
    self.existingToolbars[location]?.append(toolbar)
    if (shown) {
      toolbar.hidden = true
      self.show(toolbar)
    }
    
  }
  
  
  func hideAnimated(side: Game.rotation, animated: Bool) {
    
    if (existingToolbars[side] != nil) {
      for toolbar in existingToolbars[side]! {
        toolbar.hideAnimated(animated)
        toolbar.hidden = true
      }
    }
  }
  
  func show(toolbar: HLToolbarNode) -> Void{
    
    for location in self.locations {
      if (((self.existingToolbars[location]?.contains(toolbar))) == true){
        print("set as current toolbar")
        if (self.currentToolbars[location] != nil) {
          self.currentToolbars[location]!.hidden = true
        }
        self.currentToolbars[location] = toolbar
      }
    }
    
    if (toolbar.hidden) {
      toolbar.showWithOrigin(CGPoint(x: 0, y: -64), finalPosition: CGPoint(x: 0, y: 0), fullScale: 1.0, animated: true)
      toolbar.hidden = false
      if ((toolbar.parent) == nil){
        self.scene.addChild(toolbar)
        self.scene.registerDescendant(toolbar, withOptions: Set(arrayLiteral: HLSceneChildGestureTarget))
      }
    }
  }
  
  func hideAll() {
    for side in locations {
      self.hideAnimated(side, animated: true)
    }
  }
  
  func showAll() {
    for side in locations {
      if (currentToolbars[side] != nil) {
        self.show(currentToolbars[side]!)
      }
    }
  }
  
  func remove(location: Game.rotation, toolbar: HLToolbarNode) {
    toolbar.hideAnimated(true)
    self.existingToolbars[location]!.removeAtIndex(self.existingToolbars[location]!.indexOf(toolbar)!)
    self.existingToolbars[location]!.last!.hidden = true
    self.show(self.existingToolbars[location]!.last!)
//    Get the last toolbar and show.
  }
  
  //  Removes all toolbars but the first one for a side.
  func resetSide(side: Game.rotation) {
    if (currentToolbars[side] != nil) {
      currentToolbars[side]?.hideAnimated(true)
      currentToolbars[side]?.hidden = true
      let newExistingToolbars = existingToolbars[side]?.first
      existingToolbars[side] = [newExistingToolbars!]
      self.show(existingToolbars[side]!.first!)
    }
  }
  
}


















