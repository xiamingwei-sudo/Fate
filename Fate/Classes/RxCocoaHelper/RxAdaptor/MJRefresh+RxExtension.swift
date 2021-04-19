//
//  MJRefresh+RxExtension.swift
//  Fate
//
//  Created by mile on 2021/4/15.
//

import Foundation
import MJRefresh
import RxSwift
public struct MWRefreshState {
    
    /// 上拉加载状态
    var upState:   MJRefreshState
    
    /// 下拉刷新状态
    var downState: MJRefreshState
    
    public init(_ downState: MJRefreshState = .idle, _ upState: MJRefreshState = .idle) {
        self.upState = upState
        self.downState = downState
    }
}

func synchronized<T>(_ key: Any, _ action: () -> T) -> T {
    objc_sync_enter(key)
    let result = action()
    objc_sync_exit(key)
    return result
}

public extension UIScrollView {
    /// 下拉刷新控件
    public var refreshHeader: MJRefreshHeader {
        set {
            synchronized(self) {
                mj_header = newValue;
            }
        }
        get {
            return synchronized(self) {
                if let header = mj_header {
                    return header
                }
                mj_header = MJRefreshNormalHeader()
                return mj_header!
            }
        }
    }
    
    /// 上拉刷新控件
    public var refreshFooter: MJRefreshFooter {
        set {
            synchronized(self) {
                mj_footer = newValue;
            }
        }
        get {
            return synchronized(self) {
                if let footer = mj_footer {
                    return footer
                }
                let footer = MJRefreshAutoStateFooter()
                mj_footer = footer
                return mj_footer!
            }
        }
    }
}
