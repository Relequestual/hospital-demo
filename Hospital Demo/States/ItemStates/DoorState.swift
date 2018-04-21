//
//  DoorState.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 04/04/2017.
//  Copyright © 2017 Ben Hutton. All rights reserved.
//

import Foundation
import GameplayKit

class DoorState: GKStateMachine {
  convenience init() {
    self.init(state: [
      DoorSClosed(),
      DoorSOpen(),
      DoorSOpening(),
      DoorSClosing(),
    ])
  }

  init(state: [DoorStates]) {
    super.init(states: state)

    enter(DoorSClosed.self)
  }

  func nextState() {
    switch currentState {
    case is DoorSClosed:
      enter(DoorSOpening.self)
    case is DoorSOpening:
      enter(DoorSOpen.self)
    case is DoorSOpen:
      enter(DoorSClosing.self)
    case is DoorSClosing:
      enter(DoorSClosed.self)
    default:
      enter(DoorSClosed.self)
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
      stateMachine?.enter(DoorSOpen.self)
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
      stateMachine?.enter(DoorSClosed.self)
    }
  }
}
