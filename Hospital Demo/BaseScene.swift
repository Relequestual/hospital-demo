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

        for (var i = 0; i<500; i += 10) {
            let greenNode = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width:20, height: 20))
            greenNode.position = CGPoint(x: i, y: i)
            myContentNode.addChild(greenNode)
        }
        
        myContentNode.addChild(staticObjects)
        print("size is")
        print(view.bounds.size)
        print(myContentNode.size)

        let myScrollNode: HLScrollNode = HLScrollNode(size: view.bounds.size, contentSize: myContentNode.size)
        myScrollNode.anchorPoint = bottomleft
        myScrollNode.contentAnchorPoint = bottomleft
        myScrollNode.contentScaleMinimum = 0.0
        myScrollNode.contentNode = myContentNode
        self.addChild(myScrollNode)

        myScrollNode.hlSetGestureTarget(myScrollNode)
        self.registerDescendant(myScrollNode, withOptions:NSSet(objects: HLSceneChildResizeWithScene, HLSceneChildGestureTarget) as Set<NSObject>)
      
        print(myContentNode.position)
      
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
            
            var tile = SKSpriteNode(texture: tileTexture)
            print(x)
            
            var y = 0
            
//            tile
            
//            tile.position = CGPoint(x: Int(tileTexture.size().width) + Int(tileTexture.size().width) * x, y: Int(tileTexture.size().height) * y)

            tile.position = CGPoint(x: Int(tileTexture.size().width) * x, y: Int(tileTexture.size().height) * y)
            
            staticObjects.addChild(tile)
            
        }
        
        
    }
    

}