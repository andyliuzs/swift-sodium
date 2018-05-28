//
//  KeySwitchUtils.swift
//  Sodium_iOS
//
//  Created by andyliu  on 2018/5/21.
//  Copyright © 2018年 Frank Denis. All rights reserved.
//

import Foundation
import Clibsodium
import  Sodium
public class KeySwitch:NSObject{
  
    
  
     public func createKeyPair() -> [String:String]{
        
        var result:[String:String] = [:]
         let sodium = Sodium()
        do{
                while(true) {
                   
                    let keyPair = sodium.box.keyPair()
                   let     privateKey = sodium.utils.bin2hex((keyPair?.secretKey)!)
                    let    publicKey = Util.base32Encode((keyPair?.publicKey)!)
        //                     publicKey = base32Encode((keyPair?.publicKey)!)+".k"
                         print("private key="+privateKey!)
                        let  ipv6 = try publicKey2Ipv6(publicKey:publicKey)
                        print("ipv6 key="+ipv6)
                        if  checkIpv6(ipv6: ipv6){
                            print("checkok")
                           result   = [String:String]()
                            result["privateKey"] = privateKey!
                            result["publicKey"] = publicKey
                            result["ipv6"] = ipv6
                            break
                        }
                    
                }
        }catch DataError.DataWrongformatError(let e1){
            print("have dataWrongFormat error is \(e1)")
        }catch DataError.EmptyError( let e2){
            print("have error is empty \(e2)")
        }catch {
            // Catch any other errors
            print("createKeyPair have other error")
        }
        guard result.keys.count > 0 else{
            return [:]
        }
        return result
    }
    

      func  publicKey2Ipv6(publicKey:String)throws -> String{
//        guard  !publicKey.isEmpty else{
//            print("publicKey2Ipv6 publickKey is empty")
//            throw DataError.EmptyError("publicKey2Ipv6 publickKey is empty")
//        }
//        let sodium = Sodium()
//        var  ipv6:String = ""
        let sodium = Sodium()
        do{
//            print("publickey.k = "+publicKey)
////             Thread.sleep(forTimeInterval: 3.1)
//           print("thread name\(Thread.current.hash)")
//            let subString = String( publicKey[..<publicKey.index(publicKey.endIndex, offsetBy: -2)])
          //  let decode = try  Util.base32Decode(subString)
//            let decode = base32Decode(subString)!
            
            
            
//            let decode:[UInt8] = [80, 152, 112, 248, 88, 102, 152, 80, 212, 24, 238, 76, 96, 92, 168, 181, 244, 176, 100, 184, 14, 96, 80, 206, 112, 45, 172, 176, 60, 120, 100, 64]
//
//            let hashBuff  = sodium.hash512._sha512(message: decode)!
//            let buff2 = sodium.hash512._sha512(message: hashBuff)!
//
            
            let sodium = Sodium()
          let decode:[UInt8] = [80, 152, 112, 248, 88, 102, 152, 80, 212, 24, 238, 76, 96, 92, 168, 181, 244, 176, 100, 184, 14, 96, 80, 206, 112, 45, 172, 176, 60, 120, 100, 64]
            let h = sodium.genericHash.hash(message: decode)
            print("hash result = \(h)")
            //let  result = sodium.utils.bin2hex(buff2)
        
//            var outPut1 = [UInt8](repeating: 0, count: decode.count)
//            Hash.sha512(&outPut1,message: decode)
//            var outPut2 = [UInt8](repeating: 0, count: outPut1.count)
//            Hash.sha512(&outPut2,message: outPut1)
//            let  result = sodium.utils.bin2hex(outPut2)
            
//            for  i in 0..<8 {
//                let start = result!.index(result!.startIndex, offsetBy: i * 4)
//
//                let end = result!.index(result!.startIndex, offsetBy:  i * 4 + 4)
//              let subIpStr = (String(result![ start..<end]))
//                print("ipv6 subIpStr=\(subIpStr)")
//                ipv6 = ipv6 + subIpStr
//                if i != 7 {
//                    ipv6 = ipv6 + ":"
//                }
//            }
        }catch{
            print("eeeeeeerrroooorr")
        }
   
//        return ipv6
        return "";
    }
    
      func checkIpv6(ipv6:String) -> Bool{
        guard  !ipv6.isEmpty else{
           print("check ipv6 is empty return false")
            return false
        }
//        let regex = "^fb[0-9a-f]{2}:[0-9a-f:]+$"
//        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
//        return predicate.evaluate(with: ipv6)
        return ipv6.starts(with: "fb")
    }
    
}
