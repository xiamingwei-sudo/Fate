//
//  String+Ex.swift
//  CUExChangeGW
//
//  Created by mile on 2021/1/22.
//

import Foundation


public extension String {
    /// String's length
    var cu_length: Int {
        return self.count
    }
    
    /**
     Calculate the size of string, and limit the width
     
     - parameter width: width
     - parameter font:     font
     
     - returns: size value
     */
    func cu_sizeWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let size: CGSize = self.boundingRect(
            with: constraintRect,
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
            ).size
        return size
    }
    
    /**
     Calculate the height of string, and limit the width
     
     - parameter width: width
     - parameter font:  font
     
     - returns: height value
     */
    func cu_heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil)
        return boundingBox.height
    }
    
    /**
     Calculate the width of string with current font size.
     
     - parameter font:  font
     
     - returns: height value
     */
    func cu_widthWithCurrentFont(_ font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: font.pointSize)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil)
        return boundingBox.width
    }
    
    /**
     NSRange to Range<String.Index>
     http://stackoverflow.com/questions/25138339/nsrange-to-rangestring-index
     
     - parameter range: Range
     
     - returns: NSRange
     */
    
    func cu_NSRange(fromRange range: Range<Index>) -> NSRange {
        let from = range.lowerBound
        let to = range.upperBound
        
        let location = self.distance(from: startIndex, to: from)
        let length = self.distance(from: from, to: to)
        
        return NSRange(location: location, length: length)
    }
    
    /**
     Range<String.Index> to NSRange
     http://stackoverflow.com/questions/25138339/nsrange-to-rangestring-index
    
     - parameter nsRange: The NSRange
    
     - returns: Range<String.Index>
    */
    func cu_Range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    func cu_urlEncode() -> String {
        return  self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    
    func substring(string str: String) -> String {
        let strTemp: NSString = self as NSString
        let range: NSRange = strTemp.range(of: str)
        if range.location != nil && self.count > range.length {
            return strTemp.substring(from: (range.location + range.length))
        }
        return self
    }
    
}
