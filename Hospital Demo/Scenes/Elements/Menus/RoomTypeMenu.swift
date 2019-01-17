//
//  RoomTypeMenu.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 06/12/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

class RoomTypeMenu: MenuProtocol {

  var menuNode: INSKScrollNode = Menu.makeMenuNode(CGSize(width: Game.sharedInstance.mainView!.bounds.width, height: Game.sharedInstance.mainView!.bounds.height))
  var contentNode: SKSpriteNode = SKSpriteNode()

  var menuItems: [Menu.menuItem] = []

  init(menuItems roomTypeItems: [RoomDefinitions.BaseRoomTypes] = [.GPOffice, .Pharmacy]) {

    self.menuNode.decelerationMode = .Decelerate

    contentNode.name = "content node"
    let size = CGSize(width: Game.sharedInstance.mainView!.bounds.width, height: Game.sharedInstance.mainView!.bounds.height)

    self.menuNode.position = CGPoint(x: 0 - size.width / 2 , y: 0 + size.height / 2)

    self.contentNode.size = size
    self.contentNode.anchorPoint = CGPoint(x: 0, y: 1)
    self.contentNode.position = CGPoint(x:0,y:0)
    self.menuNode.scrollContentNode.addChild(self.contentNode)
    self.menuNode.scrollContentSize = size

    self.menuItems = self.createMenuItems(roomTypeItems)
    Menu.layoutItems(menu: self, layoutOptions: Menu.menuLayoutOptions(layout: Menu.Layout.grid, buttonSize: CGSize(width: 100, height: 80)))

    // Create custom crop node
    let cropMask = SKSpriteNode(color: UIColor.red, size: menuNode.scrollBackgroundNode.size)

    let cropNode = SKCropNode()
    cropNode.maskNode = cropMask
    cropNode.position = CGPoint(x: 0 + size.width / 2, y: 0 - size.height / 4)

    self.menuNode.contentCropNode = cropNode
    self.menuNode.clipContent = true
  }

  func createMenuItems(_ menuItems: [RoomDefinitions.BaseRoomTypes]) -> [Menu.menuItem] {
    var newMenuItems: [Menu.menuItem] = []

    menuItems.forEach { roomType in

      let roomTypeDefinition = RoomDefinitions.rooms[roomType]

      let floorNode = RoomUtil.createFloorNode(colour: roomTypeDefinition!.floorColor)

      let button = Button(texture: floorNode.texture!, touch_f: { (Button) in
        Game.sharedInstance.gameStateMachine.enter(GSBuildItem.self)
        Game.sharedInstance.buildItemStateMachine.enter(BISPlan.self)

        RoomTypeMenu.selectRoomType(roomType)

        Game.sharedInstance.menuManager?.openMenu!.remove()
      })
      let item = Menu.menuItem(button: button)
      newMenuItems.append(item)
    }
    return newMenuItems
  }

  static func selectRoomType(_ roomType: RoomDefinitions.BaseRoomTypes) {

    let rooms = Game.sharedInstance.roomManager!.allRooms

    for room in rooms {

      room.component(ofType: RoomSpecComponent.self)!.changeFloorColour(color: SKColor.blue, alpha: 0.3)

      room.addComponent(TouchableSpriteComponent(f: {
        print("---------touchable sprite room sprite")
        Game.sharedInstance.roomManager?.proposedTypedRoom = room

        let roomColour = (RoomDefinitions.rooms[roomType]?.floorColor)!

        room.component(ofType: RoomSpecComponent.self)!.changeFloorColour(color: roomColour, alpha: 0.3)

        let confirmToolbar = ConfirmToolbar()
        confirmToolbar.confirm = {
          room.component(ofType: RoomSpecComponent.self)?.roomType = roomType
          Game.sharedInstance.roomManager?.clearProposedRoomTypes()
          Game.sharedInstance.gameStateMachine.enter(GSGeneral.self)
        }
        confirmToolbar.cancel = {
          Game.sharedInstance.roomManager?.clearProposedRoomTypes()
          Game.sharedInstance.gameStateMachine.enter(GSGeneral.self)
        }

        Game.sharedInstance.toolbarManager?.add(toolbar: confirmToolbar, location: .south, shown: true)

      }))
    }
  }

}

