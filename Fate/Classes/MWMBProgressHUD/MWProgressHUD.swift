//
//  MWProgressHUD.swift
//  Fate
//
//  Created by mile on 2021/4/22.
//

import Foundation
import MBProgressHUD


public enum MWProgressHUDMode {
    case loading
    case loadingWith(type: MWProgressLoadingMode, color: UIColor = UIColor.lightGray)
    case text
    case image(UIImage?)
    case success
    case error
}

public final class MWProgressHUD {
    
    private static var minimumDismissTimeInterval: TimeInterval = 1 // default is 1.0 seconds
    private static var maximumDismissTimeInterval: TimeInterval = TimeInterval.greatestFiniteMagnitude // default is greatestFiniteMagnitude

    private static var _shared: MBProgressHUD?
    
    public static var shared: MBProgressHUD? {
        get {
            return _shared
        }
        set {
            _shared?.hide(animated: true)
            _shared = newValue
        }
    }
    // 默认的HUD 类型
    private static var _defaultMode: MWProgressHUDMode = .loadingWith(type: .ballRotateChase, color: .lightGray)
    public static var defaultMode: MWProgressHUDMode {
        get {
            return _defaultMode
        }
        set {
            _defaultMode = newValue
        }
    }
    
    
    public static func show(
        _ type: MWProgressHUDMode? = nil,
        title: String? = nil,
        subtitle: String? = nil,
        onView view: UIView? = nil) {
        MWProgressHUD.show(on: view)
        
        switch type ?? self.defaultMode {
        case .loading:
            MWProgressHUD.shared?.mode = .indeterminate
        case .loadingWith( let mode, let color):
            MWProgressHUD.shared?.mode = .customView
            MWProgressHUD.shared?.customView = MWProgressLoadingView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: mode, color: color, padding: nil)
        case .text:
            MWProgressHUD.shared?.mode = .text
        case .success:
            MWProgressHUD.shared?.mode = .customView
//
        case .error:
            MWProgressHUD.shared?.mode = .customView
//
        case .image(let image):
            MWProgressHUD.shared?.mode = .customView
            MWProgressHUD.shared?.customView = UIImageView(image: image)
        }

        MWProgressHUD.shared?.label.text = title
        MWProgressHUD.shared?.detailsLabel.text = subtitle
    }
    
    public static func hide(animation: Bool = false, completion:(() -> Void)? = nil) {
        MWProgressHUD.shared?.hide(animated: animation)
        completion?()
    }
    
    public static func hide(afterDelay delay: TimeInterval, completion: (() -> Void)? = nil){        
        MWProgressHUDTimer.shared.countdown(second: Int(ceil(delay))) { (sucess) in
            if sucess {
                MWProgressHUD.shared?.hide(animated: true)
                completion?()
            }else {
                mw_log.debug("定时器错误")
                completion?()
            }
        }
    }
    public static func flash(_ type: MWProgressHUDMode,
    title: String?,
    subtitle: String? = nil,
    onView view: UIView? = nil)  {
        MWProgressHUD.show(type, title: title, subtitle: subtitle, onView: view)
        
        let length: TimeInterval = TimeInterval(max((title?.count ?? 0), (subtitle?.count ?? 0)))
        // 按照每分钟阅读700字（每0.086秒读一个字）计算
        let minimum = max(length * 0.086, MWProgressHUD.minimumDismissTimeInterval)
        let displayDurationForString = min(minimum, MWProgressHUD.maximumDismissTimeInterval)

        MWProgressHUD.hide(afterDelay: displayDurationForString)
    }
    
    public static func flash(_ type: MWProgressHUDMode,
                             title: String?,
                             subtitle: String? = nil,
                             delay: TimeInterval,
                             onView view: UIView? = nil,
                             completion: (() -> Void)? = nil) {
        MWProgressHUD.show(type, title: title, subtitle: subtitle, onView: view)
        MWProgressHUD.hide(afterDelay: delay, completion: completion)
    }
}

private extension MWProgressHUD {
    @discardableResult
    static func show(on view: UIView? = nil) -> MBProgressHUD? {
        guard let view = view ?? UIApplication.shared.keyWindow else {
            return nil
        }
        if  MWProgressHUD.shared?.superview != nil {
            MWProgressHUD.shared?.hide(animated: true)
        }
        MWProgressHUD.shared = MBProgressHUD(view: view)
        MWProgressHUD.shared?.removeFromSuperViewOnHide = true
        MWProgressHUD.shared?.label.numberOfLines = 0
        MWProgressHUD.shared?.detailsLabel.numberOfLines = 0
//        MWProgressHUD.shared?.graceTime =
//        MWProgressHUD.shared?.bezelView.color =
//        MWProgressHUD.shared?.backgroundView.color =
        view.addSubview(MWProgressHUD.shared!)
        MWProgressHUD.shared?.show(animated: true)
        
        return MWProgressHUD.shared
    }
}
