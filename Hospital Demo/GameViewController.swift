//
//  GameViewController.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 13/11/2015.
//  Copyright (c) 2015 Ben Hutton. All rights reserved.
//

import SpriteKit

class GameViewController: UIViewController {

  // context sensitive controls
  let toolBarView = UIView()
  
  // game scene
  let gameSceneView = SKView()
  
  // game controls
  let gameToolbarView = UIView()
  
  // the game's SKScene
  let gameScene = GameScene()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    toolBarView.translatesAutoresizingMaskIntoConstraints = false
    gameSceneView.translatesAutoresizingMaskIntoConstraints = false
    gameToolbarView.translatesAutoresizingMaskIntoConstraints = false
    
    toolBarView.backgroundColor = .orangeColor()
    gameToolbarView.backgroundColor = .purpleColor()

    gameSceneView.ignoresSiblingOrder = true
    gameSceneView.showsFPS = true
    gameSceneView.showsNodeCount = true
    gameSceneView.showsPhysics = true
    
    gameScene.scaleMode = .ResizeFill
    gameSceneView.presentScene(gameScene)
    
    view.addSubview(toolBarView)
    view.addSubview(gameSceneView)
    view.addSubview(gameToolbarView)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    var constraints = [NSLayoutConstraint]()
    
    let views = ["tools": toolBarView, "game": gameSceneView, "menu": gameToolbarView]
    let metrics = ["menuHeight": 48]
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[tools]|", options: [], metrics: nil, views: views)
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[game]|", options: [], metrics: nil, views: views)
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[menu]|", options: [], metrics: nil, views: views)
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[tools(menuHeight)][game][menu(menuHeight)]|", options: [], metrics: metrics, views: views)
    
    constraints.forEach { $0.active = true }
  }
  
  override func shouldAutorotate() -> Bool {
    return true
  }

  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
      return .AllButUpsideDown
    } else {
      return .All
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }

  override func prefersStatusBarHidden() -> Bool {
    return true
  }
}
