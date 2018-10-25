//
//  ScrollNode.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 06/09/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//
// Based on: INSKScrollNode.m


import SpriteKit


// Copyright (c) 2014 Sven Korset
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


//#import "INSKScrollNode.h"
//#import "INSKOSBridge.h"
//#import "INSKMath.h"
//#import "SKNode+INExtension.h"

enum INSKScrollNodeDecelerationMode: Int {
  /**
   No paging or any deceleration functions to use, the default.
   The content will be left right there where the user lifted the finger, so scrolling abruptly stops.
   */
  case None = 0,
  /**
   The page snaps accordingly to where the most of the actual content is inside,
   so the user has to move the finger at least half a page size to get snapped to the next.
   */
  PagingHalfPage,
  /**
   The page snaps accordingly to the direction of the last touch move, i.e.
   when dragged to the right and the finger lifted the page will snap to the next right page
   regardless of the distance the finger moved.
   */
  PagingDirection,
  /**
   The content uses a smooth deceleration.
   The content will move a little bit in the direction the user moved it before it slowly stops.
   */
  Decelerate
}

protocol INSKScrollNodeDelegate {


  /**
   Optional delegate method which will be called when the content scroll node has been moved by the user.

   This method is called for every touch move event.

   @param scrollNode The ISKScrollNode node which informs about the scrolling.
   @param fromOffset The scrollContentNode's starting position.
   @param toOffset The scrollContentNode's end position.
   @param velocity The scrollContentNode's velocity averaged.
   */
   func scrollNode(_ scrollNode: INSKScrollNode?, didScrollFromOffset fromOffset: CGPoint, toOffset: CGPoint, velocity: CGPoint)



  /**
   Optional delegate method which will be called when the content scroll node has finished moving and the user has lifted all fingers.

   This method is only called once when the last touch has been lifted.
   If no paging or automated scrolling is enabled the method will be called right after the user has lifted the finger,
   otherwise the method call is delayed until the scroll animation has finished.

   @param scrollNode The ISKScrollNode node which informs about the scrolling.
   @param offset The final scrollContentNode's position.
   */
   func scrollNode(_ scrollNode: INSKScrollNode?, didFinishScrollingAtPosition offset: CGPoint)

}

//---

let ScrollContentMoveActionName:String! = "INSKScrollNodeMoveScrollContent"
let ScrollContentMoveActionDuration:CGFloat = 0.3
let MaxNumberOfVelocities:Int = 5

/**
 A node with a scrolling ability.

 Add subnodes to the scrollContentNode, define the sizes and the user can pan the content around. To initialize a INSKScrollNode do the following steps

 - Create a new instance of the class with initWithSize:
 - Set scrollContentSize to the size of the scrollable content area to show inside of the visible scroll area.
 - Add subnodes to scrollContentNode at the appropriate positions.
 - Optionally set the clipContent flag if clipping is needed.

 INSKScrollNode *scrollNode = [INSKScrollNode scrollNodeWithSize:sizeOfScrollNode];
 scrollNode.position = positionOfScrollNode;
 scrollNode.scrollContentSize = sizeOfContent;
 scrollNode.scrollContentNode addChild:anySKNodeTreeToShowAsContent];
 [self addChild:scrollNode];
 The content node's origin is defined as the upper left corner, so the scroll node's frame is right bottom of the node's position. Adding it directly to the scene node will not show the scroll content, because it will be just under the screen, instead set the position to something like

 scrollNode.position = CGPointMake(0, scene.size.height);
 scrollNode.scrollContentSize = scene.size;
 scrollNode.scrollBackgroundNode.color = [SKColor yellowColor]; // for debugging purposes makes the scroll node visible

 Because the scroll content is under the origin all content objects added to scrollContentNode should therefore have a position with a negative value for the Y-axis.

 SKSpriteNode *picture = [SKSpriteNode spriteNodeWithImageNamed:@"picture"];
 picture.position = CGPoint(scene.size.width / 2, -scene.size.height / 2);
 [scrollNode.scrollContentNode addChild:picture];

 */

class INSKScrollNode : SKNode {

  // MARK: - public methods

  var scrollDelegate:INSKScrollNodeDelegate!

  private var _scrollNodeSize: CGSize
  var scrollNodeSize:CGSize {
    get { return _scrollNodeSize }
    set(scrollNodeSize) {
      _scrollNodeSize = scrollNodeSize
      self.scrollBackgroundNode.size = scrollNodeSize
      if self.contentCropNode != nil {
        (self.contentCropNode.maskNode as! SKSpriteNode).size = scrollNodeSize
      }
    }
  }

  private var _scrollContentSize: CGSize = CGSize.zero
  var scrollContentSize:CGSize {
    get { return _scrollContentSize }
    set(scrollContentSize) {
      self._scrollContentSize = scrollContentSize
      self.stopScrollAnimations()
      self.applyScrollLimits()
    }
  }
  private var _scrollContentPosition:CGPoint = CGPoint.zero
  var scrollContentPosition:CGPoint {
    get {
      let position:CGPoint = _scrollContentPosition
      if self.scrollContentNode.parent != self {
        return self.convert(position, from:self.scrollContentNode.parent!)
      }
      return _scrollContentPosition
    }
    set(scrollContentPosition) {
      _scrollContentPosition = scrollContentPosition
      var position = scrollContentPosition
      if self.scrollContentNode.parent != self {
        position = self.convert(scrollContentPosition, to: self.scrollContentNode.parent!)
      }
      self.scrollContentNode.position = position
      self.stopScrollAnimations()
      self.applyScrollLimits()
    }
  }

  private(set) var scrollBackgroundNode:SKSpriteNode!
  private(set) var scrollContentNode:SKNode!
  private var _clipContent:Bool
  var clipContent:Bool {
    get { return _clipContent }
    set(clipContent) {
      if _clipContent == clipContent {
        return
      }
      _clipContent = clipContent

      // Create crop node if needed
      if _clipContent && _contentCropNode == nil {
        let maskNode:SKSpriteNode! = SKSpriteNode(color: SKColor.black, size:self.scrollBackgroundNode.size)
//        maskNode.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        let cropNode:SKCropNode! = SKCropNode.init()
        cropNode.maskNode = maskNode
        _contentCropNode = cropNode
      }

      // Add content and crop node
      self.stopScrollAnimations()
      if _clipContent {
        self.contentCropNode.changeParent(self)
        self.scrollContentNode.changeParent(self.contentCropNode)
      } else {
        self.scrollContentNode.changeParent(self)
        self.contentCropNode.removeFromParent()
      }
      self.scrollContentPosition = self.scrollContentNode.position
    }
  }
  private var _contentCropNode:SKCropNode!
  var contentCropNode:SKCropNode! {
    get { return _contentCropNode }
    set(contentCropNode) {
      // First disable clipping so the old crop node will be disabled
      let oldClipFlag:Bool = self.clipContent
      self.clipContent = false
      // Exchange the crop node, which also may be nil
      _contentCropNode = contentCropNode
      // Restore the clipping flag to add the content to the new crop node and create a default one if nil
      self.clipContent = oldClipFlag
    }
  }
  var decelerationMode:INSKScrollNodeDecelerationMode  = INSKScrollNodeDecelerationMode.None
  var pageSize:CGSize = CGSize.zero
  var deceleration:CGFloat = 10000
  var scrollingEnabled:Bool = true
  private var lastTouchTimestamp:TimeInterval = 0
  private var lastVelocities:NSMutableArray!
  private var numberOfMouseButtonsPressed:UInt = 0
//  private var positionOfLastMouseEvent:CGPoint

  class func scrollNodeWithSize(scrollNodeSize:CGSize) -> Self {
    return self.init(scrollNodeSize:scrollNodeSize)
  }

  required init(scrollNodeSize:CGSize) {
    _clipContent = false
    _scrollNodeSize = scrollNodeSize
    super.init()
//    if self == nil {return self}

    self.scrollBackgroundNode = SKSpriteNode(color: SKColor.clear, size:self.scrollNodeSize)
    self.scrollBackgroundNode.anchorPoint = CGPoint(x: 0.0, y: 1.0)
    self.addChild(self.scrollBackgroundNode)

    // create scroll content node
    self.scrollContentNode = SKNode()
    self.addChild(self.scrollContentNode)

    self.scrollNodeSize = scrollNodeSize
    self.scrollContentSize = CGSize.zero
    self.lastVelocities = NSMutableArray(capacity: MaxNumberOfVelocities)

    self.numberOfMouseButtonsPressed = 0

    // create background node


  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setScrollContentPosition(scrollContentPosition:CGPoint, animationDuration duration:CGFloat) {
    if duration <= 0 || INSKMaths.CGPointNearToPoint(point1: scrollContentPosition, point2: self.scrollContentPosition) {
      self.scrollContentPosition = scrollContentPosition
      return
    }

    // v(t) = a * t + v0; s(t) = (a/2) * t*t + v0 * t + s0
    // v0 = v(t) - (a * t); sdiff = s(t) - s0; a = -2 * sdiff / t*t
    let positionDifference:CGPoint = INSKMaths.CGPointSubtract(point1: scrollContentPosition, point2: self.scrollContentPosition)
    let differenceLength:CGFloat = INSKMaths.CGPointLength(point: positionDifference)
    let differenceNormalized:CGPoint = INSKMaths.CGPointMultiplyScalar(point: positionDifference, value: 1.0 / differenceLength)
    let deceleration:CGFloat = differenceLength * -2 / (duration * duration)
    let velocity:CGFloat = deceleration * -duration

    let startPosition:CGPoint = self.scrollContentPosition

    let move:SKAction! = SKAction.customAction(withDuration: TimeInterval(duration), actionBlock:{ (node:SKNode!,elapsedTime:CGFloat) in
      let distance:CGFloat = (deceleration / 2) * (elapsedTime * elapsedTime) + velocity * elapsedTime
      let translation:CGPoint = CGPoint(x: distance * differenceNormalized.x, y: distance * differenceNormalized.y)
      var currentPosition:CGPoint = INSKMaths.CGPointAdd(point1: startPosition, point2: translation)
      currentPosition = self.positionWithScrollLimitsApplyed(position: currentPosition)
      if node.parent != self {
        currentPosition = self.convert(currentPosition, to:node.parent!)
      }
      node.position = currentPosition
    })
    let callback:SKAction! = SKAction.run({
      self.didFinishScrollingAtPosition(offset: self.scrollContentPosition)
    })
    self.scrollContentNode.run(SKAction.sequence([move, callback]), withKey: ScrollContentMoveActionName)
  }

  func numberOfPagesX() -> UInt {
    if self.pageSize.width > 0 {
      return UInt(ceilf(Float((self.scrollContentSize.width - self.scrollNodeSize.width) / self.pageSize.width)))
    }
    return 0
  }

  func numberOfPagesY() -> UInt {
    if self.pageSize.height > 0 {
      return UInt(ceilf(Float((self.scrollContentSize.height - self.scrollNodeSize.height) / self.pageSize.height)))
    }
    return 0
  }

  func currentPageX() -> UInt {
    if self.pageSize.width > 0 {
      return UInt(roundf(Float(-self.scrollContentPosition.x / self.pageSize.width)))
    }
    return 0
  }

  func currentPageY() -> UInt {
    if self.pageSize.height > 0 {
      return UInt(roundf(Float(self.scrollContentPosition.y / self.pageSize.height)))
    }
    return 0
  }


  // MARK: - private methods

  // Position has to be in the coordinate system of self (INSKScrollNode).
  // Get the position via scrollContentPosition or convert manually if the crop node is active.
  func positionWithScrollLimitsApplyed(position:CGPoint) -> CGPoint {
//    print(position)
    var newPosition = position
    // Limit scrolling horizontally
    if self.scrollContentSize.width <= self.scrollNodeSize.width {
      newPosition = CGPoint(x: 0, y: newPosition.y)
    } else  if newPosition.x > 0.0 {
      newPosition = CGPoint(x: 0, y: newPosition.y)
    } else if newPosition.x < -(self.scrollContentSize.width - self.scrollNodeSize.width) {
      newPosition = CGPoint(x: -(self.scrollContentSize.width - self.scrollNodeSize.width), y: newPosition.y)
    }

    // Limit scrolling vertically
    if self.scrollContentSize.height <= self.scrollNodeSize.height {
      newPosition = CGPoint(x: newPosition.x, y: 0)
    } else if position.y < 0.0 {
      newPosition = CGPoint(x: newPosition.x, y: 0)
    } else if position.y > self.scrollContentSize.height - self.scrollNodeSize.height {
      newPosition = CGPoint(x: newPosition.x, y: self.scrollContentSize.height - self.scrollNodeSize.height)
    }

    return newPosition
  }

  func applyScrollLimits() {
    var currentPosition:CGPoint = self.positionWithScrollLimitsApplyed(position: self.scrollContentPosition)
    if self.scrollContentNode.parent != self {
      currentPosition = self.convert(currentPosition, to:self.scrollContentNode.parent!)
    }
    self.scrollContentNode.position = currentPosition
  }

  func stopScrollAnimations() {
    self.scrollContentNode.removeAction(forKey: ScrollContentMoveActionName)
  }

  func applyScrollOutWithVelocity(velocity:CGPoint) {
    if self.decelerationMode == INSKScrollNodeDecelerationMode.None {
      self.didFinishScrollingAtPosition(offset: self.scrollContentPosition)
      return
    }

    if self.decelerationMode == INSKScrollNodeDecelerationMode.Decelerate {
      // Any velocity at all?
      if INSKMaths.CGPointNearToPoint(point1: velocity, point2: CGPoint.zero) {
        return
      }

      // Calculate and apply animation
      // v(t) = a * t + v0; s(t) = (a/2) * t*t + v0 * t + s0
      let velocityLength:CGFloat = INSKMaths.CGPointLength(point: velocity)
      let time:CGFloat = velocityLength / self.deceleration
      let velocityNormalized:CGPoint = INSKMaths.CGPointMultiplyScalar(point: velocity, value: 1.0 / velocityLength)

      let startPosition:CGPoint = self.scrollContentPosition

      let move:SKAction! = SKAction.customAction(withDuration: TimeInterval(time), actionBlock:{ (node:SKNode!,elapsedTime:CGFloat) in
        let distance:CGFloat = -self.deceleration * elapsedTime * elapsedTime / 2 + velocityLength * elapsedTime
        let translation:CGPoint = CGPoint(x: distance * velocityNormalized.x, y: distance * velocityNormalized.y)
        var currentPosition:CGPoint = INSKMaths.CGPointAdd(point1: startPosition, point2: translation)
        currentPosition = self.positionWithScrollLimitsApplyed(position: currentPosition)
        if node.parent != self {
          currentPosition = self.convert(currentPosition, to:node.parent!)
        }
        node.position = currentPosition
      })
      let callback:SKAction! = SKAction.run({
        self.didFinishScrollingAtPosition(offset: self.scrollContentPosition)
      })
      self.scrollContentNode.run(SKAction.sequence([move, callback]), withKey: ScrollContentMoveActionName)

      return
    }

    // Calculate translation for page snapping
    var translation:CGPoint = CGPoint.zero

    if self.pageSize.width > 0 {
      let translationX:CGFloat = self.scrollContentPosition.x.truncatingRemainder(dividingBy: self.pageSize.width)
      var snappingOccured:Bool = false
      if self.decelerationMode == INSKScrollNodeDecelerationMode.PagingDirection {
        if velocity.x < 0 {
          translation.x = -self.pageSize.width - translationX
          snappingOccured = true
        } else if velocity.x > 0 {
          translation.x = -translationX
          snappingOccured = true
        } else {
          // Use INSKScrollNodeDecelerationModePagingHalfPage behavior
        }
      }
      if !snappingOccured {
        if fabs(translationX) >= self.pageSize.width / 2 {
          translation.x = -self.pageSize.width - translationX
        } else {
          translation.x = -translationX
        }
      }
    }

    if self.pageSize.height > 0 {
      let translationY:CGFloat = self.scrollContentPosition.y.truncatingRemainder(dividingBy: self.pageSize.height)
      var snappingOccured:Bool = false
      if self.decelerationMode == INSKScrollNodeDecelerationMode.PagingDirection {
        if velocity.y > 0 {
          translation.y = self.pageSize.height - translationY
          snappingOccured = true
        } else if velocity.y < 0 {
          translation.y = -translationY
          snappingOccured = true
        } else {
          // Use INSKScrollNodeDecelerationModePagingHalfPage behavior
        }
      }
      if !snappingOccured {
        if translationY >= self.pageSize.height / 2 {
          translation.y = self.pageSize.height - translationY
        } else {
          translation.y = -translationY
        }
      }
    }

    // Apply scroll bounds for destination position
    var destinationPosition:CGPoint = INSKMaths.CGPointAdd(point1: self.scrollContentPosition, point2: translation)
    destinationPosition = self.positionWithScrollLimitsApplyed(position: destinationPosition)

    // Apply snap animation
    if !INSKMaths.CGPointNearToPoint(point1: destinationPosition, point2: self.scrollContentPosition) {
      let move:SKAction! = SKAction.move(to: destinationPosition, duration:TimeInterval(ScrollContentMoveActionDuration))
      move.timingMode = SKActionTimingMode.easeOut
      let callback:SKAction! = SKAction.run({
        self.didFinishScrollingAtPosition(offset: destinationPosition)
      })
      self.scrollContentNode.run(SKAction.sequence([move, callback]), withKey: ScrollContentMoveActionName)
    }
  }

  func addVelocityToAverage(velocity:CGPoint) {
    if self.lastVelocities.count == MaxNumberOfVelocities {
      self.lastVelocities.removeObject(at: 0)
    }
    let value:NSValue! = NSValue(cgPoint:velocity)
    self.lastVelocities.add(value)
  }

  func getAveragedVelocity() -> CGPoint {
    var velocity:CGPoint = CGPoint.zero
    for point in self.lastVelocities as! [CGPoint] {
      velocity = INSKMaths.CGPointAdd(point1: velocity, point2: point)
    }
    if self.lastVelocities.count > 0 {
      velocity = INSKMaths.CGPointDivideScalar(point: velocity, value: CGFloat(self.lastVelocities.count))
    }
    return velocity
  }


  //  #if TARGET_OS_IPHONE
  // MARK: - touch events

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    print("insk started touch")
    if !self.scrollingEnabled {return}

    if event!.allTouches!.count == touches.count {
      self.stopScrollAnimations()

      let touch = touches.first!
      self.lastTouchTimestamp = touch.timestamp
      self.lastVelocities.removeAllObjects()
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event:UIEvent?) {
    print("touch moved")
    if !self.scrollingEnabled {return}

    // Find touch location
    let touch = touches.first!
    let location:CGPoint = touch.location(in: self.scene!)

    // Ignore touches outside of scroll node if clipping is on
    if self.clipContent {
      let locationInBounds:CGPoint = self.scene!.convert(location, to:self)
      let frame:CGRect = CGRect(x: 0, y: 0, width: self.scrollNodeSize.width, height: -self.scrollNodeSize.height)
      if !frame.contains(locationInBounds) {
        return
      }
    }

    // Calculate and apply translation
    let lastLocation:CGPoint = touch.previousLocation(in: self.scene!)
    let translation:CGPoint = INSKMaths.CGPointSubtract(point1: location, point2: lastLocation)
    let oldPosition:CGPoint = self.scrollContentNode.position
//    This line change made it work
    self.scrollContentPosition = INSKMaths.CGPointAdd(point1: self.scrollContentNode.position, point2: translation)
//    self.scrollContentNode.position = INSKMaths.CGPointAdd(point1: self.scrollContentNode.position, point2: translation)
    print(self.scrollContentNode.position)
    // Calculate velocity
    let timeDifferecne:TimeInterval = touch.timestamp - self.lastTouchTimestamp
    self.lastTouchTimestamp = touch.timestamp
    let scrollVelocity:CGPoint = INSKMaths.CGPointDivideScalar(point: translation, value: CGFloat(timeDifferecne))
    self.addVelocityToAverage(velocity: scrollVelocity)

    self.applyScrollLimits()

    // Inform subclasses and delegate
    self.didScrollFromOffset(fromOffset: oldPosition, toOffset:self.scrollContentPosition, velocity:self.getAveragedVelocity())
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event:UIEvent?) {
    if !self.scrollingEnabled {return}

    if event!.allTouches!.count == touches.count {
      self.applyScrollOutWithVelocity(velocity: self.getAveragedVelocity())
    }
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event:UIEvent?) {
    if !self.scrollingEnabled {return}

    self.applyScrollOutWithVelocity(velocity: self.getAveragedVelocity())
  }

//  #else // OSX
//  // MARK: - mouse events
//
//  func mouseDown(theEvent:NSEvent!) {
//    self.processMouseDown(theEvent)
//  }
//
//  func rightMouseDown(theEvent:NSEvent!) {
//    self.processMouseDown(theEvent)
//  }
//
//  func otherMouseDown(theEvent:NSEvent!) {
//    self.processMouseDown(theEvent)
//  }
//
//  func processMouseDown(theEvent:NSEvent!) {
//    // Track total number of mouse buttons
//    self.numberOfMouseButtonsPressed++
//
//    if !self.scrollingEnabled {return}
//
//    // Start dragging only for the first pressed button
//    if self.numberOfMouseButtonsPressed == 1 {
//      self.stopScrollAnimations()
//
//      self.lastTouchTimestamp = theEvent.timestamp
//      self.positionOfLastMouseEvent = theEvent.locationInNode(self)
//      self.lastVelocities.removeAllObjects()
//    }
//  }
//
//  func mouseDragged(theEvent:NSEvent!) {
//    self.processMouseDragged(theEvent)
//  }
//
//  func rightMouseDragged(theEvent:NSEvent!) {
//    self.processMouseDragged(theEvent)
//  }
//
//  func otherMouseDragged(theEvent:NSEvent!) {
//    self.processMouseDragged(theEvent)
//  }
//
//  func processMouseDragged(theEvent:NSEvent!) {
//    if !self.scrollingEnabled {return}
//
//    // Ignore touches outside of scroll node if clipping is on
//    let location:CGPoint = theEvent.locationInNode(self)
//    if self.clipContent {
//      let frame:CGRect = CGRectMake(0, 0, self.scrollNodeSize.width, -self.scrollNodeSize.height)
//      if !CGRectContainsPoint(frame, location) {
//        return
//      }
//    }
//
//    // Calculate and apply translation
//    let lastLocation:CGPoint = self.positionOfLastMouseEvent
//    let translation:CGPoint = CGPointSubtract(location, lastLocation)
//    let oldPosition:CGPoint = self.scrollContentNode.position
//    self.scrollContentNode.position = CGPointAdd(self.scrollContentNode.position, translation)
//
//    // Calculate velocity
//    let timeDifferecne:NSTimeInterval = theEvent.timestamp - self.lastTouchTimestamp
//    let scrollVelocity:CGPoint = CGPointDivideScalar(translation, timeDifferecne)
//    self.addVelocityToAverage(scrollVelocity)
//
//    self.lastTouchTimestamp = theEvent.timestamp
//    self.positionOfLastMouseEvent = location
//
//    self.applyScrollLimits()
//
//    // Inform subclasses and delegate
//    self.didScrollFromOffset(oldPosition, toOffset:self.scrollContentPosition, velocity:self.getAveragedVelocity())
//  }
//
//  func mouseUp(theEvent:NSEvent!) {
//    self.processMouseUp(theEvent)
//  }
//
//  func rightMouseUp(theEvent:NSEvent!) {
//    self.processMouseUp(theEvent)
//  }
//
//  func otherMouseUp(theEvent:NSEvent!) {
//    self.processMouseUp(theEvent)
//  }
//
//  func processMouseUp(theEvent:NSEvent!) {
//    // Track total number of mouse buttons
//    self.numberOfMouseButtonsPressed--
//
//    if !self.scrollingEnabled {return}
//
//    // Apply deceleration only when the last button has been lifted
//    if self.numberOfMouseButtonsPressed == 0 {
//      self.applyScrollOutWithVelocity(velocity: self.getAveragedVelocity())
//    }
//  }
//
//  #endif


  // MARK: - methods to override

  func didScrollFromOffset(fromOffset:CGPoint, toOffset:CGPoint, velocity:CGPoint) {
    print("delegate?")
//    self.scrollDelegate.scrollNode(self, didScrollFromOffset:fromOffset, toOffset:toOffset, velocity:velocity)
  }

  func didFinishScrollingAtPosition(offset:CGPoint) {
//    self.scrollDelegate.scrollNode(self, didFinishScrollingAtPosition:offset)
  }
}
