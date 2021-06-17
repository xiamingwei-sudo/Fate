//
//  UIWindow+CUSafeAreas.swift
//  CUExChangeGW
//
//  Created by mile on 2021/1/13.
//

import Foundation
import UIKit
#if !COCOAPODS
import Fate
#endif

fileprivate let kFDFixedStatusBarHeight: CGFloat = 20.0
fileprivate let kFDFixedPortraitNavigationBarHeight: CGFloat = 44.0
/// 横屏补充
fileprivate let kFDFixedLandscapeNavigationBarHeight: CGFloat = 32.0

public extension MWFolDin where Base == UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
}

public extension UIWindow {
    
    func cu_layoutInsets() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            let safeAreaInsets: UIEdgeInsets = self.safeAreaInsets
            if safeAreaInsets.bottom > 0 {
                // 参考文章：https://mp.weixin.qq.com/s/Ik2zBox3_w0jwfVuQUJAUw
                return safeAreaInsets
            }
            return UIEdgeInsets(top: kFDFixedStatusBarHeight, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: kFDFixedStatusBarHeight, left: 0, bottom: 0, right: 0)
    }
    
    func cu_navigationHeight() -> CGFloat {
        let statusBarHeight = cu_layoutInsets().top
        return statusBarHeight + kFDFixedPortraitNavigationBarHeight
    }
    
   
}

public extension UIViewController {
    
    /// 判断是否是刘海屏
    /// - Returns: bool
    func isLiuhai() -> Bool {
        if #available(iOS 11.0, *) {
            return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && self.cu_saftAreaInsetBottom() > 0
        }
        
        return false
    }
    
    func cu_layoutSafeInsetTop() -> CGFloat {
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        var safeAreaInsetTop: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            safeAreaInsetTop = UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0.0
        }
        let interfaceOriention = UIApplication.shared.statusBarOrientation
        let isPortrait: Bool = interfaceOriention.isPortrait
        return statusBarHeight > 0 ? statusBarHeight: ((safeAreaInsetTop > 0) ? safeAreaInsetTop: (isPortrait ? (isLiuhai() ? kFDFixedPortraitNavigationBarHeight : kFDFixedStatusBarHeight) : 0))
    }
    
    func cu_navibarHeight() -> CGFloat {
        let isPortrait: Bool = UIApplication.shared.statusBarOrientation.isPortrait
        return isPortrait ? kFDFixedPortraitNavigationBarHeight: (UIApplication.shared.isStatusBarHidden ? kFDFixedPortraitNavigationBarHeight: kFDFixedLandscapeNavigationBarHeight)
    }
    func cu_fullNavibarHeight() -> CGFloat {
        return self.cu_layoutSafeInsetTop() + self.cu_navibarHeight()
    }
    
    func cu_saftAreaInsetBottom() -> CGFloat {
        var safeAreaInsetBottom: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            safeAreaInsetBottom = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0.0
        }
        let isPortrait: Bool = UIApplication.shared.statusBarOrientation.isPortrait
        return isPortrait ? safeAreaInsetBottom: 0.0
    }
}
