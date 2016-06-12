//
//  GameScene.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 13/11/2015.
//  Copyright (c) 2015 Ben Hutton. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  static let tileImageName = "Graphics/Tile"
  
  private var touchStartPosition = CGPoint()
  
  let scrollNode = SKNode()
  
  // how far up and to the right we can scroll
  var maxX: CGFloat = 0
  var maxY: CGFloat = 0
  // how far to down and to the left we can scroll
  var minX: CGFloat = 0
  var minY: CGFloat = 0
  
  override func didMoveToView(skView: SKView) {
    
    let tapResponder = UITapGestureRecognizer(target: self, action: Selector("singleTap:"))
    tapResponder.numberOfTapsRequired = 1
    view?.addGestureRecognizer(tapResponder)
    
    let doubleTapResponder = UITapGestureRecognizer(target: self, action: Selector("doubleTap:"))
    doubleTapResponder.numberOfTapsRequired = 2
    view?.addGestureRecognizer(doubleTapResponder)
    
    // only respond to a single tap if we don't get a double tap
    tapResponder.requireGestureRecognizerToFail(doubleTapResponder)
    
    for (rowIndex, row) in makeTileRows(100, columnsPerRow: 100).enumerate() {
      for (nodeIndex, node) in row.enumerate() {
        let xOffset = (node.frame.width / 2) + (node.frame.width * CGFloat(nodeIndex))
        let yOffset = node.frame.height / 2 + (node.frame.height * CGFloat(rowIndex))
        node.position = CGPoint(x: xOffset, y: yOffset)
        scrollNode.addChild(node)
      }
    }
    self.addChild(scrollNode)
    setMaxXAndY()
  }
  
  override func didChangeSize(oldSize: CGSize) {
    super.didChangeSize(oldSize)
    setMaxXAndY()

    if scrollNode.position.x > maxX { scrollNode.position.x = maxX }
    if scrollNode.position.x < minX { scrollNode.position.x = minX }

    if scrollNode.position.y > maxY { scrollNode.position.y = maxY }
    if scrollNode.position.y < minY { scrollNode.position.y = minY }
  }
  
  private func setMaxXAndY() {
    let frame = scrollNode.calculateAccumulatedFrame()
    minX = -frame.size.width + self.size.width
    minY = -frame.size.height + self.size.height
  }
  
  private func makeTileRows(numberOfRows: Int, columnsPerRow: Int) -> [[SKSpriteNode]] {
    var rows = [[SKSpriteNode]]()
    for _ in 0..<numberOfRows {
      let row = makeTileRow(columnsPerRow)
      rows.append(row)
    }
    return rows
  }
  
  private func makeTileRow(numberOfColumns: Int) -> [SKSpriteNode] {
    var nodes = [SKSpriteNode]()
    for _ in 0..<numberOfColumns {
      let node = SKSpriteNode(imageNamed: GameScene.tileImageName)
      nodes.append(node)
    }
    return nodes
  }
  
  private func newPosition(currentTouchPosition: CGPoint) -> CGPoint {
    
    let deltaX = currentTouchPosition.x - touchStartPosition.x
    let deltaY =  currentTouchPosition.y - touchStartPosition.y
    
    var newPosition = CGPoint(x: scrollNode.position.x + deltaX, y: scrollNode.position.y + deltaY)
    
    if newPosition.x > maxX { newPosition.x = maxX }
    if newPosition.x < minX { newPosition.x = minX }
    
    if newPosition.y > maxY { newPosition.y = maxY }
    if newPosition.y < minY { newPosition.y = minY }
    
    return newPosition
  }
  
  func singleTap(gestureRecognizer: UIGestureRecognizer) {
    let location  = gestureRecognizer.locationOfTouch(0, inView: view)
    let height = self.frame.height
    let p = CGPoint(x: location.x / scrollNode.xScale, y: (height - location.y) / scrollNode.yScale)
    
    let offsetX = -scrollNode.position.x / scrollNode.xScale
    let offsetY = -scrollNode.position.y / scrollNode.yScale
    
    let node = scrollNode.nodeAtPoint(CGPoint(x: p.x + offsetX, y: p.y + offsetY))
    
    node.alpha = node.alpha == 1.0 ? 0.5 : 1.0
  }
  
  func doubleTap(gestureRecognizer: UIGestureRecognizer) {
//    let location  = gestureRecognizer.locationOfTouch(0, inView: view)
//    let height = self.frame.height
//    let p = CGPoint(x: location.x, y: height - location.y)
//    let node = scrollNode.nodeAtPoint(p)
//    node.alpha = node.alpha != 0.2 ? 0.2 : 1.0
    
    scrollNode.xScale == 1.0 ? scrollNode.setScale(0.5) : scrollNode.setScale(1.0)
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesBegan(touches, withEvent: event)
    guard let touch = touches.first else { return }
    //print("[GameScene] touchesBegan")
    touchStartPosition = touch.locationInNode(self)
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesMoved(touches, withEvent: event)
    //print("[GameScene] touchesMoved")

    guard let touch = touches.first else { return }
    let currentTouchPosition = touch.locationInNode(self)
    let newScrollNodePosition = newPosition(currentTouchPosition)
    scrollNode.position = newScrollNodePosition
    touchStartPosition = currentTouchPosition
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesEnded(touches, withEvent: event)
    //print("[GameScene] touchesEnded")
  }
}
