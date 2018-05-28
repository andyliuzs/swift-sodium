//
//  Hash.swift
//  Sodium_iOS
//
//  Created by andyliu  on 2018/5/21.
//  Copyright © 2018年 Frank Denis. All rights reserved.
//

import Foundation
import Clibsodium
public class Hash512{
  public let Sha512Bytes = Int(crypto_hash_sha512_bytes())
    
   
    
    private let KEY_LEN:Int = 64
    private let SALTBYTES = 32
    private var buffer:Bytes = Bytes()
    
//    static let getHash512: (
//        _ pk: UnsafeMutablePointer<UInt8>,
//        _ sk: UnsafePointer<UInt8>,
//        _ count:UnsafeMutablePointer<UInt64>
//        ) -> Int32 = crypto_hash_sha512
//    public func sha512(_ outPutLength:Int,message: [UInt8]) -> [UInt8]?{
//        var outPut:[UInt8] = [UInt8](count: outPutLength)
//        guard .SUCCESS == crypto_hash_sha512(&outPut,message,UInt64(message.count)).exitCode else { return nil }
//        return outPut
//    }
//    public static func sha512_2(_ outPut:inout[UInt8],message: [UInt8]) {
//
//        if .SUCCESS == crypto_hash_sha512(&outPut,message,UInt64(message.count)).exitCode {
//             guard .SUCCESS == crypto_hash_sha512(&outPut,message,UInt64(message.count)).exitCode else {
//               outPut = []
//                return
//            }
//        }else {
//            outPut = []
//            return
//        }
//
//
//    }
    
//    public static func sha512(_ outPut:inout[UInt8],message: [UInt8]) {
//
//        print("start sha512")
//        crypto_hash_sha512(&outPut,message,UInt64(message.count))
//        print("end sha512")
//
//    }
    
    public  func _sha512(message: [UInt8]) -> Bytes?{
        guard let result:[UInt8] = sha512(message: message) else {
            print("_sha512 return error")
            return nil
        }
        return result
    }
    
    private  func sha512(message: [UInt8]) -> Bytes?{
        var outPut = Array<UInt8>(count: message.count)

        if .SUCCESS == crypto_hash_sha512(&outPut,message,CUnsignedLongLong(message.count)).exitCode {
            
        }else {
            print("guard else sha512")
            return nil

        }
      //  print("end sha512")
        return outPut
    }

   
}
