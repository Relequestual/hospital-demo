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

  struct ItemSpec {

    let name: String

    let area: [CGPoint]
    let pous: [CGPoint]
    let staffPous: [CGPoint]?

    let texture: SKTexture
    //    let shapeNode: SKShapeNode?
    //    let color: UIColor?

    init(name: String, area: [CGPoint], pous: [CGPoint], staffPous: [CGPoint], texture: SKTexture) {
      self.name = name
      self.area = area
      self.pous = pous
      self.staffPous = staffPous
      self.texture = texture
    }

    init(name: String, area: [CGPoint], pous: [CGPoint], staffPous: [CGPoint], shapeNode: SKShapeNode, color: UIColor) {
      shapeNode.fillColor = color
      let view = SKView()
      let texture: SKTexture = view.texture(from: shapeNode)!
      self.init(name: name, area: area, pous: pous, staffPous: staffPous, texture: texture)
    }


  }

  enum BaseItems {
    case ReceptionDesk
    case StaffDesk
    case PateintChair
    case ExamBed
  }

  static let items: [BaseItems: ItemDefinitions.ItemSpec] = [
    BaseItems.ReceptionDesk: ItemDefinitions.ItemSpec(
      name:"Reception Desk",
      area: [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0)],
      pous: [CGPoint(x: 0, y: -1), CGPoint(x: 1, y: -1)],
      staffPous: [CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 1)],
      shapeNode: SKShapeNode(rectOf: CGSize(width: 110, height: 55), cornerRadius: 0.2),
      color: UIColor.purple
    ),
    BaseItems.StaffDesk: ItemDefinitions.ItemSpec(
      name: "Desk",
      area: [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0)],
      pous: [],
      staffPous: [CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 1)],
      shapeNode: SKShapeNode(rectOf: CGSize(width: 110, height: 55), cornerRadius: 0.2),
      color: UIColor.brown
    ),
    BaseItems.PateintChair: ItemDefinitions.ItemSpec(
      name: "Chair",
      area: [CGPoint(x: 0, y: 0)],
      pous: [CGPoint(x: 0, y: 1)],
      staffPous: [],
      shapeNode: SKShapeNode(rectOf: CGSize(width: 45, height: 45), cornerRadius: 0.2),
      color: UIColor.brown
    ),
    BaseItems.ExamBed: ItemDefinitions.ItemSpec(
      name: "Exam Bed",
      area: [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0)],
      pous: [CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 1)],
      staffPous: [CGPoint(x: 1, y: 1),],
      shapeNode: SKShapeNode(rectOf: CGSize(width: 110, height: 55), cornerRadius: 0.4),
      color: UIColor.white
    )
  ]

}
