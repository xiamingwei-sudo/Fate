//
//  RxCocoaHelper.swift
//  Fate
//
//  Created by 夏明伟 on 2020/12/30.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

extension Reactive where Base: UIButton {

    /**
     var safeTap: ControlEvent<Void> {
         return ControlEvent(events: tap.throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance))
     }
     
     func safeDrive(onNext: @escaping ((Base) -> Void), onCompleted: (() -> Void)? = nil, onDisposed: (() -> Void)? = nil) -> Disposable {
         return self.safeTap
             .asControlEvent()
             .asDriver()
             .drive{
                 onNext(self.base)
             } onCompleted: {
                 onCompleted?()
             } onDisposed: {
                 onDisposed?()
             }
     }
     */
     func safeTap(_ dueTime: RxSwift.RxTimeInterval, latest: Bool = false) -> ControlEvent<Void> {
        return ControlEvent(events: tap.throttle(dueTime, latest: latest, scheduler: MainScheduler.instance))
    }
    
    func safeDrive(_ dueTime: RxSwift.RxTimeInterval, latest: Bool = false, onNext: @escaping ((Base) -> Void), onCompleted: (() -> Void)? = nil, onDisposed: (() -> Void)? = nil) -> Disposable {
        return self.safeTap(dueTime, latest: latest)
            .asControlEvent()
            .asDriver()
            .drive{
                onNext(self.base)
            } onCompleted: {
                onCompleted?()
            } onDisposed: {
                onDisposed?()
            }
    }
}

extension Reactive where Base: UITextField {
    //MARK: debounce: 防抖。 避免连续调用，默认0.5s 后响应一次
    func safeDrive(_ dueTime: RxSwift.RxTimeInterval, onNext: @escaping (String) -> Void, onCompleted: (() -> Void)? = nil, onDisposed: (() -> Void)? = nil) -> Disposable {
        return text.orEmpty
            .asDriver()
            .distinctUntilChanged()
            .debounce(dueTime)
            .drive{ query in
                onNext(query)
            } onCompleted: {
                onCompleted?()
            } onDisposed: {
                onDisposed?()
            }
    }
}

extension Reactive where Base: UISearchBar {
    //MARK: debounce: 防抖。 避免连续调用，默认0.5s 后响应一次
    func safeDrive(_ dueTime: RxSwift.RxTimeInterval, onNext: @escaping (String) -> Void, onCompleted: (() -> Void)? = nil, onDisposed: (() -> Void)? = nil) -> Disposable {
        return text.orEmpty
            .asDriver()
            .distinctUntilChanged()
            .debounce(dueTime)
            .drive{ query in
                onNext(query)
            } onCompleted: {
                onCompleted?()
            } onDisposed: {
                onDisposed?()
            }
    }
}

public extension MWFolDin where Base: UIButton {
    //MARK: 避免连续调用（默认 0.5s 响应一次）
    func rxDrive(_ dueTime: RxSwift.RxTimeInterval = .milliseconds(500), latest: Bool = false,onNext: @escaping ((UIButton) -> Void)) -> Disposable {
        return self.base.rx.safeDrive(dueTime, onNext: onNext)
    }
}

public extension MWFolDin where Base: UITextField {
    func rxDrive(_ dueTime: RxSwift.RxTimeInterval = .milliseconds(500),onNext: @escaping ((String) -> Void))  -> Disposable {
        return self.base.rx.safeDrive(dueTime,onNext: onNext)
    }
}

public extension MWFolDin where Base: UISearchBar {
    func rxDrive(_ dueTime: RxSwift.RxTimeInterval = .milliseconds(500),onNext: @escaping ((String) -> Void))  -> Disposable {
        return self.base.rx.safeDrive(dueTime, onNext: onNext)
    }
}
