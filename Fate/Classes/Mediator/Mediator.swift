//
//  Mediator.swift
//  Mediator
//
//  Created by 夏明伟 on 2020/12/21.
//

import Foundation

public struct Mediator {
    private init() {}
    public typealias Class = String
    public typealias Module = String
    public typealias Selector = String
}

extension Mediator {
    public static func openUrl (_ url: URL, completion: (() -> Void)? = nil) -> Any? {
        fatalError("openURL foundation has not been implemented.")
    }
    
    public static func perform(_ aSelector: Selector, inClass class: Class, onModule module: Module? = nil, usingParameters parameters: [String: Any]? = nil) -> Any? {
        return __objc_performSelector(aSelector, `class`, module, parameters)
    }
}
