//
//  Then.swift
//  CUExChangeGW
//
//  Created by mile on 2021/1/13.
//

import Foundation
import CoreGraphics
#if os(iOS) || os(tvOS)
    import UIKit.UIGeometry
#endif
public protocol Then {}

extension Then where Self: Any {
    
    /// Makes it available to set properties with closures just after initializing and copying the value types. 使它可以在初始化和复制值类型之后使用闭包设置属性。
    ///
    ///     let frame = CGRect().with {
    ///       $0.origin.x = 10
    ///       $0.size.width = 100
    ///     }
    public func with(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }
    /// Makes it available to execute something with closures. 使它可以在闭包里设置一些东西
    ///
    ///     UserDefaults.standard.do {
    ///       $0.set("devxoul", forKey: "username")
    ///       $0.set("devxoul@gmail.com", forKey: "email")
    ///       $0.synchronize()
    ///     }
    public func `do` (_ block: (Self) throws -> Void) rethrows {
        try(block(self))
    }
}
extension Then where Self: AnyObject {

  /// Makes it available to set properties with closures just after initializing. 使它可以在初始化后使用闭包设置属性。
  ///
  ///     let label = UILabel().then {
  ///       $0.textAlignment = .Center
  ///       $0.textColor = UIColor.blackColor()
  ///       $0.text = "Hello, World!"
  ///     }
  public func then(_ block: (Self) throws -> Void) rethrows -> Self {
    try block(self)
    return self
  }

}

extension NSObject: Then {}

extension CGPoint: Then {}
extension CGRect: Then {}
extension CGSize: Then {}
extension CGVector: Then {}

#if os(iOS) || os(tvOS)
  extension UIEdgeInsets: Then {}
  extension UIOffset: Then {}
  extension UIRectEdge: Then {}
#endif
