//
//  Util.swift
//  Sodium_iOS
//
//  Created by andyliu  on 2018/5/21.
//  Copyright © 2018年 Frank Denis. All rights reserved.
//

import Foundation
import  Sodium
import Clibsodium

     let B32_CHARS: [Character] = ["0","1","2","3","4","5","6","7","8","9","b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","u","v","w","x","y","z"]
 
     let  NUM_FOR_ASCII:[Int] = [
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 99, 99, 99, 99, 99, 99,
        99, 99, 10, 11, 12, 99, 13, 14, 15, 99, 16, 17, 18, 19, 20, 99,
        21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 99, 99, 99, 99, 99,
        99, 99, 10, 11, 12, 99, 13, 14, 15, 99, 16, 17, 18, 19, 20, 99,
        21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 99, 99, 99, 99, 99
    ]


    /// base32编码
    ///
    /// - Parameter input: bytes
    /// - Returns: String
    public  func base32Encode(_ input:Bytes) ->String{
        
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
        return  String(output)
    }
    


    /// base32解码
    ///
    /// - Parameter input: String
    /// - Returns: Bytes
    public  func  base32Decode(_ input:String)throws  -> Bytes {
        var outputIndex = 0;
        var inputIndex = 0;
        var bits = 0;
        var nextByte:Int = 0;
        var output:[UInt8] =  [UInt8](repeating: 0, count: (input.count * 5 / 8) )
        
        while inputIndex < input.count {
            let o:Character = input[input.index(input.startIndex, offsetBy: inputIndex)]
            let oUnicode = o.unicodeInt
            if (oUnicode & 0x80) != 0{
                fatalError("is bad character \(o)")
            }
            let b = NUM_FOR_ASCII[oUnicode];
            inputIndex += 1;
            if(b > 31) {
                fatalError("bad character \( input[input.index(input.startIndex, offsetBy: inputIndex)]) in \(input)");
            }
            nextByte = nextByte | (b << bits)
            bits += 5
            if bits >= 8  {
                output[outputIndex] = UInt8.init(truncating: (NSNumber.init(value: (nextByte & 0xff))))
                outputIndex += 1
                bits -= 8;
                nextByte >>= 8
            }
        }
        
        if(bits < 5 && nextByte == 0) {
            return output
        } else {
          fatalError("bits is \(bits) = and nextByte is \(nextByte)" );
        }
    }



/// .k格式公钥 解码
///
/// - Parameter input: publicKey
/// - Returns: Bytes
public func base32DecodePublicKey(_ input:String)throws ->Bytes?{
    var result:Bytes?
    guard !input.isEmpty else{
        return result
    }
    if(input.hasSuffix(".k")){
      result = try  base32Decode(String( input[..<input.index(input.endIndex, offsetBy: -2)]))
    }else{
        let sodium = Sodium()
      result =   sodium.utils.hex2bin(input)
    }
    return result
}


