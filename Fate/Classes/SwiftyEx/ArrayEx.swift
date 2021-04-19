//
//  ArrayEx.swift
//  AppMusic
//
//  Created by 夏明伟 on 2020/12/28.
//

import Foundation

//MARK: 数组去重
/**
 let originArray = ["1","2","2","4","4","3"]
 print(originArray.deduplicates)//["1","2","4","3"]
 */

extension Array where Element: Hashable{
  public var deduplicates : [Element] {
        var keys:[Element:()] = [:]
        return filter{keys.updateValue((), forKey:$0) == nil}
    }
}

//MARK: 数组去重
/** 例子
class DemoModel: CustomStringConvertible {
    
    let name: String

    init(_ name: String) {
        self.name = name
    }
    
    var description: String {
        return name
    }
}
 
 let arrays = ["1", "2", "2", "3", "4", "4"]
 let filterArrays = arrays.filterDuplicates({$0})
 print(filterArrays)
 
 let modelArrays = [DemoModel("1"), DemoModel("1"), DemoModel("2"), DemoModel("3")]
 let filterModels = modelArrays.filterDuplicates({$0.name})
*/
public extension Array {
   public func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
    
    // 安全的取出某个下标的元素，防止数组越界
   public subscript (safe index: Int) -> Element? {
        if index >= 0 && self.count > index {
            return self[index]
        }
        return nil
    }
    
    /// “在一个逆序数组中寻找第一个满足特定条件的元素”
    public func last(where predicate: (Element) throws ->Bool) rethrows -> Element? {
        for element in reversed() where try predicate(element) {
            return element
        }
        return nil
    }
    /// “在一个正序数组中寻找第一个满足特定条件的元素”
    public func first(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        for (index,element) in enumerated() where try predicate(element) {
            return element
        }
        return nil
    }
}
