//
//  MWFolDin.swift
//  MWNamespacer
//
//  Created by 夏明伟 on 2021/1/4.
//
// MARK:  `mw` namespacer 命名空间
//  命名空间模块，提供object.mw.property/object.mw.method()的访问形式来替代object.mw_property/object.mw_method()

import Foundation

public final class MWFolDin<Base> {
    public let base: Base
    public init(_ base: Base){
        self.base = base
    }
}

public protocol MWFolDinCompatible {
    //MARK: 定义泛型类型的关联类型，当协议被使用的时候指定其所关联的类型
    associatedtype Compatible
    
    static var mw: MWFolDin<Compatible>.Type { get }
    
    var mw: MWFolDin<Compatible> { get }
}

extension MWFolDinCompatible {
    public static var mw: MWFolDin<Self>.Type {
        return MWFolDin<Self>.self
    }
    public var mw: MWFolDin<Self> {
        return MWFolDin(self)
    }
}

import class Foundation.NSObject

extension NSObject: MWFolDinCompatible {}
