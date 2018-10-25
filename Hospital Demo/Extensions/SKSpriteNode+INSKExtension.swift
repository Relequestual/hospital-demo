//
//  SKSpriteNode+INSKExtension.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 22/10/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {


/**
 Sets the sprite node's position converted first for an anchor point.

 The sprite node's anchor point itself won't be changed it is only used for calculating.
 The converted position will be the position which would be when the sprite node's anchor point would be the one given.

 For exampe when having a button sprite node in a menu you normally allign the layout with the upper left coordinates of the sprite nodes rather than using the sprite node's center, but changing the anchor point is not always desired.
 With this method you can have the anchor point still at the center, but setting the sprite node's position as if the anchor point would be the given one.

 @param position The new position to convert and assign.
 @param anchor An anchor point for which to interpret the sprite node's current position.

 */

  func setPosition(position: CGPoint, forAnchor anchor: CGPoint) {
    let sizeAtPoint: CGPoint = CGPoint(x: size.width, y: size.height)
    let anchorTranslation: CGPoint = CGPoint(x: self.anchorPoint.x - anchor.x, y: self.anchorPoint.y - anchor.y)
    let translation = CGPoint(x: sizeAtPoint.x * anchorTranslation.x, y: sizeAtPoint.y * anchorTranslation.y)
    self.position = CGPoint(x: position.x + translation.x, y: position.y - translation.y)
  }
  

}
