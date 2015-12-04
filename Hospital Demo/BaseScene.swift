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
class BaseScene: SKScene, UIGestureRecognizerDelegate {

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
        
//        let myScrollNode: HLScrollNode = HLScrollNode(size: CGSize(width: 100.0, height: 100.0), contentSize: CGSize(width: 200.0, height: 200.0))
        
        let myScrollNode: HLScrollNode = HLScrollNode(size: view.bounds.size, contentSize: view.bounds.size)

        
//        let myContentNode = SKShapeNode(rectOfSize: CGSize(width: 400, height: 200))

        let myContentNode = SKShapeNode(rectOfSize: view.bounds.size)
        
        
        let position = CGPoint(x: 100, y: 210)
        
        myContentNode.position = position
        
        print(myContentNode.position)
        
//        myScrollNode.contentNode = myContentNode
        
//        scrollable.addChild(staticObjects)
        self.addChild(myContentNode)

        
        
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