
// #import "HLScrollNode.h"
//  BaseScene.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 17/11/2015.
//  Copyright © 2015 Ben Hutton. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import HLSpriteKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


/**
 A base class for all of the scenes in the app.
 */
class BaseScene: HLScene {

  // Update time
  var lastUpdateTimeInterval: TimeInterval = 0

  var updateLastTime: TimeInterval = 0

  /**
   The native size for this scene. This is the height at which the scene
   would be rendered if it did not need to be scaled to fit a window or device.
   Defaults to `zeroSize`; the actual value to use is set in `createCamera()`.
   */
  var nativeSize = CGSize.zero


  var staticObjects = SKSpriteNode()

  let cam = SKCameraNode()


  /// A reference to the scene manager for scene progression.
  //    weak var sceneManager: SceneManager!

  // MARK: SKScene Life Cycle

  override func didMove(to view: SKView) {
    super.didMove(to: view)


    updateCameraScale()
    //        overlay?.updateScale()

    // Listen for updates to the player's controls.
    //        sceneManager.gameInput.delegate = self

    // Find all the buttons and set the initial focus.
    //        buttons = findAllButtonsInScene()
    //        resetFocus()


    // Code I've actually written...


    //        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)

//    Set Game view so bounds are accessible elsewhere

    self.camera = cam
    Game.sharedInstance.mainView = view
    let skView = view

    let bottomleft = CGPoint(x: 0.0, y: 0.0)
    let center = CGPoint(x: 0.5, y: 0.5)

    let myContentNode = SKSpriteNode(color: UIColor.blue, size: CGSize(width:2000, height:2000))

    myContentNode.anchorPoint = bottomleft

    let red1Node = SKSpriteNode(color: UIColor.red, size: CGSize(width:500, height: 500))
    red1Node.position = CGPoint(x: 500, y: 500)
    red1Node.anchorPoint = center

    let red2Node = SKSpriteNode(color: UIColor.red, size: CGSize(width:1000, height: 1000))
    red2Node.position = CGPoint(x: 1500.0, y: 1500.0)
    red2Node.anchorPoint = center
    let greenNode = SKSpriteNode(color: UIColor.green, size: CGSize(width:100, height: 100))
    greenNode.position = CGPoint(x: 1000.0, y: 1000.0)
    greenNode.anchorPoint = center

    myContentNode.addChild(red1Node)
    myContentNode.addChild(red2Node)
    myContentNode.addChild(greenNode)

//    for (var i = 0; i<500; i += 10) {
//      let greenNode = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width:20, height: 20))
//      greenNode.position = CGPoint(x: i, y: i)
//      myContentNode.addChild(greenNode)
//    }


//    myContentNode.addChild(staticObjects)
//    print("size is")
//    print(view.bounds.size)
//    print(myContentNode.size)

//    myScrollNode.hlSetGestureTarget(myScrollNode)
//    self.registerDescendant(myScrollNode, withOptions:NSSet(objects: HLSceneChildResizeWithScene, HLSceneChildGestureTarget) as Set<NSObject>)

//    print(myContentNode.position)

    Game.sharedInstance.entityManager = EntityManager(node: myContentNode)
    createTiles()

    let debugLayer = SpriteDebugComponent.debugLayer
    let debugTexture = view.texture(from: debugLayer)
    let debugNode = SKSpriteNode(texture: debugTexture)
    debugNode.zPosition = 100
    debugNode.anchorPoint = CGPoint(x: 0,y: 0)
    // for thickness of line
    debugNode.position = CGPoint(x: -1,y: -1)

    print("debug node size is")
    print(debugNode.size)
    print(debugNode.position)

//    myContentNode.addChild(debugNode)

    Game.sharedInstance.toolbarManager = ToolbarManager(scene: self)

    let gameToolbar = GameToolbar(size: CGSize(width: view.bounds.width, height: 64))
    Game.sharedInstance.toolbarManager?.addToolbar(gameToolbar, location: Game.rotation.south, shown: true)

    let debugToolbar = DebugToolbar(size: CGSize(width: 64, height: view.bounds.height - 64))
    Game.sharedInstance.toolbarManager?.addToolbar(debugToolbar, location: Game.rotation.east, shown: false)
    debugToolbar.isHidden = true


//    Only temp
//    Game.sharedInstance.gameToolbar = gameToolbar

//    Change this to work same as above
//    let confirmToolbar = ConfirmToolbar(size: CGSize(width: view.bounds.width, height: 64))
//    Game.sharedInstance.toolbarManager?.addToolbar(confirmToolbar)

//    Game.sharedInstance.confirmToolbar!.hlSetGestureTarget(Game.sharedInstance.confirmToolbar)
//    self.addChild(Game.sharedInstance.confirmToolbar!)
//    Game.sharedInstance.confirmToolbar?.hideAnimated(true)
//
//    self.registerDescendant(Game.sharedInstance.confirmToolbar, withOptions: Set(arrayLiteral: HLSceneChildGestureTarget))


    self.addChild(myContentNode)

    Game.sharedInstance.wolrdnode = myContentNode

    self.HL_showMessage("testing!")

    self.isPaused = false

  }

  override func didChangeSize(_ oldSize: CGSize) {
    super.didChangeSize(oldSize)

    updateCameraScale()

  }

  /// Centers the scene's camera on a given point.
  func centerCameraOnPoint(_ point: CGPoint) {
    if let camera = camera {
      camera.position = point
    }
  }

  /// Scales the scene's camera.
  func updateCameraScale() {
    /*
    Because the game is normally playing in landscape, use the scene's current and
    original heights to calculate the camera scale.
    */
    if let camera = camera {
      camera.setScale(nativeSize.height / size.height)
    }
  }


  func createTiles() {

    let initSize: [Int] = [10, 10]

    for x: Int in 0 ..< initSize[0] {
      Game.sharedInstance.tilesAtCoords[x] = [:]
      for y: Int in 0 ..< initSize[1] {

        let tile = Tile(imageName: "Graphics/Tile.png", x: x, y: y)

        Game.sharedInstance.tilesAtCoords[x]![y] = tile

        Game.sharedInstance.entityManager.add(tile, layer: ZPositionManager.WorldLayer.ground)
      }
    }


  }


  // Taken from entity component example artcile...
  override func update(_ currentTime: TimeInterval) {

    super.update(currentTime)

    lastUpdateTimeInterval = currentTime
    //    let deltaTime = currentTime - lastUpdateTimeInterval
    //    Game.sharedInstance.entityManager.update(deltaTime)


    var elapsedTime = currentTime - updateLastTime;

    updateLastTime = currentTime

    if (elapsedTime < 0.0) {
      elapsedTime = 0.0;
    }
    // note: If framerate is crazy low, pretend time has slowed down, too.
    if (elapsedTime > 0.2) {
      elapsedTime = 0.01;
    }


    if (Game.sharedInstance.canAutoScroll) {
//      self.updateAutoScroll(elapsedTime)
    } else {
      Game.sharedInstance.autoScrollVelocityX = 0;
      Game.sharedInstance.autoScrollVelocityY = 0;
    }
  }



//Would need to redevelop this function
//  func updateAutoScroll(_ time: CFTimeInterval) {
//
//      let scrollXDistance = Game.sharedInstance.autoScrollVelocityX * CGFloat(time);
//      let scrollYDistance = Game.sharedInstance.autoScrollVelocityY * CGFloat(time);
//
//      // note: Scrolling velocity is measured in scene units, not world units (i.e. regardless of world scale).
//      let currentOffset = Game.sharedInstance.wolrdnode.contentOffset;
//
//      let positionX = (currentOffset.x - scrollXDistance / Game.sharedInstance.wolrdnode.xScale)
//      let positionY = (currentOffset.y - scrollYDistance / Game.sharedInstance.wolrdnode.yScale)
//
//      let currentScale = Game.sharedInstance.wolrdnode.contentScale
//      Game.sharedInstance.wolrdnode.setContentOffset(CGPoint(x: positionX, y: positionY), contentScale: currentScale)
//
//  }


  func HL_showMessage(_ message: NSString) {


    let _messageNode = HLMessageNode(color: UIColor.black, size: CGSize.zero)

    _messageNode?.zPosition = 10000
    _messageNode?.fontName = "Helvetica"
    _messageNode?.fontSize = 12.0
    _messageNode?.verticalAlignmentMode = HLLabelNodeVerticalAlignmentMode.alignFont

    _messageNode?.messageLingerDuration = 4.0

    _messageNode?.size = CGSize(width: self.size.width, height: 20.0)
    _messageNode?.position = CGPoint(x: 0, y: 0 + self.size.height);
    _messageNode?.anchorPoint = CGPoint(x: 0, y: 1)
    _messageNode?.showMessage(message as String, parent: self)
  }


  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    let touch = touches.first!
    let positionInScene = touch.location(in: self)
    let positionInWorldnodeContent = touches.first?.location(in: Game.sharedInstance.wolrdnode)
    let touchedNodes = self.nodes(at: positionInScene)

    var draggingDraggableNode = false
    Game.sharedInstance.touchDidMove = false
    //    Also check if buildbale and possible to have position
    if (Game.sharedInstance.buildItemStateMachine.currentState is BISPlace) {
      draggingDraggableNode = true
    }

    var topTappableNodeEntity = GKEntity()
    var topDraggableNodeEntity = GKEntity()
    for node in touchedNodes {
      guard let entity: GKEntity = node.userData?["entity"] as? GKEntity else {continue}

      if (entity.component(ofType: DraggableSpriteComponent.self) != nil) {
        topDraggableNodeEntity = node.zPosition > topDraggableNodeEntity.component(ofType: SpriteComponent.self)?.node.zPosition ? entity : topDraggableNodeEntity

        Game.sharedInstance.draggingEntiy = topDraggableNodeEntity
        draggingDraggableNode = true
        Game.sharedInstance.toolbarManager?.hideAll()
      }

      if (entity.component(ofType: TouchableSpriteComponent.self) != nil) {
        topTappableNodeEntity = node.zPosition > topTappableNodeEntity.component(ofType: SpriteComponent.self)?.node.zPosition ? entity : topTappableNodeEntity
      }

    }
    topDraggableNodeEntity.component(ofType: DraggableSpriteComponent.self)?.touchStart(positionInWorldnodeContent!)

    Game.sharedInstance.tappableEntity = topTappableNodeEntity

    Game.sharedInstance.panningWold = !draggingDraggableNode

  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    print("touches moved ------------")

    let positionInSceneView = touches.first?.location(in: self.view)
    Game.sharedInstance.touchDidMove = true

    if (Game.sharedInstance.panningWold) {
      panWold(touches)
    }

    let positionInWorldnodeContent = touches.first?.location(in: Game.sharedInstance.wolrdnode)

    if (Game.sharedInstance.draggingEntiy != nil) {
      Game.sharedInstance.draggingEntiy?.component(ofType: DraggableSpriteComponent.self)?.touchMove(positionInWorldnodeContent!)
    }

    if (Game.sharedInstance.canAutoScroll && !Game.sharedInstance.panningWold) {
      checkAutoScroll(positionInSceneView!)
    }

    // Reset tappabe entity because tap is now invalid
    Game.sharedInstance.tappableEntity = nil

  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
     print("touches ended")
//    Game.sharedInstance.gameToolbar?.hidden = false


    if (Game.sharedInstance.tappableEntity != nil) {
      Game.sharedInstance.tappableEntity?.component(ofType: TouchableSpriteComponent.self)?.callFunction()
    }
    let touch = touches.first!
    let positionInScene = touch.location(in: self)

    if (Game.sharedInstance.touchDidMove) {
      if (Game.sharedInstance.draggingEntiy != nil) {
        Game.sharedInstance.toolbarManager?.showAll()
      }

      Game.sharedInstance.autoScrollVelocityX = 0;
      Game.sharedInstance.autoScrollVelocityY = 0;

      Game.sharedInstance.draggingEntiy?.component(ofType: DraggableSpriteComponent.self)?.touchEnd(positionInScene)
      Game.sharedInstance.draggingEntiy = nil
    }



  }


  func panWold(_ touches: Set<UITouch>) {
    let positionInScene = touches.first!.location(in: self)
    let previousLocation = touches.first!.previousLocation(in: self)

    self.camera?.position.x -= positionInScene.x - previousLocation.x
    self.camera?.position.y -= positionInScene.y - previousLocation.y
  }



  func checkAutoScroll(_ point: CGPoint) {


//    let FLWorldAutoScrollMarginSizeMax = CGFloat(96.0)
//
//    var marginSize = min(self.size.width, self.size.height) / 7.0
//
//    if (marginSize > FLWorldAutoScrollMarginSizeMax) {
//      marginSize = FLWorldAutoScrollMarginSizeMax
//    }

    let marginSize = CGFloat(64)



    let FLAutoScrollVelocityMin = CGFloat(4.0)
    let FLAutoScrollVelocityLinear = CGFloat(800.0)

    let scorllNode = Game.sharedInstance.wolrdnode

    var autoScroll = false

//    Remove this at some point!
    let additionalYMargin = CGFloat(0)

    let sceneXMin = CGFloat((scorllNode?.size.width)! * -1.0 * (scorllNode?.anchorPoint.x)!)
    let sceneXMax = CGFloat(sceneXMin + self.size.width)
    let sceneYMin = CGFloat((scorllNode?.size.height)! * -1.0 * (scorllNode?.anchorPoint.y)!)
    let sceneYMax = CGFloat(sceneYMin + self.size.height)


    var proximity = CGFloat(0.0)
    if (point.x < sceneXMin + marginSize) {
      let proximityX = ((sceneXMin + marginSize) - point.x) / marginSize
      proximity = proximityX
      autoScroll = true
    } else if (point.x > sceneXMax - marginSize) {
      let proximityX = (point.x - (sceneXMax - marginSize)) / marginSize
      proximity = proximityX
      autoScroll = true
    }
//    marginSize = marginSize + additionalMargin

    if (point.y < sceneYMin + marginSize + additionalYMargin) {
      let proximityY = ((sceneYMin + marginSize) - point.y + additionalYMargin) / marginSize
      if (proximityY > proximity) {
        proximity = proximityY
      }
      autoScroll = true
    } else if (point.y > sceneYMax - marginSize - additionalYMargin) {
      let proximityY = (point.y + additionalYMargin - (sceneYMax - marginSize)) / marginSize
      if (proximityY > proximity) {
        proximity = proximityY
      }
      autoScroll = true
    }


    if (autoScroll) {
      let sceneXCenter = sceneXMin + self.size.width / 2.0
      let sceneYCenter = sceneYMin + self.size.height / 2.0
      let locationOffsetX = point.x - sceneXCenter
      let locationOffsetY = -(point.y - sceneYCenter)
      let locationOffsetSum = abs(locationOffsetX) + abs(locationOffsetY)
      let speed = FLAutoScrollVelocityLinear * proximity + FLAutoScrollVelocityMin

      Game.sharedInstance.autoScrollVelocityX = (locationOffsetX / locationOffsetSum) * speed

      Game.sharedInstance.autoScrollVelocityY = (locationOffsetY / locationOffsetSum) * speed

//      _worldAutoScrollState.gestureUpdateBlock = gestureUpdateBlock;
    } else {
      Game.sharedInstance.autoScrollVelocityX = 0;
      Game.sharedInstance.autoScrollVelocityY = 0;
    }



  }


}
