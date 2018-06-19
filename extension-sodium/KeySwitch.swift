//
//  KeySwitchUtils.swift
//  Sodium_iOS
//
//  Created by andyliu  on 2018/5/21.
//  Copyright © 2018年 Frank Denis. All rights reserved.
//

import Foundation
import  Sodium
import Clibsodium
public class KeySwitch:NSObject{
    
    public override init() {
        super.init()
    }
    /// 公钥转 ipv6
    ///
    /// - Parameter publicKey: <#publicKey description#>
    /// - Returns: <#return value description#>
    public func  publicKey2Ipv6(publicKey:String) throws -> String {
        guard  !publicKey.isEmpty else{
            print("publicKey2Ipv6 publickKey is empty")
            return ""
        }
        var  ipv6:String = ""
        let sodium = Sodium()
        
        let subString = String( publicKey[..<publicKey.index(publicKey.endIndex, offsetBy: -2)])
        let decode = try base32Decode(subString)
        let hashBuff = sodium.hash512.sha512(message: decode)!
        let  result = sodium.utils.bin2hex(sodium.hash512.sha512(message: hashBuff)!)
        for  i in 0..<8 {
            let start = result!.index(result!.startIndex, offsetBy: i * 4)
            let end = result!.index(result!.startIndex, offsetBy:  i * 4 + 4)
            let subIpStr = (String(result![ start..<end]))
            ipv6 = ipv6 + subIpStr
            if i != 7 {
                ipv6 = ipv6 + ":"
            }
        }
        
        
        return ipv6
        
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
    
    
    /// 创建公私钥
    ///
    /// - Returns: 公钥，私钥，ipv6
    public func createKeyPair()throws -> (privateKey:String,publicKey:String,ipv6:String){
        var privateKey:String?
        var publicKey:String?
        var ipv6:String?
        let sodium = Sodium()
        do{
            while(true) {
                
                let keyPair = sodium.box.keyPair()
                privateKey = sodium.utils.bin2hex((keyPair?.secretKey)!)
                publicKey = base32Encode((keyPair?.publicKey)!) + ".k"
                
                ipv6 = try?  publicKey2Ipv6(publicKey:publicKey!)
                if  checkIpv6(ipv6: ipv6!){
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
        return (privateKey ?? "",publicKey ?? "",ipv6 ?? "")
    }
    
    
    
}
