//
//  GameViewController.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 13/11/2015.
//  Copyright (c) 2015 Ben Hutton. All rights reserved.
//

import SpriteKit
import UIKit

class GameViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    if let scene = GameScene(fileNamed: "GameScene") {
      // Configure the view.

      let skView = view as! SKView
      scene.size = skView.bounds.size
      skView.showsFPS = true
      skView.showsNodeCount = true
      skView.showsPhysics = true

      /* Sprite Kit applies additional optimizations to improve rendering performance */
      skView.ignoresSiblingOrder = true

      /* Set the scale mode to scale to fit the window */
      //            scene.scaleMode = .AspectFill
      scene.scaleMode = .resizeFill

      skView.presentScene(scene)
    }
  }

  override var shouldAutorotate: Bool {
    return true
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }
}
