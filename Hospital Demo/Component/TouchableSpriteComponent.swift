//
//  TouchableSpriteComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 19/12/2015.
//  Copyright © 2015 Ben Hutton. All rights reserved.
//

import GameplayKit
import SpriteKit

class TouchableSpriteComponent: GKComponent {
  var entityTouched: () -> Void

  init(f: @escaping () -> Void) {
    entityTouched = f
    super.init()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func callFunction() {
    entityTouched()
  }
}
