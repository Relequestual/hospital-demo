//
//  INSKMaths.swift
//  Hospital Demo
//
// A ported and slimmed down version of INSKMath
//
//  Created by Ben Hutton on 08/09/2018.
//  Copyright © 2018 Ben Hutton. All rights reserved.
//

import Foundation
import SpriteKit
//import GLKit

//Convenience creators

// INSKMath.h
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


//#import <GLKit/GLKMath.h>


// ------------------------------------------------------------
// MARK: - definitions
// ------------------------------------------------------------
/// @name definitions

///**
// Epsilon architecture independent.
// */
//#if CGFLOAT_IS_DOUBLE
//// define INSK_EPSILON DBL_EPSILON
//#else
//// define INSK_EPSILON FLT_EPSILON
//#endif

///**
// M_PI/180
// */
let M_PI_180:CGFloat = CGFloat.pi / 180
///**
// 180/M_PI
// */
let M_180_PI:CGFloat = 180 / CGFloat.pi
//
///**
// M_PI*2
// */
let M_PI_X_2:CGFloat = CGFloat.pi * 2


//// #if __cplusplus
//
//#endif


class INSKMaths {

//  Convenience creaters

  static func CGPointMake(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: y)
  }

  static func CGPointMake(_ x: Float, _ y: Float) -> CGPoint {
    return CGPoint(x: CGFloat(x), y: CGFloat(y))
  }

  static func CGSizeMake(_ width: CGFloat, _ height: CGFloat) -> CGSize {
    return CGSize(width: width, height: height)
  }

  static func CGVectorMake(_ dx: CGFloat, _ dy: CGFloat) -> CGVector {
    return CGVector(dx: dx, dy: dy)
  }



// ------------------------------------------------------------
// MARK: - CGPoint convertions
// ------------------------------------------------------------
/// @name CGPoint convertions

/**
 Converts a CGSize directly into a CGPoint.

 @param size The size.
 @return A CGPoint.
 */
static func CGPointFromSize(size:CGSize) -> CGPoint {
  return CGPointMake(size.width, size.height)
}

/**
 Converts a CGPoint directly into a CGSize.

 @param point The point.
 @return A CGSize.
 */
static func CGSizeFromPoint(point:CGPoint) -> CGSize {
  return CGSizeMake(point.x, point.y)
}

/**
 Converts a CGVector into a CGPoint.

 @param vector A CGVector.
 @return A CGPoint.
 */
static func CGPointFromCGVector(vector:CGVector) -> CGPoint {
  return CGPointMake(vector.dx, vector.dy)
}

/**
 Converts a CGPoint into a CGVector.

 @param point A CGPoint.
 @return A CGVector.
 */
static func CGVectorFromCGPoint(point:CGPoint) -> CGVector {
  return CGVectorMake(point.x, point.y)
}

/**
 Converts a GLKVector2 into a CGPoint.

 @param vector A GLKVector2.
 @return A CGPoint.
 */
static func CGPointFromGLKVector2(vector:GLKVector2) -> CGPoint {
  return CGPointMake(vector.x, vector.y)
}

/**
 Converts a CGPoint into a GLKVector2 so it can be used with the GLKMath static functions from GL Kit.

 @param point A CGPoint.
 @return A GLKVector2.
 */
static func GLKVector2FromCGPoint(point:CGPoint) -> GLKVector2 {
  return GLKVector2Make(Float(point.x), Float(point.y))
}


// ------------------------------------------------------------
// MARK: - scalar calculations
// ------------------------------------------------------------
/// @name scalar calculations

/**
 Ensures that a scalar value stays within the range [min..max], inclusive.

 @param value The value to clamp.
 @param min The minimum the value shouldn't exceed.
 @param max The maximum the value shouldn't exceed.
 @return The value clamped.
 */
static func Clamp(value:CGFloat, min:CGFloat, max:CGFloat) -> CGFloat {
  return ((value < min) ? min : ((value > max) ? max : value))
}

/**
 Returns only YES if two scalars are approximately equal within a given variance.

 @param value A value.
 @param other Another value.
 @param variance The delta in which both values may vary.
 @return True if both values are approximately equal.
 */
static func ScalarNearOtherWithVariance(value:CGFloat, other:CGFloat, variance:CGFloat) -> Bool {
  if value <= other + variance && value >= other - variance {
    return true
  }
  return false
}

/**
 Returns only YES if two scalars are approximately equal, only within a difference of the value defined by INSK_EPSILON.

 @param value A value.
 @param other Another value.
 @return True if both values are approximately equal.
 */
static func ScalarNearOther(value:CGFloat, other:CGFloat) -> Bool {
  if value <= other + CGFloat.ulpOfOne && value >= other - CGFloat.ulpOfOne {
    return true
  }
  return false
}

/**
 Returns 1.0 if a floating point value is positive, including zero or returns -1.0 if it is negative.

 @param value A value.
 @return +1.0 if the value is positive or zero, -1.0 if it is negative.
 */
static func ScalarSign(value:CGFloat) -> CGFloat {
  return ((value >= 0.0) ? 1.0 : -1.0)
}


// ------------------------------------------------------------
// MARK: - CGPoint calculations
// ------------------------------------------------------------
/// @name CGPoint calculations

/**
 Adds an offset (dx, dy) to the point.

 @param point The point.
 @param dx The X offset.
 @param dy The y offset.
 @return A new point.
 */
static func CGPointOffset(point:CGPoint, dx:CGFloat, dy:CGFloat) -> CGPoint {
  return CGPointFromGLKVector2(vector: GLKVector2Add(GLKVector2FromCGPoint(point: point), GLKVector2Make(Float(dx), Float(dy))))
}

/**
 Adds two CGPoint values and returns the result as a new CGPoint.

 @param point1 A point.
 @param point2 Another point.
 @return A new point.
 */
static func CGPointAdd(point1:CGPoint, point2:CGPoint) -> CGPoint {
  return CGPointFromGLKVector2(vector: GLKVector2Add(GLKVector2FromCGPoint(point: point1), GLKVector2FromCGPoint(point: point2)))
}

/**
 Subtracts point2 from point1 and returns the result as a new CGPoint.

 @param point1 A point.
 @param point2 Another point.
 @return A new point.
 */
static func CGPointSubtract(point1:CGPoint, point2:CGPoint) -> CGPoint {
  return CGPointFromGLKVector2(vector: GLKVector2Subtract(GLKVector2FromCGPoint(point: point1), GLKVector2FromCGPoint(point: point2)))
}

/**
 Multiplies two CGPoint values and returns the result as a new CGPoint.

 @param point1 A point.
 @param point2 Another point.
 @return A new point.
 */
static func CGPointMultiply(point1:CGPoint, point2:CGPoint) -> CGPoint {
  return CGPointFromGLKVector2(vector: GLKVector2Multiply(GLKVector2FromCGPoint(point: point1), GLKVector2FromCGPoint(point: point2)))
}

/**
 Multiplies the x and y fields of a CGPoint with the same scalar value and returns the result as a new CGPoint.

 @param point A point.
 @param value A scalar.
 @return A new point.
 */
static func CGPointMultiplyScalar(point:CGPoint, value:CGFloat) -> CGPoint {
  return CGPointFromGLKVector2(vector: GLKVector2MultiplyScalar(GLKVector2FromCGPoint(point: point), Float(value)))
}

/**
 Divides point1 by point2 and returns the result as a new CGPoint.

 @param point1 A point.
 @param point2 Another point.
 @return A new point.
 */
static func CGPointDivide(point1:CGPoint, point2:CGPoint) -> CGPoint {
  return CGPointFromGLKVector2(vector: GLKVector2Divide(GLKVector2FromCGPoint(point: point1), GLKVector2FromCGPoint(point: point2)))
}

/**
 Divides the x and y fields of a CGPoint by the same scalar value and returns the result as a new CGPoint.

 @param point A point.
 @param value A scalar.
 @return A new point.
 */
static func CGPointDivideScalar(point:CGPoint, value:CGFloat) -> CGPoint {
  return CGPointFromGLKVector2(vector: GLKVector2DivideScalar(GLKVector2FromCGPoint(point: point), Float(value)))
}

/**
 Returns the length (magnitude) of the vector described by a CGPoint.

 @param point A point.
 @return The length scalar.
 */
static func CGPointLength(point:CGPoint) -> CGFloat {
  return CGFloat(GLKVector2Length(GLKVector2FromCGPoint(point: point)))
}

/**
 Returns the square length by not calling sqrt() when calculating the length.

 @param point A point.
 @return The squared length.
 */
static func CGPointLengthSq(point:CGPoint) -> CGFloat {
  let vector:GLKVector2 = GLKVector2FromCGPoint(point: point)
  return CGFloat(GLKVector2DotProduct(vector, vector))
}

/**
 Normalizes the vector described by a CGPoint to length 1.0 and returns the result as a new CGPoint.

 @param point A point.
 @return A new point.
 */
static func CGPointNormalize(point:CGPoint) -> CGPoint {
  return CGPointFromGLKVector2(vector: GLKVector2Normalize(GLKVector2FromCGPoint(point: point)))
}

/**
 Calculates the distance between two CGPoints.

 @param point1 A point.
 @param point2 Another point.
 @return A new point.
 */
static func CGPointDistance(point1:CGPoint, point2:CGPoint) -> CGFloat {
  return CGFloat(GLKVector2Distance(GLKVector2FromCGPoint(point: point1), GLKVector2FromCGPoint(point: point2)))
}

/**
 Calculates the square distance between two CGPoints by not calling sqrt() when calculating the distance.

 @param point1 A point.
 @param point2 Another point.
 @return A new point.
 */
static func CGPointDistanceSq(point1:CGPoint, point2:CGPoint) -> CGFloat {
  return CGPointLengthSq(point: CGPointSubtract(point1: point1, point2: point2))
}

/**
 Negates a point by multiplying x and y with -1 and returns the result as a new CGPoint.

 @param point A point.
 @return A new point.
 */
static func CGPointNegate(point:CGPoint) -> CGPoint {
  return CGPointFromGLKVector2(vector: GLKVector2Negate(GLKVector2FromCGPoint(point: point)))
}

/**
 Performs a linear interpolation between two CGPoint values.
 point1 will be the start point and point2 the end point while t gives the percentag in the range of 0 to 1.

 @param point1 A point.
 @param point2 Another point.
 @param t The percentage from 0 to 1 for interpolating point1 to point2.
 @return A new point.
 */
static func CGPointLerp(point1:CGPoint, point2:CGPoint, t:CGFloat) -> CGPoint {
  return CGPointFromGLKVector2(vector: GLKVector2Lerp(GLKVector2FromCGPoint(point: point1), GLKVector2FromCGPoint(point: point2), Float(t)))
}

/**
 Returns the dot product of the two CGPoint values.

 @param point1 A point.
 @param point2 Another point.
 @return A new point.
 */
static func CGPointDotProduct(point1:CGPoint, point2:CGPoint) -> CGFloat {
  return CGFloat(GLKVector2DotProduct(GLKVector2FromCGPoint(point: point1), GLKVector2FromCGPoint(point: point2)))
}

/**
 Returns the cross product of the two CGPoint values.

 @param point1 A point.
 @param point2 Another point.
 @return A new point.
 */
static func CGPointCrossProduct(point1:CGPoint, point2:CGPoint) -> CGFloat {
  return point1.x * point2.y - point1.y * point2.x
}

/**
 Returns the projection of point1 over point2.

 @param point1 A point.
 @param point2 Another point.
 @return A new point.
 */
static func CGPointProject(point1:CGPoint, point2:CGPoint) -> CGPoint {
  return CGPointFromGLKVector2(vector: GLKVector2Project(GLKVector2FromCGPoint(point: point1), GLKVector2FromCGPoint(point: point2)))
}

/**
 Returns a CGPoint next to point, but between min and max inclusive.

 @param point A point.
 @param min A minimum point.
 @param max A maximum point.
 @return A new point.
 */
static func CGPointClamp(point:CGPoint, min:CGPoint, max:CGPoint) -> CGPoint {
  return CGPointMake(Clamp(value: point.x, min: min.x, max: max.x), Clamp(value: point.y, min: min.y, max: max.y))
}

/**
 Uniforms a point to a rect by substracting the rect's origin from the point vector and
 uniforming it afterwards to the rect's size so it will be scaled procentually.

 @param point A point.
 @param rect A rectangle.
 @return A new point.
 */
static func CGPointNormalizedInRect(point:CGPoint, rect:CGRect) -> CGPoint {
  let relativePoint:GLKVector2 = GLKVector2Subtract(GLKVector2FromCGPoint(point: point), GLKVector2FromCGPoint(point: rect.origin))
  return CGPointFromGLKVector2(vector: GLKVector2Divide(relativePoint, GLKVector2Make(Float(rect.size.width), Float(rect.size.height))))
}

/**
 Uniforms the point to the size so the point will be procentually long to the size.

 @param point A point.
 @param size A size.
 @return A new point.
 */
static func CGPointNormalizedInSize(point:CGPoint, size:CGSize) -> CGPoint {
  return CGPointFromGLKVector2(vector: GLKVector2Divide(GLKVector2FromCGPoint(point: point), GLKVector2Make(Float(size.width), Float(size.height))))
}

/**
 Returns true if two CGPoints are nearly equal within a variance, otherwise false.

 @param point1 A point.
 @param point2 Another point.
 @param variance A small delta scalar.
 @return True if both points are within the variance, otherwise false.
 */
static func CGPointNearToPointWithVariance(point1:CGPoint, point2:CGPoint, variance:CGFloat) -> Bool {
  if point1.x <= point2.x + variance && point1.x >= point2.x - variance {
    if point1.y <= point2.y + variance && point1.y >= point2.y - variance {
      return true
    }
  }
  return false
}

/**
 Returns true if the CGPoints are nearly equal within a variance of INSK_EPSILON.

 @param point1 A point.
 @param point2 Another point.
 @return True if bot points are approximately equal.
 */
static func CGPointNearToPoint(point1:CGPoint, point2:CGPoint) -> Bool {
  return CGPointNearToPointWithVariance(point1: point1, point2: point2, variance: CGFloat.ulpOfOne)
}


// ------------------------------------------------------------
// MARK: - CGSize calculations
// ------------------------------------------------------------
/// @name CGSize calculations

/**
 Scales a CGSize to fit a destination size respecting the aspect ratio and returns the scale factor. The new size will be smaller than the destination.

 @param origSize The current size of an object which has to be scaled.
 @param destSize The max size to which an object has to be scaled.
 @return The scale factor to fit an object into respecting the aspect ratio.
 */
static func CGSizeScaleFactorToSizeAspectFit(origSize:CGSize, destSize:CGSize) -> CGFloat {
  let ratioWidth:CGFloat = destSize.width / origSize.width
  let ratioHeight:CGFloat = destSize.height / origSize.height
  return min(ratioWidth, ratioHeight)
}

/**
 Scales a CGSize to fit a destination size respecting the aspect ratio.

 Uses CGSizeScaleFactorToSizeAspectFit(CGSize, CGSize) to determine the scale factor with which the size will be multiplied.

 @param origSize The current size of an object which has to be scaled.
 @param destSize The max size to which an object has to be scaled.
 @return The scaled size .
 */
static func CGSizeScaledToSizeAspectFit(origSize:CGSize, destSize:CGSize) -> CGSize {
  let scaleFactor:CGFloat = CGSizeScaleFactorToSizeAspectFit(origSize: origSize, destSize: destSize)
  return CGSizeMake(origSize.width * scaleFactor, origSize.height * scaleFactor)
}

/**
 Scales a CGSize to fill a destination size respecting the aspect ratio and returns the scale factor. The new size will be greater than the destination.

 @param origSize The current size of an object which has to be scaled.
 @param destSize The max size to which an object has to be scaled.
 @return The scale factor to fill an object into respecting the aspect ratio.
 */
static func CGSizeScaleFactorToSizeAspectFill(origSize:CGSize, destSize:CGSize) -> CGFloat {
  let ratioWidth:CGFloat = destSize.width / origSize.width
  let ratioHeight:CGFloat = destSize.height / origSize.height
  return max(ratioWidth, ratioHeight)
}

/**
 Scales a CGSize to fill a destination size respecting the aspect ratio.

 Uses CGSizeScaleFactorToSizeAspectFill(CGSize, CGSize) to determine the scale factor with which the size will be multiplied.

 @param origSize The current size of an object which has to be scaled.
 @param destSize The max size to which an object has to be scaled.
 @return The scaled size .
 */
static func CGSizeScaledToSizeAspectFill(origSize:CGSize, destSize:CGSize) -> CGSize {
  let scaleFactor:CGFloat = CGSizeScaleFactorToSizeAspectFill(origSize: origSize, destSize: destSize)
  return CGSizeMake(origSize.width * scaleFactor, origSize.height * scaleFactor)
}


// ------------------------------------------------------------
// MARK: - angular convertions and calculations
// ------------------------------------------------------------
/// @name angular convertions and calculations

/**
 Converts an angle in degrees to radians.

 @param degrees An angle in degrees.
 @return The angle in radians.
 */
static func DegreesToRadians(degrees:CGFloat) -> CGFloat {
  return degrees * M_PI_180
}

/**
 Converts an angle in radians to degrees.

 @param radians An angle in radians.
 @return The angle in degrees.
 */
static func RadiansToDegrees(radians:CGFloat) -> CGFloat {
  return radians * M_180_PI
}

/**
 Given an angle in radians, creates a vector of length 1.0 and returns the result as a new CGPoint.
 An angle of 0 is assumed to point to the right so the point (x=1,y=0) will be returned in this case.

 @param angle An angle in radians.
 @return A CGPoint as a vector.
 */
static func CGPointForAngle(angle:CGFloat) -> CGPoint {
  return CGPointMake(cos(angle), sin(angle))
}

/**
 Returns the angle in radians of the vector described by a CGPoint.
 The range of the angle is -M_PI to M_PI with an angle of 0 points to the right.
 An angle of M_PI will point to the left, a negative angle points down and a positive value up.

 @param point A point as a vector.
 @return The angle in radians.
 */
static func CGPointToAngle(point:CGPoint) -> CGFloat {
  return atan2(point.y, point.x)
}

/**
 Wraps a radian angle around so it stays in the range of 0 to 2 * M_PI.

 @param angle An angle in radians from -M_PI to M_PI.
 @return The angle in radians from 0 to 2*M_PI.
 */
static func AngleIn2Pi(angle:CGFloat) -> CGFloat {
  var newAngle = angle
  while  newAngle >= M_PI_X_2 {
    newAngle -= M_PI_X_2
  }
  while  newAngle < 0.0 {
    newAngle += M_PI_X_2
  }
  return newAngle
}

/**
 Wraps a radian angle around so it stays in the range of -M_PI to M_PI.

 @param angle An angle in radians from 0 to 2*M_PI.
 @return The angle in radians from -M_PI to M_PI.
 */
static func AngleInPi(angle:CGFloat) -> CGFloat {
  var newAngle = angle
  while  newAngle >= CGFloat.pi {
    newAngle -= M_PI_X_2
  }
  while  newAngle < -CGFloat.pi {
    newAngle += M_PI_X_2
  }
  return newAngle
}

/**
 Returns the shortest angle between two radian angles. The result is always between -M_PI and M_PI.

 If the angle1 is smaller than angle2 a negative angle will be returned.
 If angle1 is bigger than angle2 a positive angle will be returned.

 @param angle1 The first angle in radians.
 @parma angle2 The second angle in radians.
 @return The difference angle in radians. A positive value means a clockwise, a negative counterclockwise direction.
 */
static func ShortestAngleBetween(angle1:CGFloat, angle2:CGFloat) -> CGFloat {
  var a1 = angle1
  var a2 = angle2
  if a1 < 0.0 {
    a1 += M_PI_X_2
  }
  if a2 < 0.0 {
    a2 += M_PI_X_2
  }
  var angle:CGFloat = angle2 - angle1
  while  angle > CGFloat.pi {
    angle -= M_PI_X_2
  }
  while  angle < -CGFloat.pi {
    angle += M_PI_X_2
  }
  return angle
}
//#endif


}
