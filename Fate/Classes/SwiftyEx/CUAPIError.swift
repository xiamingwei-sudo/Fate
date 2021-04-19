//
//  CUAPIError.swift
//  CUExChangeGW
//
//  Created by mile on 2021/1/12.
//

import Foundation


public enum CUAPIError {
    /// 未知错误
    case unknown
    /// 请求超时
    case timedOut
    /// 找不到服务器
    case cannotFindHost
    /// 无法连接服务器
    case cannotConnectToHost
    // 无法连接网关
    case cannotConnectToGate
    
    /// 没有连接互联网
    case notConnectedToInternet
    /// 后台返回转json字符串出错
    case stringMapping
    /// 后台返回转json 模型失败
    case jsonMapping
    /// 非HTTP成功状态码
    case statusCode(Int)
    
    // 预定义错误信息
    case errorMsg(message: String = "")
    /// 其他奇奇怪怪的错误
    case underlying(Error)
    /// 预定义的错误
    case predefined(code: Int, message: String)
    
    
    public static func tranform(_ error: Error?) -> CUAPIError {
        if let cuerror = error as? CUAPIError {
            return cuerror
        }else if let urlError = error as? URLError {
            if urlError.code == URLError.timedOut {
                return CUAPIError.timedOut
            } else if urlError.code == URLError.cannotFindHost {
                return CUAPIError.cannotFindHost
            } else if urlError.code == URLError.cannotConnectToHost {
                return CUAPIError.cannotConnectToHost
            } else if urlError.code == URLError.notConnectedToInternet {
                return CUAPIError.notConnectedToInternet
            } else {
                return CUAPIError.underlying(urlError)
            }
        }else if let err = error {
            return CUAPIError.underlying(err)
        }else{
            return CUAPIError.unknown
        }
    }
}

extension CUAPIError: CUErrorConvertible {
    public var code: Int {
        switch self {
        case .unknown:
            return -10086
        case .timedOut:
            return URLError.timedOut.rawValue
        case .cannotFindHost:
            return URLError.cannotFindHost.rawValue
        case .cannotConnectToHost:
            return URLError.cannotConnectToHost.rawValue
        case .cannotConnectToGate:
            return -20007
        case .notConnectedToInternet:
            return URLError.notConnectedToInternet.rawValue
        case .stringMapping:
            return -10087
        case .jsonMapping:
            return -10088
        case .errorMsg(_):
            return -20008
        case .statusCode(let code):
            return code
        case .underlying:
            return -10089
        case .predefined(let code, _):
            return code
        }
    }
    
    public var message: String {
        switch self {
        case .unknown:
            return "未知错误"
        case .timedOut:
            return "请求超时"
        case .cannotFindHost:
            return "找不到服务器"
        case .cannotConnectToHost:
            return "无法连接服务器"
        case .cannotConnectToGate:
            return "无法连接网关"
        case .notConnectedToInternet:
            return "网络未连接"
        case .stringMapping:
            return "JSON解析错误"
        case .jsonMapping:
            return "JSON模型转换失败"
        case .errorMsg(let message):
             return message
        case .statusCode(let code):
            return "请求失败, code = \(code)"
        case .underlying(let error):
            return "请求失败, error = \(error)"
        case let .predefined(_, message):
            return message
        }
    }
}




/// 代表一个错误
public protocol CUErrorConvertible: Error {
    /// 错误码
    var code: Int { get }
    /// 错误信息
    var message: String { get }
}

extension CUErrorConvertible {
    /// Default implementation for `code` property
    public var code: Int {
        return 200
    }
}

fileprivate let networkErrorCodes = [URLError.timedOut.rawValue,
                                     URLError.cannotFindHost.rawValue,
                                     URLError.cannotConnectToHost.rawValue,
                                     URLError.notConnectedToInternet.rawValue]
extension CUErrorConvertible {
    /// token是否过期
    public var isTokenExpired: Bool {
        return code == 40008
    }
    
    /// 是否是网络错误
    public var isFailedByNetwork: Bool {
        return networkErrorCodes.contains(code)
    }
    
    
    
}

