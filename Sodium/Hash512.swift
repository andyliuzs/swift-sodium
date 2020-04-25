

import Foundation
import Clibsodium
//
//  Hash.swift
//  Sodium_iOS
//
//  Created by andyliu  on 2018/5/21.
//  Copyright © 2018年 Frank Denis. All rights reserved.
//
public struct Hash512{
    public let hash512Bytes = Int(crypto_hash_bytes())
    
}
extension Hash512{
    private  func _sha512(message: Bytes) -> Bytes?{
        var outPut = Bytes(count: hash512Bytes)
        
        if .SUCCESS == crypto_hash_sha512(&outPut,message,CUnsignedLongLong(message.count)).exitCode {
            
        }else {
            print("guard else sha512")
            return nil
            
        }
        //  print("end sha512")
        return outPut
    }
}
extension Hash512{
    public  func sha512(message: Bytes) -> Bytes?{
        guard let result:Bytes = _sha512(message: message) else {
            print("sha512 return error")
            return nil
        }
        return result
    }
}
