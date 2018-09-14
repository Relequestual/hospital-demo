//
//  SKNode+INSKExtension.swift
//  Hospital Demo
//
//  Created by Ben Hutton on 10/09/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//
//  A Swift port of...

// SKNode+INExtension.m
//
// Copyright (c) 2014 Sven Korset
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SpriteKit

extension SKNode {

  func changeParent(_ parent: SKNode) {
    if (self.parent == nil) {
      parent.addChild(self)
    } else if (self.parent == parent) {
      // Already child of the parent, so do nothing
    } else if (self.scene == nil || parent.scene == nil || self.scene != parent.scene) {
      // No scene to translate over, just add to the new parent
      self.removeFromParent()
      parent.addChild(self)
    } else {
      // Convert the position over the scene to keep a global location
      var convertedPosition = self.parent!.convert(self.position, to: self.scene!)
      convertedPosition = self.scene!.convert(convertedPosition, to: parent)

      self.removeFromParent()
      parent.addChild(self)

      self.position = convertedPosition;
    }
  }






}
