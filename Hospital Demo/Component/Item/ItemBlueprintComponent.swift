//
//  ItemBlueprintComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 10/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import GameplayKit
import SpriteKit

class ItemBlueprintComponent: GKComponent {

  var itemSpec: ItemSpecComponent

  var rotateButton: Button!

  var spriteOffset: CGPoint

  enum Status {
    case planning
    case planned
    case built
  }

  var status = Status.planning

  init(itemSpec: ItemSpecComponent) {

    self.itemSpec = itemSpec

    let rotateTexture = SKTexture(imageNamed: "Graphics/rotate.png")

    spriteOffset = ItemBlueprintComponent.calculateSpritePos(area: itemSpec.area)

    super.init()

    rotateButton = createConfirmButtons(rotateTexture, f: ({ _ in
      self.rotate(self.itemSpec.baring)
    }))

    print("--init after buttons created")
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func planFunctionCall(_ position: CGPoint) {
    guard let entity = self.entity else { return }

    entity.component(ofType: BuildItemComponent.self)!.planAtPoint(position)

    let plannedObject = self.entity!

//    print("removing planned_object nodes")
//    Game.sharedInstance.entityManager.node.enumerateChildNodesWithName("planned_object", usingBlock: { (node, stop) -> Void in
//      node.removeFromParent()
//    });

    let graphicNode = plannedObject.component(ofType: SpriteComponent.self)?.node
    graphicNode?.zPosition = CGFloat(ZPositionManager.WorldLayer.interaction.zpos - 1)
    graphicNode?.name = "planned_object"
    graphicNode?.alpha = 0.6

    let nodePosition = Game.sharedInstance.tilesAtCoords[Int(position.x)]![Int(position.y)]!.component(ofType: PositionComponent.self)!.spritePosition!
//    nodePosition = CGPoint(x: Int(nodePosition!.x) + 32 * x, y: Int(nodePosition!.y) + 32 * y)

    graphicNode?.position = CGPoint(x: nodePosition.x + spriteOffset.x, y: nodePosition.y + spriteOffset.y)
    if graphicNode!.parent != nil {
//      Don't touch this one!
      print(graphicNode!)
    } else {
      Game.sharedInstance.wolrdnode.addChild(graphicNode!)
    }

  }

  func rotate(_ previousRotation: Game.rotation) {
    guard let entity = self.entity else { return }

    var newRotation = previousRotation
    newRotation.next()

    let action = SKAction.rotate(toAngle: CGFloat(itemSpec.baring.rawValue) * -CGFloat(Double.pi / 2), duration: TimeInterval(0.1))

    self.entity?.component(ofType: SpriteComponent.self)?.node.run(action, withKey: "rotate")


    itemSpec.area = rotatePoints(points: itemSpec.area)
    itemSpec.pous = rotatePoints(points: itemSpec.pous)
//        print(self.area)
    itemSpec.baring = newRotation

    print("--- new baring set")

    updateSpritePos()

    entity.component(ofType: ItemBlueprintComponent.self)!.planFunctionCall(entity.component(ofType: PositionComponent.self)!.gridPosition!)
//    self.entity?.componentForClass(BlueprintComponent.self)?.displayBuildObjectConfirm()
  }

  func rotatePoints(points: [CGPoint]) -> [CGPoint] {
    var newPoints: [CGPoint] = []
    points.forEach { (point: CGPoint) in
      newPoints.append(CGPoint(x: point.y, y: -point.x))
    }
    return newPoints
  }

  func canPlanAtPoint(_ point: CGPoint) -> Bool {
    for coord in itemSpec.area + itemSpec.pous {
      guard Game.sharedInstance.tilesAtCoords[Int(point.x + coord.x)] != nil else {
        return false
      }
      guard Game.sharedInstance.tilesAtCoords[Int(point.x + coord.x)]![Int(point.y + coord.y)] != nil else {
        return false
      }

//      This should be in a canbuild function only
//      if (tile.unbuildable) {
//        return false
//      }
    }

    return true
  }

  func updateSpritePos() {
    spriteOffset = ItemBlueprintComponent.calculateSpritePos(area: itemSpec.area)
  }

  static func calculateSpritePos(area: [CGPoint]) -> CGPoint {
    let x = area.flatMap { $0.x }
    let y = area.flatMap { $0.y }

    let minx = x.min()
    let maxx = x.max()
    let miny = y.min()
    let maxy = y.max()

    //    DOING: check if this is right and if so,use when planning at point
    return CGPoint(x: (minx! + maxx!) * 32, y: (miny! + maxy!) * 32)
  }

  func displayBuildObjectConfirm() {
    guard let gridPosition = self.entity?.component(ofType: PositionComponent.self)?.gridPosition else {
      print(entity as Any)
      return
    }

    let confirmToolbar = ConfirmToolbar(addMenuItems: [Menu.menuItem(button: rotateButton)])
    //    set callbacks for confirm toolbar
    confirmToolbar.cancel = {
      print("Cancel item plan")
      self.cancelPlan()
    }
    confirmToolbar.confirm = {
      print("OK TO BUILD item")
      self.confirmPlan()
    }

    Game.sharedInstance.toolbarManager?.add(toolbar: confirmToolbar, location: .south, shown: true)

  }

  func confirmPlan() {
    guard let entity = self.entity else { return }

    guard entity.component(ofType: PositionComponent.self)?.gridPosition != nil else {
      return
    }
    if canBuildAtPoint((entity.component(ofType: PositionComponent.self)!.gridPosition)!) {
      clearPlan()

      let node: SKSpriteNode = entity.component(ofType: SpriteComponent.self)!.node
      node.alpha = 1
      node.name = ""
      print("confirming plan!")

      print(Game.sharedInstance.buildRoomStateMachine.roomBuilding as Any)
      entity.component(ofType: BuildItemComponent.self)!.build()
      Game.sharedInstance.buildRoomStateMachine.roomBuilding = nil
      Game.sharedInstance.entityManager.add(self.entity!, layer: ZPositionManager.WorldLayer.item)
      status = Status.built
    } else {
      print("can't build like that!")
    }
  }

//  This should be in the build item component?
  func canBuildAtPoint(_ point: CGPoint) -> Bool {
    let totalArea = itemSpec.area + itemSpec.pous
    for coord in totalArea {
      guard Game.sharedInstance.tilesAtCoords[Int(point.x + coord.x)] != nil else {
        return false
      }
      guard let tile = Game.sharedInstance.tilesAtCoords[Int(point.x + coord.x)]![Int(point.y + coord.y)] else {
        return false
      }

      if tile.unbuildable {
        return false
      }

      if tile.walls.anyBlocked() {
//          filter returns an array even when given a dictoary in swift 3. fixed in 4 =/
        let sides = tile.walls.index.keys.filter({ (rotation: Game.rotation) -> Bool in
          tile.walls.get(baring: rotation) == true
        })
        for side: Game.rotation in sides {
          let checkFor = CGPoint(x: coord.x + ((side == .east) ? 1 : side == .west ? -1 : 0), y: coord.y + ((side == .north) ? 1 : side == .south ? -1 : 0))

          if totalArea.contains(where: { (point: CGPoint) -> Bool in
            point == checkFor
          }) {
            return false
          }
        }
      }
    }

    return true
  }

  func cancelPlan() {
    Game.sharedInstance.buildItemStateMachine.itemBuilding = nil
    clearPlan()
    Game.sharedInstance.gameStateMachine.enter(GSGeneral.self)
  }

  func clearPlan() {
    Game.sharedInstance.entityManager.node.enumerateChildNodes(withName: "planned_object", using: { (node, _) -> Void in
      if let entity = node.userData?["entity"] as? GKEntity {
        Game.sharedInstance.entityManager.remove(entity)
      } else {
        node.removeFromParent()
      }
    })
    Game.sharedInstance.draggingEntiy = nil
//    Game.sharedInstance.placingObjectsQueue.removeFirst()
//    Game.sharedInstance.buildStateMachine.enterState(BSNoBuild)
  }

  func createConfirmButtons(_ texture: SKTexture, f: @escaping (GKEntity) -> Void) -> Button {
    let entity = Button(texture: texture, touch_f: f)

    let node = entity.component(ofType: SpriteComponent.self)!.node
    node.size = CGSize(width: texture.size().width / 2, height: texture.size().height / 2)
    node.name = "planned_object"

    return entity
  }
}
