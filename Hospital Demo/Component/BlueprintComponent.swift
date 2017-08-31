//
//  BlueprintComponent.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 10/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//


import SpriteKit
import GameplayKit

class BlueprintComponent: GKComponent {
  
  var area : [CGPoint]
  var pous : [CGPoint]
  var staffPous : [CGPoint]

  var confirmPosition = CGPoint(x: 0, y: 1)
  var rejectPosition = CGPoint(x: 1, y: 1)
  var rotatePosition = CGPoint(x: 2, y: 1)
  
  var confirmButton: Button!
  var cancelButton: Button!
  var rotateButton: Button!
  
  var baring = Game.rotation.north
  
  var spriteOffset: CGPoint

  var planFunction: (_ position: CGPoint)->Void;
  
  enum Status {
    case planning
    case planned
    case built
  }

  var status = Status.planning
  
  init(area: [CGPoint], pous: [CGPoint], staffPous: [CGPoint], pf:@escaping (_ position: CGPoint) -> Void) {
    self.area = area
    self.pous = pous
    self.staffPous = staffPous
    self.planFunction = pf
    
    let tickTexture = SKTexture(imageNamed: "Graphics/tick.png")
    let crossTexture = SKTexture(imageNamed: "Graphics/cross.png")
    let rotateTexture = SKTexture(imageNamed: "Graphics/rotate.png")
    
    self.spriteOffset = BlueprintComponent.calculateSpritePos(area: area)
    
    super.init()
    
    self.confirmButton = createConfirmButtons(tickTexture, f: {
      self.confirmPlan()
    })
    
    self.cancelButton = createConfirmButtons(crossTexture, f: {
      self.cancelPlan()
    })
    
    self.rotateButton = createConfirmButtons(rotateTexture, f: ({
      self.rotate(self.baring)
    }))

    print("--init after buttons created")
    
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func planFunctionCall(_ position: CGPoint) {
    self.planFunction(position)
    self.entity?.component(ofType: BuildComponent.self)?.planAtPoint(position)
    
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
    
    
    graphicNode?.position = CGPoint(x: nodePosition.x + self.spriteOffset.x, y: nodePosition.y + self.spriteOffset.y)
    if (graphicNode!.parent != nil) {
//      Don't touch this one!
      print(graphicNode!);
    } else {
      Game.sharedInstance.wolrdnode.contentNode.addChild(graphicNode!)
    }
    
    if( plannedObject.component(ofType: BlueprintComponent.self)?.status != BlueprintComponent.Status.built ){
      plannedObject.component(ofType: BlueprintComponent.self)?.displayBuildObjectConfirm()
    }

  }
  
  func rotate(_ previousRotation: Game.rotation) {
    var previousRotation = previousRotation
    previousRotation.next()

    let action = SKAction.rotate(toAngle: CGFloat(self.baring.rawValue) * -CGFloat(Double.pi / 2) , duration: TimeInterval(0.1))


    self.entity?.component(ofType: SpriteComponent.self)?.node.run(action, withKey: "rotate")


    let newRotation = previousRotation
    
    self.area = self.rotatePoints(points: self.area)
    self.pous = self.rotatePoints(points: self.pous)
//        print(self.area)


    self.baring = newRotation
    print("--- new baring set")
    
    self.updateSpritePos()
    
    self.entity?.component(ofType: BlueprintComponent.self)?.planFunctionCall((self.entity?.component(ofType: PositionComponent.self)?.gridPosition)!)
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
    
    for coord in self.area + self.pous {
      guard (Game.sharedInstance.tilesAtCoords[Int(point.x + coord.x)] != nil) else {
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
    self.spriteOffset = BlueprintComponent.calculateSpritePos(area: self.area)
  }
  
  static func calculateSpritePos(area: [CGPoint]) -> CGPoint {
    let x = area.flatMap{ $0.x }
    let y = area.flatMap{ $0.y }
    
    let minx = x.min()
    let maxx = x.max()
    let miny = y.min()
    let maxy = y.max()
    
    //    DOING: check if this is right and if so,use when planning at point
    return CGPoint(x: (minx! + maxx!) * 32, y: (miny! + maxy!) * 32)
  }
  
  func displayBuildObjectConfirm() {
    guard let gridPosition = self.entity?.component(ofType: PositionComponent.self)?.gridPosition else {
      print(self.entity as Any)
      return
    }

    var finalTickPosition = CGPoint(x: gridPosition.x + confirmPosition.x, y: gridPosition.y + confirmPosition.y)
    finalTickPosition = CGPoint(x: finalTickPosition.x * 64 + 32, y: finalTickPosition.y * 64 + 32)
    
    self.confirmButton.component(ofType: SpriteComponent.self)?.node.position = finalTickPosition
//TODO: This is not a solution I am happy with... =/
    Game.sharedInstance.entityManager.remove(confirmButton)
    Game.sharedInstance.entityManager.add(confirmButton, layer: ZPositionManager.WorldLayer.ui)
    
    var finalCrossPosition = CGPoint(x: gridPosition.x + rejectPosition.x, y: gridPosition.y + rejectPosition.y)
    finalCrossPosition = CGPoint(x: finalCrossPosition.x * 64 + 32, y: finalCrossPosition.y * 64 + 32)
    
    self.cancelButton.component(ofType: SpriteComponent.self)?.node.position = finalCrossPosition
    Game.sharedInstance.entityManager.remove(cancelButton)
    Game.sharedInstance.entityManager.add(cancelButton, layer: ZPositionManager.WorldLayer.ui)
    
    var finalRotatePosition = CGPoint(x: gridPosition.x + rotatePosition.x, y: gridPosition.y + rotatePosition.y)
    finalRotatePosition = CGPoint(x: finalRotatePosition.x * 64 + 32, y: finalRotatePosition.y * 64 + 32)
    
    self.rotateButton.component(ofType: SpriteComponent.self)?.node.position = finalRotatePosition
    Game.sharedInstance.entityManager.remove(rotateButton)
    Game.sharedInstance.entityManager.add(rotateButton, layer: ZPositionManager.WorldLayer.ui)
    
  }
  
  func confirmPlan() {
    let plannedObject = self.entity!
    guard (entity?.component(ofType: PositionComponent.self)?.gridPosition != nil) else {
      return
    }
    if (self.canBuildAtPoint((entity?.component(ofType: PositionComponent.self)?.gridPosition)!)) {
      self.clearPlan()
      
      let node: SKSpriteNode = (plannedObject.component(ofType: SpriteComponent.self)?.node)!
      node.alpha = 1
      node.name = ""
      print("confirming plan!")
      
      print(Game.sharedInstance.buildRoomStateMachine.roomBuilding as Any)
      plannedObject.component(ofType: BuildComponent.self)?.build()
      Game.sharedInstance.buildRoomStateMachine.roomBuilding = nil
      Game.sharedInstance.entityManager.add(self.entity!, layer: ZPositionManager.WorldLayer.world)
      self.status = Status.built
    } else {
      print("can't build like that!")
    }
  }
  
//  This should be in the build item component?
  func canBuildAtPoint(_ point: CGPoint) -> Bool {
    let totalArea = self.area + self.pous
      for coord in totalArea {
        guard (Game.sharedInstance.tilesAtCoords[Int(point.x + coord.x)] != nil) else {
          return false
        }
        guard let tile = Game.sharedInstance.tilesAtCoords[Int(point.x + coord.x)]![Int(point.y + coord.y)] else {
          return false
        }
        
        if (tile.unbuildable) {
          return false
        }
        
        if (tile.walls.anyBlocked()) {
//          filter returns an array even when given a dictoary in swift 3. fixed in 4 =/
          let sides = tile.walls.index.keys.filter({ (rotation: Game.rotation) -> Bool in
            return tile.walls.get(baring: rotation) == true
          })
          for side : Game.rotation in sides {
            
            let checkFor = CGPoint(x: coord.x + ((side == .east) ? 1 : side == .west ? -1 : 0), y: coord.y + ((side == .north) ? 1 : side == .south ? -1 : 0))
            
            if totalArea.contains(where: { (point: CGPoint) -> Bool in
              return point == checkFor
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
    self.clearPlan()
  }

  func clearPlan() {
    Game.sharedInstance.entityManager.node.enumerateChildNodes(withName: "planned_object", using: { (node, stop) -> Void in
      if let entity = node.userData?["entity"]as? GKEntity {
        Game.sharedInstance.entityManager.remove(entity)
      } else {
        node.removeFromParent()
      }
    });
    Game.sharedInstance.draggingEntiy = nil
    Game.sharedInstance.placingObjectsQueue.removeFirst()
//    Game.sharedInstance.buildStateMachine.enterState(BSNoBuild)

  }
  
  func createConfirmButtons(_ texture: SKTexture, f: @escaping ()->(Void)) -> Button {

    let entity = Button(texture: texture, touch_f: f)
    
    let node = entity.component(ofType: SpriteComponent.self)!.node
    node.size = CGSize(width: texture.size().width / 2, height: texture.size().height / 2)
    node.name = "planned_object"

    return entity
  }
  
}
