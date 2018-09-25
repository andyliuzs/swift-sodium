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


