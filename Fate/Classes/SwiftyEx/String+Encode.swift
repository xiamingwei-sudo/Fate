//
//  String+Encode.swift
//  first
//
//  Created by 夏明伟 on 2020/12/1.
//

import Foundation
import CommonCrypto

enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512

    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }

    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

public extension String {
    func UGSHA256() -> String {
        guard self.count > 0 else { return "" }
        guard let data = self.data(using: .utf8) else { return "" }
        var digest = [UInt8](repeating: 0, count: Int(CryptoAlgorithm.SHA256.digestLength))
        let newData = NSData(data: data)
        CC_SHA256(newData.bytes, CC_LONG(data.count), &digest)
        let output = NSMutableString(capacity: Int(CryptoAlgorithm.SHA256.digestLength))
        for byte in digest {
            output.appendFormat("%02x", byte)
        }
        return output as String
    }
    
    func md5LowString() -> String {
        guard let cStr = self.cString(using: .utf8) else {
            print("string 不能为空:\(self)")
            return ""
        }
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CryptoAlgorithm.MD5.digestLength))
        CC_MD5(cStr, CC_LONG(strlen(cStr)), buffer)
        let md5String = NSMutableString()
        for i in 0 ..< Int(CryptoAlgorithm.MD5.digestLength){
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
    
    func base64String() -> String {
        guard let data = self.data(using: .utf8) else {
            print("string 不能为空:\(self)")
            return ""
        }
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    func base64Decode() -> String {
        guard let data = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0)) else {
            print("string 不能为空:\(self)")
            return ""
        }
        let decodeString = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
        return decodeString
    }
}
