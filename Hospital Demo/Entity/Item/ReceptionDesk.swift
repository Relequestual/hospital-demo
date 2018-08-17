//
//  ReceptionDesk.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 08/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import GameplayKit
import SpriteKit

class ReceptionDesk: GKEntity {
  var area = [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0)]

  var pous = [CGPoint(x: 0, y: -1), CGPoint(x: 1, y: -1)]

  var staffPous = [CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 1)]

  override init() {
    super.init()
    let blueprint = ItemBlueprintComponent(area: area, pous: pous, staffPous: staffPous)
    addComponent(blueprint)

    let draggableComponent = DraggableSpriteComponent(
      start: dragStartHandler,
      move: dragMoveHandler,
      end: dragEndHandler
    )
    addComponent(draggableComponent)
    addComponent(BuildItemComponent())

    let graphicNode = SKShapeNode(rectOf: CGSize(width: 110, height: 55), cornerRadius: 0.2)
    graphicNode.fillColor = UIColor.purple
    let view = SKView()
    let graphicTexture: SKTexture = view.texture(from: graphicNode)!

    let spriteComponent = SpriteComponent(texture: graphicTexture)
    addComponent(spriteComponent)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func dragStartHandler(_: CGPoint) {
    print("RD Start drag")
  }

  var tileTracker: GKEntity?

  func dragMoveHandler(_ point: CGPoint) {
    print("RD Move drag")

    if component(ofType: ItemBlueprintComponent.self)?.status == ItemBlueprintComponent.Status.built {
      print("No dragging built items")
      return
    }

//    self.componentForClass(SpriteComponent.self)?.node.position = point
    let nodesAtPoint = Game.sharedInstance.wolrdnode.nodes(at: point)

    for node in nodesAtPoint {
      guard let entity: GKEntity = node.userData?["entity"] as? GKEntity else { continue }

      if entity.isKind(of: Tile.self) {
        if (self.tileTracker == entity) {
          return
        }
        self.tileTracker = entity
        component(ofType: ItemBlueprintComponent.self)?.planFunctionCall((entity.component(ofType: PositionComponent.self)?.gridPosition)!)
      }
    }
  }

  func dragEndHandler(_: CGPoint) {
    if component(ofType: ItemBlueprintComponent.self)?.status != ItemBlueprintComponent.Status.built {
      component(ofType: ItemBlueprintComponent.self)?.displayBuildObjectConfirm()
    }
    print("RD End drag")
  }

}
