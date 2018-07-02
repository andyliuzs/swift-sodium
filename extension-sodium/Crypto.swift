//
//  Crypto.swift
//  Sodium_iOS
//
//  Created by andyliu  on 2018/5/28.
//  Copyright © 2018年 Frank Denis. All rights reserved.
//

import Foundation
import Sodium
public class Crypto{
   private static var privateKey:String = "abcd69f81501d0c56f2948a40aa821e0536db383a06656d7b523f5828bc2c29c" //自己的私钥
   private static var  publicKey:String = "0strwpv6g8yyqu03tkxrzup0k46lujsut2ux0n53fg54hx3t43g0.k" //自己的publicKey
    public static let share = Crypto()
    
    private  init(){
        //初始化数据
        print("init crypto")
    }
    
    
    
    /// 重新设置自己的公私钥
    ///
    /// - Parameters:
    ///   - privateKey:
    ///   - publicKey: 
    public static func resetSelfKeys(privateKey:String,publicKey:String){
        self.initSelfKeys(privateKey: privateKey, publicKey: publicKey)
    }
    
    /// 初始化自己的公私钥
    ///
    /// - Parameters:
    ///   - privateKey: <#privateKey description#>
    ///   - publicKey: <#publicKey description#>
    public static func initSelfKeys(privateKey:String,publicKey:String){
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
    
    
    
    /// 获取一个新的Sodium
    ///
    /// - Returns: Sodium
    public func getNewSodium() -> Sodium {
        return Sodium()
    }
    /// 加密数据（服务器交互）
    ///
    /// - Parameters:
    ///   - message: 加密内容
    ///   - serverPublicKey: 对方公钥
    /// - Returns: 加密后数据 + 自身公钥 + nonce
    public  func box( message:String,serverPublicKey:String)throws ->(boxMessage:String,publicKey:String,nonce:String)?{
        guard !message.isEmpty  && !serverPublicKey.isEmpty else{
            return nil
        }
        
        var nonce:String?
        let sodium = Sodium()
        
        let result: (authenticatedCipherText: Bytes, nonce: Box.Nonce)? =   sodium.box.seal(message: message.bytes,
                                                                                            recipientPublicKey: sodium.utils.hex2bin(serverPublicKey)!,
                                                                                            senderSecretKey: sodium.utils.hex2bin(Crypto.privateKey)!)
        let boxMessage:String   = base64Encode((result?.authenticatedCipherText)!)

print("box nonce byte \(result?.nonce.description)")
        let nonceStr =  (result?.nonce)!.toUnicodeString()

        let mPbKey =  sodium.utils.bin2hex( try base32DecodePublicKey(Crypto.publicKey)!)!
//       let mPbKey = Crypto.publicKey
        return (boxMessage:boxMessage,publicKey:mPbKey,nonce:nonceStr)
    }
    
    /// 解密数据（服务器交互）
    ///
    /// - Parameters:
    ///   - message: 密文
    ///   - serverPublicKey: 服务器公钥
    ///   - nonce: 当前加密需要的nonce
    /// - Returns: 解㊙️完成的数据
    public  func openBox(message:String,serverPublicKey:String,nonce:String) -> String {
        let sodium = Sodium()
        let base64DencodeMsg:Bytes = base64Decode(message)!
    
        let senderPublicKey = sodium.utils.hex2bin(serverPublicKey)!
        let nonceBytes = nonce.getBytes()
        print("openBox nonce=\(nonceBytes.description)")
        let result =   sodium.box.open(authenticatedCipherText: base64DencodeMsg , senderPublicKey: senderPublicKey, recipientSecretKey: sodium.utils.hex2bin(Crypto.privateKey)!, nonce: nonceBytes)
        return result?.utf8String ?? ""
    }
    
    /// 自己本机测试 解密数据（服务器交互）
    ///
    /// - Parameters:
    ///   - message: 密文
    ///   - serverPublicKey: 服务器公钥
    ///   - nonce: 当前加密需要的nonce
    /// - Returns: 解㊙️完成的数据
    public  func openBox(message:String,serverPublicKey:String,nonce:String,selfPrivateKey:Bytes) -> String {
        let sodium = Sodium()
        let base64DencodeMsg:Bytes = base64Decode(message)!
        let senderPublicKey = sodium.utils.hex2bin(serverPublicKey)!
        let nonceBytes = nonce.getBytes()
        print("openBox nonce=\(nonceBytes.description)")
        //        let result =   sodium.box.open(authenticatedCipherText: base64DencodeMsg , senderPublicKey: senderPublicKey, recipientSecretKey: sodium.utils.hex2bin(privateKey)!, nonce: nonceBytes)
        //
        let result =   sodium.box.open(authenticatedCipherText: base64DencodeMsg , senderPublicKey: senderPublicKey, recipientSecretKey: selfPrivateKey, nonce: nonceBytes)
        return result?.utf8String ?? ""
    }
}
