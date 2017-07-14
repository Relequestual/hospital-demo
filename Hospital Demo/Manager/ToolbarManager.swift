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
  
  let locations = [Game.rotation.north, Game.rotation.east, Game.rotation.south, Game.rotation.west]
  
  init(scene: HLScene) {
    print("TOOLBAR MANAGER")
    self.scene = scene
    self.existingToolbars = [
      Game.rotation.north: [],
      Game.rotation.south: [],
      Game.rotation.east: [],
      Game.rotation.west: [],
    ]
  }
  
  
  func addToolbar(_ toolbar: HLToolbarNode, location: Game.rotation, shown: Bool = false) -> Void{
    print("Adding toolbar")
//    Extend this when needed to work for all rotations
    if (location == Game.rotation.south) {
      
      toolbar.position = CGPoint(x: 0, y: -64)
      toolbar.zPosition = CGFloat(ZPositionManager.WorldLayer.ui.zpos)
    }
    
    toolbar.hlSetGestureTarget(toolbar)
//    Hide toolbars at location
    for tb in self.existingToolbars[location]! {
      tb.hide(animated: false)
    }
    self.existingToolbars[location]?.append(toolbar)
    if (shown) {
      toolbar.isHidden = true
      self.show(toolbar)
    }
    
  }
  
  
  func hideAnimated(_ side: Game.rotation, animated: Bool) {
    
    if (existingToolbars[side] != nil) {
      for toolbar in existingToolbars[side]! {
        toolbar.hide(animated: animated)
        toolbar.isHidden = true
      }
    }
  }
  
  func show(_ toolbar: HLToolbarNode) -> Void{
    
    for location in self.locations {
      if (((self.existingToolbars[location]?.contains(toolbar))) == true){
        print("set as current toolbar")
        if (self.currentToolbars[location] != nil) {
          self.currentToolbars[location]!.isHidden = true
        }
        self.currentToolbars[location] = toolbar
      }
    }
    
    if (toolbar.isHidden) {
      toolbar.show(withOrigin: CGPoint(x: 0, y: -64), finalPosition: CGPoint(x: 0, y: 0), fullScale: 1.0, animated: true)
      toolbar.isHidden = false
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
  
  func remove(_ location: Game.rotation, toolbar: HLToolbarNode) {
    toolbar.hide(animated: true)
    self.existingToolbars[location]!.remove(at: self.existingToolbars[location]!.index(of: toolbar)!)
    self.existingToolbars[location]!.last!.isHidden = true
    self.show(self.existingToolbars[location]!.last!)
//    Get the last toolbar and show.
  }
  
  //  Removes all toolbars but the first one for a side.
  func resetSide(_ side: Game.rotation) {
    if (currentToolbars[side] != nil) {
      currentToolbars[side]?.hide(animated: true)
      currentToolbars[side]?.isHidden = true
      let newExistingToolbars = existingToolbars[side]?.first
      existingToolbars[side] = [newExistingToolbars!]
      self.show(existingToolbars[side]!.first!)
    }
  }
  
}

















