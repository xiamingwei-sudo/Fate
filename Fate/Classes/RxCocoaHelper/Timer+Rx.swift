//
//  Timer+Rx.swift
//  Fate
//
//  Created by mile on 2021/4/16.
//

import Foundation
import RxSwift

public extension Reactive where Base: Timer {
    /// 倒计时
    /// - Parameters:
    ///   - second: 倒计时的秒数
    ///   - immediately: 是否立即开始，true 时将立即开始倒计时，false 时将在 1 秒之后开始倒计时
    ///   - duration: 倒计时的过程
    /// - Returns: 倒计时结束时的通知
    static func countdown(second: Int,
                   immediately: Bool = true,
                   duration: ((Int) -> Void)?) -> Single<Void> {
        guard second > 0 else {
            return Single<Void>.just(())
        }

        if immediately {
            duration?(second)
        }
        return Observable<Int>
            .interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .map { second - (immediately ? ($0 + 1) : $0) }
            .take(second + (immediately ? 0 : 1))
            .do(onNext: { (index) in
                duration?(index)
            })
            .filter { return $0 == 0 }
            .map { _ in return () }
            .asSingle()
     }

    static func countdownTest(second: Int,
                   immediately: Bool = true,
                   duration: ((Int) -> Void)?) -> Single<Void> {
        guard second > 0 else {
            return Single<Void>.just(())
        }

        if immediately {
            duration?(second)
        }
        return Observable<Int>
            .interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .map { second - (immediately ? ($0 + 1) : $0) }
            .take(second + (immediately ? 0 : 1))
            .do(onNext: { (index) in
                duration?(index)
            })
            .filter { return $0 == 0 }
            .map { _ in return () }
            .asSingle()
     }
}
