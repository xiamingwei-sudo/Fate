//
//  MWProgressHUDTimer.swift
//  Fate
//
//  Created by mile on 2021/4/23.
//

import Foundation
import RxSwift

final class MWProgressHUDTimer {
    
    static let shared: MWProgressHUDTimer  = MWProgressHUDTimer()
    private var disposeBag: DisposeBag?
    func countdown(second: Int,
                          immediately: Bool = true,
                          duration: ((Int) -> Void)? = nil, completion:((Bool) -> Void)? = nil) {
        self.stopTimer()
        let disposeble = Timer.rx.countdown(second: second, immediately: immediately, duration: duration)
            .subscribe { _ in
                completion?(true)
            } onError: { _ in
                completion?(false)
            }
        self.disposeBag?.insert(disposeble)
    }
    
    func stopTimer() {
        self.disposeBag = nil
        self.disposeBag = DisposeBag()
    }
}
