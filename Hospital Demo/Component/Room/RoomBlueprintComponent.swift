//
//  RoomBlueprintComponentapp.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 15/08/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class RoomBlueprintComponent: GKComponent {
  var size: CGSize

  static var square = SKShapeNode(rectOf: CGSize(width: 64, height: 64))
  static var innerSquare = SKShapeNode(rectOf: CGSize(width: 55, height: 55))

  static var pattern: [CGFloat] = [4.0, 4.0]
  static let dashed = CGPath(__byDashing: square.path!, transform: nil, phase: 0, lengths: pattern, count: 2)
  static var dashedSquare = SKShapeNode(path: dashed!)

  static let combinedSqaure: SKSpriteNode = RoomBlueprintComponent.compileAssets(color: nil)
  static let combinedSqaureRed: SKSpriteNode = RoomBlueprintComponent.compileAssets(color: UIColor.red)
  static var assetsCompiled = false

  let tileOffset = CGPoint(x: 32, y: 32)

  var dragOffset: CGPoint?
  var anchorTile: GKEntity?

  init(size: CGSize) {
    self.size = size
    super.init()
//    self.dynamicType.dashedSquare.lineWidth = 2
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func didAddToEntity() {
    let entity = self.entity!

    entity.addComponent(DraggableSpriteComponent(
      start: { (entity: GKEntity, point: CGPoint) in
        print("start drag room")
        self.dragStartHandler(point)
      }, move: { (entity: GKEntity, point: CGPoint) in
        self.dragMoveHandler(point)
        print("move drag room")
      }, end: { (entity: GKEntity, _: CGPoint) in
        self.dragOffset = CGPoint.zero
        print("end drag room")
    }))

    entity.addComponent(SpriteComponent(texture: createFloorplanTexture(roomSize: size)))
    entity.component(ofType: SpriteComponent.self)!.node.name = "planning_room_blueprint"

    entity.addComponent(PositionComponent(gridPosition: CGPoint.zero))
  }

  func dragStartHandler(_ point: CGPoint) {
    guard let entity = self.entity else { return }

    let gridPos = entity.component(ofType: PositionComponent.self)!.gridPosition
    let roomTileAnchor = Game.sharedInstance.tilesAtCoords[Int(gridPos!.x)]![Int(gridPos!.y)]

    let tileSpritePos = roomTileAnchor?.component(ofType: PositionComponent.self)!.spritePosition
    dragOffset = CGPoint(x: (tileSpritePos?.x)! - point.x, y: (tileSpritePos?.y)! - point.y)

    anchorTile = roomTileAnchor

    Game.sharedInstance.initDebugNode(name: "offset")
    Game.sharedInstance.updateDebugNode(name: "offset", position: dragOffset!)
  }

  func dragMoveHandler(_ point: CGPoint) {
    guard let entity = self.entity else { return }

    let offsetPoint = CGPoint(x: point.x + (dragOffset?.x)!, y: point.y + (dragOffset?.y)!)
    let tile = PositionComponent.getTileAtPoint(offsetPoint)

    Game.sharedInstance.updateDebugNode(name: "offset", position: offsetPoint)

    if anchorTile !== tile {
      if tile == nil || !tile!.isKind(of: Tile.self) {
        return
      }
      anchorTile = tile

      entity.component(ofType: BuildRoomComponent.self)!.planAtPoint((tile?.component(ofType: PositionComponent.self)!.gridPosition)!, true)
    }
  }

  struct resizeHandleDrawingInstruction {
    var axis: Game.axis
    var start: Int
    var end: Int
    var face: Int
    var side: Game.rotation
  }

  func createResizeHandles() {
    guard let entity = self.entity else { return }

    removeResizeHandles()
    let spritePosition = CGPoint.zero
    let edgeYT = Int(spritePosition.y + size.height * 64 / 2)
    let edgeYB = Int(spritePosition.y - size.height * 64 / 2)

    let edgeXL = Int(spritePosition.x - size.width * 64 / 2)
    let edgeXR = Int(spritePosition.x + size.width * 64 / 2)

    print(edgeXL)
    print(edgeXR)
    print(edgeYT)
    print(edgeYB)

//    array of dictionaries needed for button creation

    let southEdge = resizeHandleDrawingInstruction(axis: Game.axis.vert, start: edgeXL, end: edgeXR, face: edgeYB, side: Game.rotation.south)
    let northEdge = resizeHandleDrawingInstruction(axis: Game.axis.vert, start: edgeXL, end: edgeXR, face: edgeYT, side: Game.rotation.north)

    let eastEdge = resizeHandleDrawingInstruction(axis: Game.axis.hroiz, start: edgeYB, end: edgeYT, face: edgeXR, side: Game.rotation.east)
    let westEdge = resizeHandleDrawingInstruction(axis: Game.axis.hroiz, start: edgeYB, end: edgeYT, face: edgeXL, side: Game.rotation.west)

    let edgeInstructions = [southEdge, northEdge, eastEdge, westEdge]

    for edgeInstruct in edgeInstructions {
      for x in stride(from: edgeInstruct.start, to: edgeInstruct.end, by: 64) {
        let texture_vert = SKTexture(imageNamed: edgeInstruct.axis == Game.axis.vert ? "Graphics/drag_vert" : "Graphics/drag_hroz")
        let vertButton = Button(texture: texture_vert, touch_start_f: { (entity: GKEntity, point: CGPoint) in
          self.handleDragStart(point, axis: edgeInstruct.axis)
          print("handle drag start")
        }, touch_move_f: { entity, point in
          print("handle drag move")
          self.handleDragMove(point, edge: edgeInstruct.side)
        }, touch_end_f: { entity, _ in
          //          handleDragend(point: point)
        })
        let buttonVertSprite = vertButton.component(ofType: SpriteComponent.self)!.node
        buttonVertSprite.zPosition = entity.component(ofType: SpriteComponent.self)!.node.zPosition + 1
        buttonVertSprite.setScale(0.5)
        buttonVertSprite.name = "planning_room_blueprint_handles"
        buttonVertSprite.position = edgeInstruct.axis == Game.axis.vert ? CGPoint(x: x + 32, y: edgeInstruct.face) : CGPoint(x: edgeInstruct.face, y: x + 32)
        buttonVertSprite.color = SKColor.blue
        buttonVertSprite.colorBlendFactor = 1
        let circle = SKShapeNode(circleOfRadius: 32)
        circle.strokeColor = SKColor.blue
        circle.lineWidth = 2

        // TODO: make this button a single image sometime
        buttonVertSprite.addChild(circle)
        entity.component(ofType: SpriteComponent.self)!.node.addChild(vertButton.component(ofType: SpriteComponent.self)!.node)
        //      Game.sharedInstance.entityManager.add(vertButton, layer: ZPositionManager.WorldLayer.interaction)
      }
    }
  }

//  Not really happy about this, but...
  var handleDragAxis: Game.axis = Game.axis.hroiz
  var handleDragXSign: Game.numericalSignage = Game.numericalSignage.positive
  var handleDragYSign: Game.numericalSignage = Game.numericalSignage.positive
  var handleDragEdge: Game.rotation = Game.rotation.north
  var handleDragPreviousMovePoint: CGPoint = CGPoint.zero

  func handleDragStart(_ point: CGPoint, axis: Game.axis) {
    guard let entity = self.entity else { return }

    handleDragAxis = axis
    handleDragPreviousMovePoint = point
//    Determine edge is being dragged
    let centerOfRoom = entity.component(ofType: SpriteComponent.self)!.node.position
    handleDragXSign = (point.x < centerOfRoom.x) ? Game.numericalSignage.negative : Game.numericalSignage.positive
    handleDragYSign = (point.y < centerOfRoom.y) ? Game.numericalSignage.negative : Game.numericalSignage.positive

    switch (handleDragAxis, handleDragXSign, handleDragYSign) {
    case (Game.axis.vert, _, Game.numericalSignage.negative):
      handleDragEdge = Game.rotation.south
      anchorTile = PositionComponent.getTileAtPoint(CGPoint(x: point.x, y: point.y + 32))
    case (Game.axis.vert, _, Game.numericalSignage.positive):
      handleDragEdge = Game.rotation.north
      anchorTile = PositionComponent.getTileAtPoint(CGPoint(x: point.x, y: point.y - 32))
    case (Game.axis.hroiz, Game.numericalSignage.positive, _):
      handleDragEdge = Game.rotation.east
      anchorTile = PositionComponent.getTileAtPoint(CGPoint(x: point.x - 32, y: point.y))
    case (Game.axis.hroiz, Game.numericalSignage.negative, _):
      handleDragEdge = Game.rotation.west
      anchorTile = PositionComponent.getTileAtPoint(CGPoint(x: point.x + 32, y: point.y))
    default:
      print("huh")
    }
  }

  //  Remove child nodes from the sprite of this node that are the planning handles
  //  I realised that the function enumerateChildNodesWithName only does child and not descendant nodes. Not a deep action.
  func removeResizeHandles() {
    guard let entity = self.entity else { return }

    print("remvoing resize handles")
    entity.component(ofType: SpriteComponent.self)!.node.enumerateChildNodes(withName: "planning_room_blueprint_handles", using: { (node, _) -> Void in
      node.removeFromParent()
    })
  }

  let pointSprite = SKShapeNode(circleOfRadius: 5)
  //    pointSprite.fillColor = UIColor.redColor()

  func handleDragMove(_ point: CGPoint, edge: Game.rotation) {
    guard let entity = self.entity else { return }

    print("___handleDragMove point is")
    print(point)
    print(edge)
    let currentTile = PositionComponent.getTileAtPoint(CGPoint(x: point.x + ((edge == Game.rotation.east) ? -32 : edge == Game.rotation.west ? 32 : 0), y: point.y + ((edge == Game.rotation.north) ? -32 : edge == Game.rotation.south ? 32 : 0)))
    if currentTile == nil || !currentTile!.isKind(of: Tile.self) {
      return
    }

    pointSprite.strokeColor = UIColor.red
    pointSprite.position = CGPoint(x: point.x, y: point.y + 32)
    pointSprite.zPosition = 100_000
    pointSprite.removeFromParent()
    Game.sharedInstance.entityManager.node.addChild(pointSprite)

    if anchorTile !== currentTile {
//      Check  what direction was dragged when tile was changed
      var direction: Game.rotation = Game.rotation.north
      let anchorTileGridPos = anchorTile?.component(ofType: PositionComponent.self)?.gridPosition
      let currentTileGridPos = currentTile!.component(ofType: PositionComponent.self)?.gridPosition
      if handleDragAxis == Game.axis.vert {
        if anchorTileGridPos!.y == currentTileGridPos!.y {
          return
        }
        if point.y < handleDragPreviousMovePoint.y {
          if anchorTileGridPos!.y - 1 != currentTileGridPos!.y {
            return
          }
          direction = Game.rotation.south
        } else {
          if anchorTileGridPos!.y + 1 != currentTileGridPos!.y {
            return
          }
          direction = Game.rotation.north
        }
      } else if handleDragAxis == Game.axis.hroiz {
        if anchorTileGridPos!.x == currentTileGridPos!.x {
          return
        }
        if point.x < handleDragPreviousMovePoint.x {
          if anchorTileGridPos!.x - 1 != currentTileGridPos!.x {
            return
          }
          direction = Game.rotation.west
        } else {
          if anchorTileGridPos!.x + 1 != currentTileGridPos!.x {
            return
          }
          direction = Game.rotation.east
        }
      }

      print("direction is")
      print(direction)

      var newSize = CGSize.zero

      switch handleDragEdge {
      case .south:
        newSize = CGSize(width: size.width, height: size.height + (direction == Game.rotation.south ? 1 : direction == Game.rotation.north ? -1 : 0))
      case .north:
        newSize = CGSize(width: size.width, height: size.height + (direction == Game.rotation.north ? 1 : direction == Game.rotation.south ? -1 : 0))
      case .east:
        newSize = CGSize(width: size.width + (direction == Game.rotation.east ? 1 : direction == Game.rotation.west ? -1 : 0), height: size.height)
      case .west:
        newSize = CGSize(width: size.width + (direction == Game.rotation.west ? 1 : direction == Game.rotation.east ? -1 : 0), height: size.height)
      }

      if newSize.width != 0 && newSize.height != 0 {
        let oldGridPos = entity.component(ofType: PositionComponent.self)!.gridPosition
        let newGridPos: CGPoint
        if handleDragEdge == .south || handleDragEdge == .west {
          let sizeChange = CGSize(width: size.width - newSize.width, height: size.height - newSize.height)
          newGridPos = CGPoint(x: (oldGridPos?.x)! + sizeChange.width, y: (oldGridPos?.y)! + sizeChange.height)
        } else {
          newGridPos = oldGridPos!
        }

        size = newSize

        entity.component(ofType: BuildRoomComponent.self)!.planAtPoint(newGridPos)

        anchorTile = currentTile
      }

      createResizeHandles()
    }

    handleDragPreviousMovePoint = point
  }

  func createFloorplanTexture(roomSize: CGSize, blockedTiles: [(x: Int, y: Int)]? = []) -> SKTexture {
    let blueprintNode = SKSpriteNode()
    let base = 32
    let width = 64

    for x in 1 ... Int(roomSize.width) {
      for y in 1 ... Int(roomSize.height) {
        var squareNode: SKSpriteNode

        if (blockedTiles?.contains(where: { (coords: (x: Int, y: Int)) -> Bool in
          Bool(x == coords.x && y == coords.y)
        }))! {
          squareNode = RoomBlueprintComponent.combinedSqaureRed.copy() as! SKSpriteNode
        } else {
          squareNode = RoomBlueprintComponent.combinedSqaure.copy() as! SKSpriteNode
        }

        squareNode.position = CGPoint(x: x * width + base, y: y * width + base)
        blueprintNode.addChild(squareNode)
      }
    }
    blueprintNode.alpha = 0.6
    return SKView().texture(from: blueprintNode)!
  }

  static func compileAssets(color: UIColor?) -> SKSpriteNode {
    let mycolor: UIColor! = (color != nil) ? color : UIColor.blue

    innerSquare.fillColor = mycolor
    innerSquare.strokeColor = UIColor(white: 0, alpha: 0)
    dashedSquare.fillColor = mycolor
    dashedSquare.strokeColor = mycolor

    let view = SKView()
    let squareSprite = SKSpriteNode(texture: view.texture(from: innerSquare))
    let squareBorderSprite = SKSpriteNode(texture: view.texture(from: dashedSquare))

    let combinedNode = SKSpriteNode()
    combinedNode.addChild(squareSprite)
    combinedNode.addChild(squareBorderSprite)
    combinedNode.alpha = 0.6
    return combinedNode
  }
}
