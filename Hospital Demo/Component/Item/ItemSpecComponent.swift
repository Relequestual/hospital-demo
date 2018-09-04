//
//  ItemSpecComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 03/09/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import GameplayKit

class ItemSpecComponent: GKComponent {

  var area: [CGPoint]
  var pous: [CGPoint]
  var staffPous: [CGPoint]

  var baring = Game.rotation.north

  init(spec: ItemManager.ItemSpec) {
    area = spec.area
    pous = spec.pous
    staffPous = spec.staffPous ?? []
    super.init()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
