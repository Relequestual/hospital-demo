// #import "HLScrollNode.h"
//  BaseScene.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 17/11/2015.
//  Copyright © 2015 Ben Hutton. All rights reserved.
//

import Foundation

import SpriteKit

/**
 A base class for all of the scenes in the app.
 */
class BaseScene: HLScene {

    /**
     The native size for this scene. This is the height at which the scene
     would be rendered if it did not need to be scaled to fit a window or device.
     Defaults to `zeroSize`; the actual value to use is set in `createCamera()`.
     */
    var nativeSize = CGSize.zero
    
    
    var staticObjects = SKSpriteNode()
    
    
    
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
        
        createTiles()
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
      
        let myContentNode = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width:2000, height:2000))
        let red1Node = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width:1000, height: 1000))
        red1Node.position = CGPoint(x: -500.0, y: 500.0)
        let red2Node = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width:1000, height: 1000))
        red2Node.position = CGPoint(x: 500.0, y: -500.0)
        let greenNode = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width:100, height: 100))
        myContentNode.addChild(red1Node)
        myContentNode.addChild(red2Node)
        myContentNode.addChild(greenNode)

        let myScrollNode: HLScrollNode = HLScrollNode(size: view.bounds.size, contentSize: myContentNode.size)
        myScrollNode.contentScaleMinimum = 0.0
        myScrollNode.contentNode = myContentNode
        self.addChild(myScrollNode)

        myScrollNode.hlSetGestureTarget(myScrollNode)
        self.registerDescendant(myScrollNode, withOptions:NSSet(objects: HLSceneChildResizeWithScene, HLSceneChildGestureTarget) as Set<NSObject>)
      
        print(myContentNode.position)
      
//        scrollable.addChild(staticObjects)
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
        
        
        let tileTexture = SKTexture(imageNamed: "Grey Tile.png")
        
        let initSize: [Int] = [10, 10]
        
        for var x: Int = 0; x < initSize[0]; x++ {
            
            print(x)
            
            var y = 0
            
            var tile = SKSpriteNode(texture: tileTexture)
            
//            tile
            
//            tile.position = CGPoint(x: Int(tileTexture.size().width) + Int(tileTexture.size().width) * x, y: Int(tileTexture.size().height) * y)

            tile.position = CGPoint(x: Int(tileTexture.size().width) * x, y: Int(tileTexture.size().height) * y)
            
            staticObjects.addChild(tile)
            
        }
        
        
    }
    

}