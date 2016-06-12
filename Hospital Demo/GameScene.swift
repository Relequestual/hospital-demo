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
  
  var didMove = false
  
  override func didMoveToView(skView: SKView) {
    for (rowIndex, row) in makeTileRows(10, columnsPerRow: 10).enumerate() {
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
    let maxXSpeed: CGFloat = 0.04
    let maxYSpeed: CGFloat = 0.06
    
    let deltaX = (currentTouchPosition.x - touchStartPosition.x) * maxXSpeed
    let deltaY = (currentTouchPosition.y - touchStartPosition.y) * maxYSpeed
    
    let currentPosition = scrollNode.position
    
    var position = CGPoint(x: currentPosition.x + deltaX, y: currentPosition.y + deltaY)
    
    if position.x > maxX { position.x = maxX }
    if position.x < minX { position.x = minX }
    
    if position.y > maxY { position.y = maxY }
    if position.y < minY { position.y = minY }
    
    return position
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
    
    didMove = true
    
    guard let touch = touches.first else { return }
    let currentTouchPosition = touch.locationInNode(self)
    let scrollNodePosition = newPosition(currentTouchPosition)
    scrollNode.position = scrollNodePosition
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesEnded(touches, withEvent: event)
    //print("[GameScene] touchesEnded")
    
    // Only do tap things if we didn't scroll the view
    if !didMove {
      if let touch = touches.first {
        let point = touch.locationInNode(self)
        let node = scrollNode.nodeAtPoint(point)
        node.alpha = node.alpha == 1.0 ? 0.2 : 1.0
      }
    }
    
    didMove = false
  }
}
