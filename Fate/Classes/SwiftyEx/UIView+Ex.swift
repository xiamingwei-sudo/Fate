//
//  UIView+Ex.swift
//  Fate
//
//  Created by mile on 2021/3/23.
//

import Foundation

public extension MWFolDin where Base: NSObject {
    /// The class's name
   public class var className: String {
        return NSStringFromClass(Base.self).components(separatedBy: ".").last! as String
    }
    
    /// The class's identifier, for UITableView，UICollectionView register its cell
   public class var identifier: String {
        return String(format: "%@_identifier", className)
    }
}
