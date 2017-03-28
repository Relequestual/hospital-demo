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
  
  var area : [[Int]]
  var pous : [[Int]]
  var staffPous : [[Int]]

  var confirmPosition = CGPoint(x: 0, y: 1)
  var rejectPosition = CGPoint(x: 1, y: 1)
  var rotatePosition = CGPoint(x: 2, y: 1)
  
  var confirmButton: Button!
  var cancelButton: Button!
  var rotateButton: Button!
  
  var baring = Game.rotation.north

  var planFunction: (_ position: CGPoint)->Void;
  
  enum Status {
    case planning
    case planned
    case built
  }

  var status = Status.planning
  
  init(area: [[Int]], pous: [[Int]], staffPous: [[Int]], pf:@escaping (_ position: CGPoint) -> Void) {
    self.area = area
    self.pous = pous
    self.staffPous = staffPous
    self.planFunction = pf
    
    let tickTexture = SKTexture(imageNamed: "Graphics/tick.png")
    let crossTexture = SKTexture(imageNamed: "Graphics/cross.png")
    let rotateTexture = SKTexture(imageNamed: "Graphics/rotate.png")

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
    
    var plannedObject = self.entity!

//    print("removing planned_object nodes")
//    Game.sharedInstance.entityManager.node.enumerateChildNodesWithName("planned_object", usingBlock: { (node, stop) -> Void in
//      node.removeFromParent()
//    });

    var graphicNode = plannedObject.component(ofType: SpriteComponent.self)?.node
    graphicNode?.zPosition = CGFloat(ZPositionManager.WorldLayer.interaction.zpos - 1)
    graphicNode?.name = "planned_object"
    graphicNode?.alpha = 0.6
    
    let nodeArea = plannedObject.component(ofType: BlueprintComponent.self)?.area
        
    let max = nodeArea?.map({ ( coord: [Int] ) -> Int in
      return coord[0]
    }).max()
    
    let may = nodeArea?.map({ ( coord: [Int] ) -> Int in
      return coord[1]
    }).max()
    
    let mix = nodeArea?.map({ ( coord: [Int] ) -> Int in
      return coord[0]
    }).min()
    
    let miy = nodeArea?.map({ ( coord: [Int] ) -> Int in
      return coord[1]
    }).min()
    
    let x = max! + mix!
    let y = may! + miy!

    var nodePosition = Game.sharedInstance.tilesAtCoords[Int(position.x)]![Int(position.y)]!.component(ofType: PositionComponent.self)?.spritePosition
    nodePosition = CGPoint(x: Int(nodePosition!.x) + 32 * x, y: Int(nodePosition!.y) + 32 * y)
    
    
    graphicNode?.position = nodePosition!
    if (graphicNode!.parent != nil) {
//      Don't touch this one!
      print(graphicNode);
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

    var action = SKAction.rotate(toAngle: CGFloat(self.baring.rawValue) * -CGFloat(M_PI / 2) , duration: TimeInterval(0.1))


    self.entity?.component(ofType: SpriteComponent.self)?.node.run(action, withKey: "rotate")


    let newRotation = previousRotation
    

      for i in 0 ..< self.area.count {
        var coord = self.area[i]
        coord = [coord[1], -coord[0]]
        self.area[i] = coord
      }
      for i in 0 ..< self.pous.count {
        var coord = self.pous[i]
        coord = [coord[1], -coord[0]]
        self.pous[i] = coord
      }
//        print(self.area)


    self.baring = newRotation
    print("--- new baring set")
    
    self.entity?.component(ofType: BlueprintComponent.self)?.planFunctionCall((self.entity?.component(ofType: PositionComponent.self)?.gridPosition)!)
//    self.entity?.componentForClass(BlueprintComponent.self)?.displayBuildObjectConfirm()
  }
  
  func canPlanAtPoint(_ point: CGPoint) -> Bool {
    
    for coord in self.area + self.pous {
      guard (Game.sharedInstance.tilesAtCoords[Int(point.x) + coord[0]] != nil) else {
        return false
      }
      guard let tile = Game.sharedInstance.tilesAtCoords[Int(point.x) + coord[0]]![Int(point.y) + coord[1]] else {
        return false
      }

//      This should be in a canbuild function only
//      if (tile.unbuildable) {
//        return false
//      }
    }
    
    return true
  }
  
  func displayBuildObjectConfirm() {
    guard let gridPosition = self.entity?.component(ofType: PositionComponent.self)?.gridPosition else {
      print(self.entity)
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
      
      print(Game.sharedInstance.buildRoomStateMachine.roomBuilding)
      plannedObject.component(ofType: BuildComponent.self)?.build()
      Game.sharedInstance.buildRoomStateMachine.roomBuilding = nil
      Game.sharedInstance.entityManager.add(self.entity!, layer: ZPositionManager.WorldLayer.world)
      self.status = Status.built
    } else {
      print("can't build like that!")
    }
  }
  
  func canBuildAtPoint(_ point: CGPoint) -> Bool {
    
      for coord in self.area + self.pous {
        guard (Game.sharedInstance.tilesAtCoords[Int(point.x) + coord[0]] != nil) else {
          return false
        }
        guard let tile = Game.sharedInstance.tilesAtCoords[Int(point.x) + coord[0]]![Int(point.y) + coord[1]] else {
          return false
        }
        
        if (tile.unbuildable) {
          return false
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
