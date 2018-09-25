//
//  File.swift
//  Sodium_iOS
//
//  Created by andyliu  on 2018/5/29.
//  Copyright © 2018年 Frank Denis. All rights reserved.
//

import Foundation


extension Character{
    //字符转 unicode
    public  var unicodeInt: Int{
        var intNumber = 0
        for scalar in String(self).unicodeScalars{
            //字符串只有一个字符,这个循环只会执行1次
            intNumber = Int(scalar.value)
        }
        return intNumber
    }
}

extension Array where Iterator.Element == UInt8 {
    //[UInt8]转 unicode String
    public func toUnicodeString() ->String{
        var unicodeStr = ""
        for scala in self{
            unicodeStr = unicodeStr + "\(UnicodeScalar.init(scala))"
        }
        return  unicodeStr
    }
}

extension String{
    //字符串转bytes
    public func getBytes() ->Bytes{
        var str :Bytes = Bytes(repeating: 0, count: self.count)
        var i = 0
        for code in self.unicodeScalars{
            str[i] = UInt8(code.value)
            i += 1
        }
        return  str
    }
}


/// 字符串base64编码
///
/// - Parameter input:
/// - Returns:
public func _base64Encode(_ input:String)-> String?{
    let utf8EncodeData = input.data(using: String.Encoding.utf8, allowLossyConversion: true)
    // 将NSData进行Base64编码
    let base64String = utf8EncodeData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
  return base64String
}

/// 字符串base64解码
///
/// - Parameter base64String:
/// - Returns:
public func _base64Decode(_ base64String:String)-> String?{
    // 将base64字符串转换成NSData
    let base64Data = NSData(base64Encoded:base64String, options:NSData.Base64DecodingOptions(rawValue: 0))
    // 对NSData数据进行UTF8解码
    let stringWithDecode = NSString(data:base64Data! as Data, encoding:String.Encoding.utf8.rawValue)?.description
   return stringWithDecode
}



/// base64编码 Bytes to String
///
/// - Parameter input: <#input description#>
/// - Returns: <#return value description#>
public func _base64Encode(_ input:Bytes) ->String{
    let utf8EncodeData = Data.init(bytes: input)
    // 将NSData进行Base64编码
    let base64String = utf8EncodeData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
    return base64String
}


/// base64解码 String to Bytes
///
/// - Parameter input: <#input description#>
/// - Returns: <#return value description#>
public func _base64Decode(_ input:String) ->Bytes?{
    if let nsdata = NSData(base64Encoded: input, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
        var bytes = [UInt8](repeating: 0, count: nsdata.length)
        nsdata.getBytes(&bytes)
        return bytes
    }
    return nil // Invalid input
}

