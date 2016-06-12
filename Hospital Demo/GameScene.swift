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
    for (rowIndex, row) in makeTileRows(10, columnsPerRow: 10).enumerate() {
      for (nodeIndex, node) in row.enumerate() {
        let xOffset = (node.frame.width / 2) + (node.frame.width * CGFloat(nodeIndex))
        let yOffset = node.frame.height / 2 + (node.frame.height * CGFloat(rowIndex))
        node.position = CGPoint(x: xOffset, y: yOffset)
        scrollNode.addChild(node)
      }
    }
    self.addChild(scrollNode)
    
    let frame = scrollNode.calculateAccumulatedFrame()
    
    minX = -frame.size.width + skView.frame.width
    minY = -frame.size.height + skView.frame.height
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
    let speedAdjustment: CGFloat = 20
    
    let deltaX = (currentTouchPosition.x - touchStartPosition.x) / speedAdjustment
    let deltaY = (currentTouchPosition.y - touchStartPosition.y) / speedAdjustment
    
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
    
    guard let touch = touches.first else { return }
    let currentTouchPosition = touch.locationInNode(self)
    let scrollNodePosition = newPosition(currentTouchPosition)
    scrollNode.position = scrollNodePosition
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesEnded(touches, withEvent: event)
    //print("[GameScene] touchesEnded")
  }
}
