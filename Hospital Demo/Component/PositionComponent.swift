//
//  PositionComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 23/12/2015.
//  Copyright © 2015 Ben Hutton. All rights reserved.
//

import SpriteKit
import GameplayKit

class PositionComponent: GKComponent {

    var x : Int
    var y : Int
    
    init(x : Int, y : Int) {
        self.x = x
        self.y = y
    }
}
