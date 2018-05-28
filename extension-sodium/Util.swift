//
//  Util.swift
//  Sodium_iOS
//
//  Created by andyliu  on 2018/5/21.
//  Copyright © 2018年 Frank Denis. All rights reserved.
//

import Foundation
public class Util{
//       static let B32_CHARS:[Character] = Array("0123456789bcdfghjklmnpqrstuvwxyz")
//    static let  NUM_FOR_ASCII:[UInt8]  = [
//        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
//        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
//        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
//        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 99, 99, 99, 99, 99, 99, 99, 99, 10, 11,
//        12, 99, 13, 14, 15, 99, 16, 17, 18, 19, 20, 99, 21, 22, 23, 24, 25,
//        26, 27, 28, 29, 30, 31, 99, 99, 99, 99, 99, 99, 99, 10, 11, 12, 99,
//        13, 14, 15, 99, 16, 17, 18, 19, 20, 99, 21, 22, 23, 24, 25, 26, 27,
//        28, 29, 30, 31, 99, 99, 99, 99, 99]


//   static let B32_CHARS: [Int8] = ["0","1","2","3","4","5","6","7","8","9","b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","u","v","w","x","y","z"].map { (c: UnicodeScalar) -> Int8 in Int8(c.value) }
       static let B32_CHARS: [Character] = ["0","1","2","3","4","5","6","7","8","9","b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","u","v","w","x","y","z"]
    static let __: UInt8 = 99
//    static let  NUM_FOR_ASCII:[UInt8]  = [
//        __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __,
//        __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __,
//        __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __,
//        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, __, __, __, __, __, __, __, __, 10, 11,
//        12, __, 13, 14, 15, __, 16, 17, 18, 19, 20, __, 21, 22, 23, 24, 25,
//        26, 27, 28, 29, 30, 31, __, __, __, __, __, __, __, 10, 11, 12, __,
//        13, 14, 15, __, 16, 17, 18, 19, 20, __, 21, 22, 23, 24, 25, 26, 27,
//        28, 29, 30, 31, __, __, __, __, __]
    static let  NUM_FOR_ASCII:[UInt8] = [
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 99, 99, 99, 99, 99, 99,
    99, 99, 10, 11, 12, 99, 13, 14, 15, 99, 16, 17, 18, 19, 20, 99,
    21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 99, 99, 99, 99, 99,
    99, 99, 10, 11, 12, 99, 13, 14, 15, 99, 16, 17, 18, 19, 20, 99,
    21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 99, 99, 99, 99, 99
    ];
    public static func base32Encode(_ input:[UInt8]) ->String{
          print("base32Encode Bytes \(input)")
        var inIndex = 0;
        var outIndex = 0;
        var work = 0;
        var bits = 0;
        var output =  [Character](repeating: "0", count: (input.count * 8 / 5 + 1))
        
        while inIndex <  input.count {
            work =  work | ( Int(input[inIndex]) << bits)
            inIndex += 1
            bits +=  8
  
            while bits >= 5{
                output[outIndex] = B32_CHARS[ (work & 31) ]
                // print("\(outIndex) is \( B32_CHARS[ (work & 31) ]) work&32=\((work & 31))")
                outIndex += 1;
                bits -= 5;
                work >>= 5
            }
            
        }
        
        if bits != 0 {
            output[outIndex] = B32_CHARS[ (Int(work) & 31) ]
            outIndex += 1
            bits -= 5;
            work >>= 5;
        }
        return  String(output) + ".k";
    }
    
    
    public static func  base32Decode(_ input:String) throws -> [UInt8] {
        var outputIndex = 0;
        var inputIndex = 0;
        var bits = 0;
        var nextByte:UInt8 = 0;
        var output:[UInt8] =  [UInt8](repeating: 0, count: (input.count * 5 / 8))
        while inputIndex < input.count {
            let o:Character = input[input.index(input.startIndex, offsetBy: inputIndex)]
            if (characterToInt(o) & 128) != 0{
//                print("is bad character \(o)")
                throw DataError.DataWrongformatError("is bad character \(o)")
            }
            let b = NUM_FOR_ASCII[characterToInt(o)];
            inputIndex += 1;
            if(b > 31) {
                throw DataError.DataWrongformatError("bad character \( input[input.index(input.startIndex, offsetBy: inputIndex)]) in \(input)");
            }
            nextByte = nextByte | (b << bits)
            bits += 5
            if bits >= 8  {
                output[outputIndex] = (nextByte & 255)
                outputIndex += 1
                bits -= 8;
                nextByte >>= 8
            }
        }
        
        if(bits < 5 && nextByte == 0) {
            print("base32Decode result \(output)")
            return output;
        } else {
            throw  DataError.DataWrongformatError("bits is \(bits) = and nextByte is \(nextByte)" );
        }
    }
    
    
    private static func characterToInt(_ c:Character) -> Int{
       var intNumber = 0
        for scalar in String(c).unicodeScalars{
            //字符串只有一个字符,这个循环只会执行1次
            intNumber = Int(scalar.value)
            
        }
//        print("c is \(c) numberis \(intNumber)")
        return intNumber
    }
    
    
    
    
    
    
    
//    public static func base32Encode(_ array: [UInt8]) -> String {
//        return base32encode(array, array.count, B32_CHARS)
//    }
//    private static func base32encode(_ data: UnsafeRawPointer, _ length: Int, _ table: [Int8]) ->String{
//        if length == 0 {
//            return ""
//        }
//
//        var length = length
//
//        let bytes = data.assumingMemoryBound(to: UInt8.self)
//
//        let resultBufferSize = Int(ceil(Double(length) / 5)) * 8 + 1    // need null termination
//        let resultBuffer = UnsafeMutablePointer<Int8>.allocate(capacity: resultBufferSize)
//        var encoded = resultBuffer
//
//                    var inIndex = 0;
//                    var outIndex = 0;
//        var work:UInt8 = 0;
//                    var bits = 0;
//
//                    while inIndex < length{
//
//                        work =  work | ( (bytes[inIndex] & 255) << bits)
//                        bits = bits + 8
//                        var aaa = false
//                        while bits >= 5{
//                            if !aaa{
//                                aaa = true
//                            }else {
//                                 work >>= 5
//                            }
//
//                            encoded[outIndex] = table[ Int(work & 31) ]
//                           // print("\(outIndex) is \( B32_CHARS[ (work & 31) ]) work&32=\((work & 31))")
//                            outIndex = outIndex + 1;
//                            bits -= 5;
//                        }
//                        inIndex += 1
//                    }
//
//                    if(bits != 0) {
//                        encoded[outIndex] = table[Int(work & 31)]
//                        outIndex += 1
//                        bits -= 5;
//                        work >>= 5;
//                    }
//
//        // return
//        if let base32Encoded = String(validatingUTF8: resultBuffer) {
//            #if swift(>=4.1)
//            resultBuffer.deallocate()
//            #else
//            resultBuffer.deallocate(capacity: resultBufferSize)
//            #endif
//            return base32Encoded+".k"
//        } else {
//            #if swift(>=4.1)
//            resultBuffer.deallocate()
//            #else
//            resultBuffer.deallocate(capacity: resultBufferSize)
//            #endif
//            fatalError("internal error")
//        }
//    }
//
//    public static func base32Decode(_ string: String) -> [UInt8]? {
//        return base32decode(string, NUM_FOR_ASCII)
//    }
//    private static func  base32decode(_ string: String, _ table: [UInt8]) -> [UInt8]?  {
//        let length = string.unicodeScalars.count
//        if length == 0 {
//            return []
//        }
//
//        // Use UnsafePointer<UInt8>
//        return  string.utf8CString.withUnsafeBufferPointer {
//            (data: UnsafeBufferPointer<CChar>) -> [UInt8] in
//            let encoded = data.baseAddress!
//            var result:Bytes =  Bytes(repeating: 0, count: (length * 5 / 8))
//            var outputIndex = 0;
//            var inputIndex = 0;
//            var bits = 0;
//            var nextByte:UInt8 = 0;
//            while inputIndex < length {
//             let o =   UInt8(encoded[inputIndex])
//                if((o & 128) != 0) {
//                    print("is bad character \(o)")
//                   // throw DataError.DataWrongformatError("is bad character \(o)")
//                    return []
//                }
//
//                let b = table[Int(encoded[inputIndex])]
//                inputIndex += 1;
//                if(b > 31) {
//                   // throw DataError.DataWrongformatError("bad character \( input[input.index(input.startIndex, offsetBy: inputIndex)]) in \(input)");
//              return  []
//                }
//
//                nextByte = nextByte | (b << bits)
//                bits += 5
//                if bits >= 8  {
//                    result[outputIndex] = (nextByte & 255)
//                    outputIndex += 1
//                    bits -= 8;
//                    nextByte >>= 8
//                }
//            }
//
//            if(bits < 5 && nextByte == 0) {
//                return result;
//            } else {
////                throw  DataError.DataWrongformatError("bits is \(bits) = and nextByte is \(nextByte)" );
//                print("bits is \(bits) = and nextByte is \(nextByte)" )
//                return []
//            }
//    }
//}
    //

}
