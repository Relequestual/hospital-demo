
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

/**
 A base class for all of the scenes in the app.
 */
class BaseScene: HLScene {

  // Update time
  var lastUpdateTimeInterval: NSTimeInterval = 0

  var updateLastTime: NSTimeInterval = 0
  
  /**
   The native size for this scene. This is the height at which the scene
   would be rendered if it did not need to be scaled to fit a window or device.
   Defaults to `zeroSize`; the actual value to use is set in `createCamera()`.
   */
  var nativeSize = CGSize.zero


  var staticObjects = SKSpriteNode()

  var _panLastNodeLocation = CGPoint()


  /// A reference to the scene manager for scene progression.
  //    weak var sceneManager: SceneManager!

  // MARK: SKScene Life Cycle

  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)


    updateCameraScale()
    //        overlay?.updateScale()

    // Listen for updates to the player's controls.
    //        sceneManager.gameInput.delegate = self

    // Find all the buttons and set the initial focus.
    //        buttons = findAllButtonsInScene()
    //        resetFocus()


    // Code I've actually written...


    //        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)

    let bottomleft = CGPoint(x: 0.0, y: 0.0)
    let center = CGPoint(x: 0.5, y: 0.5)

    let myContentNode = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width:2000, height:2000))

    myContentNode.anchorPoint = bottomleft

    let red1Node = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width:500, height: 500))
    red1Node.position = CGPoint(x: 500, y: 500)
    red1Node.anchorPoint = center

    let red2Node = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width:1000, height: 1000))
    red2Node.position = CGPoint(x: 1500.0, y: 1500.0)
    red2Node.anchorPoint = center
    let greenNode = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width:100, height: 100))
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

    let myScrollNode: HLScrollNode = HLScrollNode(size: view.bounds.size, contentSize: myContentNode.size)
    myScrollNode.anchorPoint = bottomleft
    myScrollNode.contentAnchorPoint = bottomleft
    myScrollNode.contentScaleMinimum = 0.0
    myScrollNode.contentNode = myContentNode

//    myScrollNode.hlSetGestureTarget(myScrollNode)
//    self.registerDescendant(myScrollNode, withOptions:NSSet(objects: HLSceneChildResizeWithScene, HLSceneChildGestureTarget) as Set<NSObject>)

//    print(myContentNode.position)

    Game.sharedInstance.entityManager = EntityManager(node: myContentNode)
    createTiles()
    
    let debugLayer = SpriteDebugComponent.debugLayer
    let debugTexture = view.textureFromNode(debugLayer)
    let debugNode = SKSpriteNode(texture: debugTexture)
    debugNode.zPosition = 100
    debugNode.anchorPoint = CGPoint(x: 0,y: 0)
    // for thickness of line
    debugNode.position = CGPoint(x: -1,y: -1)

    print("debug node size is")
    print(debugNode.size)
    print(debugNode.position)

//    myContentNode.addChild(debugNode)

    myScrollNode.zPosition = 50
    
    Game.sharedInstance.gameToolbar = GameToolbar(size: CGSize(width: view.bounds.width, height: 64), baseScene: self)
    Game.sharedInstance.gameToolbar?.showUpdateOrigin(CGPoint(x: 0, y: -60))
    Game.sharedInstance.gameToolbar!.hlSetGestureTarget(Game.sharedInstance.gameToolbar)
    self.addChild(Game.sharedInstance.gameToolbar!)

    self.registerDescendant(Game.sharedInstance.gameToolbar, withOptions: Set(arrayLiteral: HLSceneChildGestureTarget))


    myScrollNode.position = CGPoint(x: 0, y: 0)
//  Offset below to move above bottom toolbar
//    myScrollNode.position = CGPoint(x: 0, y: 64)


    myScrollNode.contentClipped = true

    self.gestureTargetHitTestMode = HLSceneGestureTargetHitTestMode.ZPositionThenParent
    
    self.addChild(myScrollNode)
    
    Game.sharedInstance.wolrdnode = myScrollNode
    
    self.HL_showMessage("testing!")

    self.paused = false

  }

  override func didChangeSize(oldSize: CGSize) {
    super.didChangeSize(oldSize)

    updateCameraScale()

  }

  /// Centers the scene's camera on a given point.
  func centerCameraOnPoint(point: CGPoint) {
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

    for var x: Int = 0; x < initSize[0]; x++ {
      Game.sharedInstance.tilesAtCoords[x] = [:]
      for var y: Int = 0; y < initSize[1]; y++ {

        let tile = Tile(imageName: "Graphics/Tile.png", x: x, y: y)

        Game.sharedInstance.tilesAtCoords[x]![y] = tile

        Game.sharedInstance.entityManager.add(tile, layer: ZPositionManager.WorldLayer.ground)
      }
    }


  }


  // Taken from entity component example artcile...
  override func update(currentTime: CFTimeInterval) {

    super.update(currentTime)

    lastUpdateTimeInterval = currentTime
    let deltaTime = currentTime - lastUpdateTimeInterval
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
      self.updateAutoScroll(elapsedTime)
    } else {
      Game.sharedInstance.autoScrollVelocityX = 0;
      Game.sharedInstance.autoScrollVelocityY = 0;
    }
  }




  func updateAutoScroll(time: CFTimeInterval) {

      let scrollXDistance = Game.sharedInstance.autoScrollVelocityX * CGFloat(time);
      let scrollYDistance = Game.sharedInstance.autoScrollVelocityY * CGFloat(time);

      // note: Scrolling velocity is measured in scene units, not world units (i.e. regardless of world scale).
      let currentOffset = Game.sharedInstance.wolrdnode.contentOffset;

      let positionX = (currentOffset.x - scrollXDistance / Game.sharedInstance.wolrdnode.xScale)
      let positionY = (currentOffset.y - scrollYDistance / Game.sharedInstance.wolrdnode.yScale)

      let currentScale = Game.sharedInstance.wolrdnode.contentScale
      Game.sharedInstance.wolrdnode.setContentOffset(CGPoint(x: positionX, y: positionY), contentScale: currentScale)

  }


  func HL_showMessage(message: NSString) {

    
    let _messageNode = HLMessageNode(color: UIColor.blackColor(), size: CGSizeZero)

    _messageNode.zPosition = 10000
    _messageNode.fontName = "Helvetica"
    _messageNode.fontSize = 12.0
    _messageNode.verticalAlignmentMode = HLLabelNodeVerticalAlignmentMode.AlignFont

    _messageNode.messageLingerDuration = 4.0

    _messageNode.size = CGSize(width: self.size.width, height: 20.0)
    _messageNode.position = CGPoint(x: 0, y: 0 + self.size.height);
    _messageNode.anchorPoint = CGPoint(x: 0, y: 1)
    _messageNode.showMessage(message as String, parent: self)
  }

  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

    let touch = touches.first!
    let positionInScene = touch.locationInNode(self)
    let positionInWorldnodeContent = touches.first?.locationInNode(Game.sharedInstance.wolrdnode.contentNode)
    let touchedNodes = self.nodesAtPoint(positionInScene)
    _panLastNodeLocation = positionInScene
    
    var draggingDraggableNode = false
    Game.sharedInstance.touchDidMove = false
    //    Also check if buildbale and possible to have position
    if (Game.sharedInstance.buildStateMachine.currentState is BISPlace) {
      draggingDraggableNode = true
    }
    
    var topTappableNodeEntity = GKEntity()
    var topDraggableNodeEntity = GKEntity()
    for node in touchedNodes {
      guard let entity: GKEntity = node.userData?["entity"] as? GKEntity else {continue}
      
      if (entity.componentForClass(DraggableSpriteComponent) != nil) {
        topDraggableNodeEntity = node.zPosition > topDraggableNodeEntity.componentForClass(SpriteComponent)?.node.zPosition ? entity : topDraggableNodeEntity

        Game.sharedInstance.draggingEntiy = topDraggableNodeEntity
        draggingDraggableNode = true
        print("pre hide xscale is ")
        print(Game.sharedInstance.gameToolbar?.xScale)
        Game.sharedInstance.gameToolbar?.hideAnimated(true)
        
        Game.sharedInstance.gameToolbar?.hidden = true
      }

      if (entity.componentForClass(TouchableSpriteComponent) != nil) {
        topTappableNodeEntity = node.zPosition > topTappableNodeEntity.componentForClass(SpriteComponent)?.node.zPosition ? entity : topTappableNodeEntity
      }
      
    }
    topDraggableNodeEntity.componentForClass(DraggableSpriteComponent)?.entityTouchStart(positionInWorldnodeContent!)
    
    Game.sharedInstance.tappableEntity = topTappableNodeEntity

    Game.sharedInstance.panningWold = !draggingDraggableNode

  }

  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    print("touches moved ------------")

    let positionInSceneView = touches.first?.locationInView(self.view)
    Game.sharedInstance.touchDidMove = true

    if (Game.sharedInstance.panningWold) {
      panWold(touches)
    }
    
    let positionInWorldnodeContent = touches.first?.locationInNode(Game.sharedInstance.wolrdnode.contentNode)
    
    if (Game.sharedInstance.draggingEntiy != nil) {
      Game.sharedInstance.draggingEntiy?.componentForClass(DraggableSpriteComponent)?.entityTouchMove(positionInWorldnodeContent!)
    }

    if (Game.sharedInstance.canAutoScroll && !Game.sharedInstance.panningWold) {
      checkAutoScroll(positionInSceneView!)
    }

    // Reset tappabe entity because tap is now invalid
    Game.sharedInstance.tappableEntity = nil

  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
     print("touches ended")
//    Game.sharedInstance.gameToolbar?.hidden = false
    
    if (Game.sharedInstance.gameToolbar!.hidden) {
    
      Game.sharedInstance.gameToolbar?.showWithOrigin(CGPoint(x: 0, y: -64), finalPosition: CGPoint(x: 0, y: 0), fullScale: 1.0, animated: true)
      Game.sharedInstance.gameToolbar?.hidden = false
      if (((Game.sharedInstance.gameToolbar?.parent) == nil)){
        self.addChild(Game.sharedInstance.gameToolbar!)
      }
    }
    
    if (Game.sharedInstance.tappableEntity != nil) {
      Game.sharedInstance.tappableEntity?.componentForClass(TouchableSpriteComponent)?.callFunction()
    }
    let touch = touches.first!
    let positionInScene = touch.locationInNode(self)

    if (Game.sharedInstance.touchDidMove) {

      Game.sharedInstance.autoScrollVelocityX = 0;
      Game.sharedInstance.autoScrollVelocityY = 0;
     
      Game.sharedInstance.draggingEntiy?.componentForClass(DraggableSpriteComponent)?.touchEnd(positionInScene)
      Game.sharedInstance.draggingEntiy = nil
    }
    


  }
  
  override func touchesEstimatedPropertiesUpdated(touches: Set<NSObject>) {
    print("----- estmate updated")
  }
  
  func panWold(touches: Set<UITouch>) {
    let positionInScene = touches.first?.locationInNode(self)
    let nodeLocation = convertPoint(positionInScene!, fromNode: self)
    
    let contentNodeLocation = Game.sharedInstance.wolrdnode.contentOffset
    let translationInNode = CGPointMake(nodeLocation.x - _panLastNodeLocation.x, nodeLocation.y - _panLastNodeLocation.y)
    
    let currentScale = Game.sharedInstance.wolrdnode.contentScale
    Game.sharedInstance.wolrdnode.setContentOffset(CGPoint(x: contentNodeLocation.x + translationInNode.x, y: contentNodeLocation.y + translationInNode.y), contentScale: currentScale)
    
    _panLastNodeLocation = nodeLocation
  }
  
  
  
  func checkAutoScroll(point: CGPoint) {
    
    
//    let FLWorldAutoScrollMarginSizeMax = CGFloat(96.0)
//    
//    var marginSize = min(self.size.width, self.size.height) / 7.0
//    
//    if (marginSize > FLWorldAutoScrollMarginSizeMax) {
//      marginSize = FLWorldAutoScrollMarginSizeMax
//    }

    var marginSize = CGFloat(64)

    
    
    let FLAutoScrollVelocityMin = CGFloat(4.0)
    let FLAutoScrollVelocityLinear = CGFloat(800.0)

    let scorllNode = Game.sharedInstance.wolrdnode

    var autoScroll = false
    
    let additionalYMargin = CGFloat(64)

    let sceneXMin = CGFloat(scorllNode.size.width * -1.0 * scorllNode.anchorPoint.x)
    let sceneXMax = CGFloat(sceneXMin + self.size.width)
    let sceneYMin = CGFloat(scorllNode.size.height * -1.0 * scorllNode.anchorPoint.y)
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