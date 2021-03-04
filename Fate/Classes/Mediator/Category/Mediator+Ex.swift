//
//  Mediator+Ex.swift
//  Mediator
//
//  Created by 夏明伟 on 2020/12/21.
//

import Foundation

public extension Mediator {
    static func getNetHomeViewController(_ paramaters: [String: Any]?) -> UIViewController? {
        return perform("getCUHomeViewController", inClass: "CUGatewayTarget", onModule: "CUGatewaySDK") as? UIViewController
    }
    /// callback 为获取输入昵称的回调
    static func getUpdateNicknameViewController(_ paramaters: [String : Any]) -> UIViewController? {
        return perform("getUpdateNicknameViewController:", // with parameters
                       inClass: "AppLoginTarget",
                       onModule: "AppLogin",
                       usingParameters: paramaters) as? UIViewController
    }
}
