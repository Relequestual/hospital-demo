//
//  DoorState.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 04/04/2017.
//  Copyright © 2017 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

class DoorState : GKStateMachine{
  
  convenience init() {
    self.init(state: [
      DoorSClosed(),
      DoorSOpen(),
      DoorSOpening(),
      DoorSClosing()
    ])
  }
  
  init(state: [DoorStates]) {
    super.init(states: state)
    
    self.enter(DoorSClosed.self)
  }
  
  func nextState() {
    switch self.currentState {
    case is DoorSClosed:
      self.enter(DoorSOpening.self)
    case is DoorSOpening:
      self.enter(DoorSOpen.self)
    case is DoorSOpen:
      self.enter(DoorSClosing.self)
    case is DoorSClosing:
      self.enter(DoorSClosed.self)
    default:
      self.enter(DoorSClosed.self)
    }
  }

}

class DoorStates: GKState {}

class DoorSClosed: DoorStates {
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass == DoorSOpening.self
  }
}

class DoorSOpen: DoorStates {
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass == DoorSClosing.self
  }
}

class DoorSOpening: DoorStates {
  
  var time = TimeInterval(0)
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass == DoorSOpen.self
  }
  
  override func update(deltaTime seconds: TimeInterval) {
    time += seconds
    
    if time >= 4 {
      self.stateMachine?.enter(DoorSOpen.self)
    }
  }
}

class DoorSClosing: DoorStates {
  
  var time = TimeInterval(0)
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass == DoorSClosed.self
  }
  
  override func update(deltaTime seconds: TimeInterval) {
    time += seconds
    
    if time >= 4 {
      self.stateMachine?.enter(DoorSClosed.self)
    }
  }
  
}
