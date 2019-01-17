//
//  GameToolbar.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 06/02/2016.
//  Copyright © 2016 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class GameToolbar: ToolbarProtocol, INSKScrollNodeDelegate {

  func scrollNode(_ scrollNode: INSKScrollNode?, didScrollFromOffset fromOffset: CGPoint, toOffset: CGPoint, velocity: CGPoint) {
    print("scroll node scrolling?")
  }

  func scrollNode(_ scrollNode: INSKScrollNode?, didFinishScrollingAtPosition offset: CGPoint) {
    print("END scroll node scrolling?")
  }

  var location: Game.rotation?

  static let defaultNodeSize = CGSize(width: 64, height: 64)

  var menuNode: INSKScrollNode
  var contentNode: SKSpriteNode

//  fileprivate var options = [GameToolbarOption]()
  var menuItems: [Menu.menuItem] = []

  init(size: CGSize) {

    location = .south

    self.menuNode = Menu.makeMenuNode(size)

    self.contentNode = SKSpriteNode(color: UIColor.blue, size: size)
    self.contentNode.name = "content node"
    self.contentNode.anchorPoint = CGPoint(x: 0, y: 1)
//    let size = CGSize(width: Game.sharedInstance.mainView!.bounds.width, height: Game.sharedInstance.mainView!.bounds.height)

    self.createMenuItems()
    Menu.layoutItems(menu: self, layoutOptions: Menu.menuLayoutOptions(layout: .xSlide))
    self.contentNode.removeFromParent()
    self.menuNode.scrollContentNode.addChild(self.contentNode)
    self.menuNode.scrollContentSize = CGSize(width: self.contentNode.size.width + 50, height: self.contentNode.size.height)
//    self.menuNode.scrollDelegate = self
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func createMenuItems() {

    let buildRoomButton = Button(texture: SKTexture(imageNamed: "Graphics/build_room"), touch_f: GameToolbar.buildRoomTouch)
    let buildRoomMenuItem = Menu.menuItem(button: buildRoomButton)

    let buildItemButton = Button(texture: SKTexture(imageNamed: "Graphics/build_item"), touch_f: GameToolbar.buildItemTouch)
    let buildItemMenuItem = Menu.menuItem(button: buildItemButton)

    let buildDoorButton = Button(texture: SKTexture(imageNamed: "Graphics/door"), touch_f: GameToolbar.buildDoorTouch)
    let buildDoorMenuItem = Menu.menuItem(button: buildDoorButton)

    let setRoomTypeButton = Button(texture: SKTexture(imageNamed: "Graphics/build_room"), touch_f: GameToolbar.setRoomTypeTouch)
    let setRoomMenuItem = Menu.menuItem(button: setRoomTypeButton)

    let debugButton = Button(texture: SKTexture(imageNamed: "Graphics/debug"), touch_f: GameToolbar.debugTouch)
    let debugMenuItem = Menu.menuItem(button: debugButton)

    // Cool. Cool cool cool.
    self.menuItems.append(contentsOf: [buildRoomMenuItem, buildItemMenuItem, buildDoorMenuItem, debugMenuItem, setRoomMenuItem])

  }

  static func buildRoomTouch(_: Button) {
    Game.sharedInstance.gameStateMachine.enter(GSBuildRoom.self)
    Game.sharedInstance.buildRoomStateMachine.enter(BRSPrePlan.self)
    print("gamestate is...")
    print(Game.sharedInstance.gameStateMachine.currentState!)
//    Game.sharedInstance.buildStateMachine.enterState(BRSPlan)

  }

  static func buildItemTouch(_: Button) {

//    let menu = Menu()
    let itemMenu = ItemMenu()

    if (Game.sharedInstance.menuManager?.openMenu == nil) {
      Game.sharedInstance.menuManager?.show(itemMenu)
    } else {
      Game.sharedInstance.menuManager?.openMenu!.remove()
    }


//    if ( Game.sharedInstance.buildItemStateMachine.currentState is BISPlace ) {
    ////      Game.sharedInstance.gameStateMachine.enterState(GSGeneral)
    ////      Game.sharedInstance.buildStateMachine
//    } else {
//      Game.sharedInstance.gameStateMachine.enter(GSBuildItem.self)
//      Game.sharedInstance.buildItemStateMachine.enter(BISPlan.self)
//      Game.sharedInstance.placingObjectsQueue.append(ReceptionDesk.self)
//
//    }
  }

  static func buildDoorTouch(_: Button) {
    Game.sharedInstance.gameStateMachine.enter(GSBuildDoor.self)
  }


  static func debugTouch(_: Button) {
    print("debug toolbar tap")
    let debugToolbar = (Game.sharedInstance.toolbarManager?.getDebugToolbar())!
    debugToolbar.isHidden() ? Game.sharedInstance.toolbarManager?.show(debugToolbar) : Game.sharedInstance.toolbarManager?.hide(debugToolbar)
  }


  static func setRoomTypeTouch(_: Button) {

    let roomTypeMenu = RoomTypeMenu()

    if (Game.sharedInstance.menuManager?.openMenu == nil) {
      Game.sharedInstance.menuManager?.show(roomTypeMenu)
    } else {
      Game.sharedInstance.menuManager?.openMenu?.remove()
    }
  }

}
