//
//  ItemDefinitions.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 08/08/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit


class ItemDefinitions {

  enum BaseItems {
    case ReceptionDesk
    case StaffDesk
    case PateintChair
  }

  static let items: [BaseItems: ItemManager.ItemSpec] = [
    BaseItems.ReceptionDesk: ItemManager.ItemSpec(
      name:"Reception Desk",
      area: [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0)],
      pous: [CGPoint(x: 0, y: -1), CGPoint(x: 1, y: -1)],
      staffPous: [CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 1)],
      shapeNode: SKShapeNode(rectOf: CGSize(width: 110, height: 55), cornerRadius: 0.2),
      color: UIColor.purple
    ),
    BaseItems.StaffDesk: ItemManager.ItemSpec(
      name: "Desk",
      area: [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0)],
      pous: [],
      staffPous: [CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 1)],
      shapeNode: SKShapeNode(rectOf: CGSize(width: 110, height: 55), cornerRadius: 0.2),
      color: UIColor.white
    ),
    BaseItems.PateintChair: ItemManager.ItemSpec(
      name: "Chair",
      area: [CGPoint(x: 0, y: 0)],
      pous: [CGPoint(x: 0, y: 1)],
      staffPous: [],
      shapeNode: SKShapeNode(rectOf: CGSize(width: 45, height: 45), cornerRadius: 0.2),
      color: UIColor.brown
    )
  ]

}
