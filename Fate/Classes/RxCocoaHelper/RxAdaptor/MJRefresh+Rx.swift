//
//  MJRefresh+Rx.swift
//  Fate
//
//  Created by mile on 2021/4/15.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh


public class MWTarget: NSObject, Disposable {
    private var retainSelf: MWTarget?
    
    override init() {
        super.init()
        self.retainSelf = self
    }
    public func dispose() {
        self.retainSelf = nil
    }
    
    
}
private final class MJRefreshTarget<Component: MJRefreshComponent>: MWTarget {
    weak var component: Component?
    let refreshingBlock: MJRefreshComponentAction
    
    init(_ component: Component , refreshingBlock: @escaping MJRefreshComponentAction) {
        self.refreshingBlock = refreshingBlock
        self.component = component
        super.init()
        component.setRefreshingTarget(self, refreshingAction: #selector(onRefeshing))
    }
    
    @objc func onRefeshing() {
        refreshingBlock()
    }
    
    override func dispose() {
        super.dispose()
        self.component?.refreshingBlock = nil
    }
}

public extension Reactive where Base: MJRefreshComponent {
    public var refresh: ControlProperty<MJRefreshState> {
        let source: Observable<MJRefreshState> = Observable.create {[weak component = base] (observer) in
            MainScheduler.ensureExecutingOnScheduler()
            guard let safecomponent = component else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            observer.on(.next(safecomponent.state))
            
            let controlTarget = MJRefreshTarget(safecomponent) {[unowned component] in
                if let tempComponent = component {
                    observer.on(.next(tempComponent.state))
                }
            }
            return controlTarget
        }.takeUntil(deallocated)
        
        let bindingObserver = Binder<MJRefreshState>(base) { (component, state) in
            component.state = state
        }
        
        return ControlProperty(values: source, valueSink: bindingObserver)
    }
}
