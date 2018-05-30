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
    var privateKey:String = "" //自己的私钥
    var publicKey:String = "" //自己的publicKey
    public static let share = Crypto()
    
    private  init(){
        //初始化数据
        privateKey = "abcd69f81501d0c56f2948a40aa821e0536db383a06656d7b523f5828bc2c29c"
        publicKey = "0strwpv6g8yyqu03tkxrzup0k46lujsut2ux0n53fg54hx3t43g0.k"
        print("init crypto")
    }
    
    /// 加密数据（服务器交互）
    ///
    /// - Parameters:
    ///   - message: 加密内容
    ///   - serverPublicKey: 对方公钥
    /// - Returns: 加密后数据 + 自身公钥 + nonce
    public  func box( message:String,serverPublicKey:String) ->(boxMessage:String,publicKey:String,nonce:String)?{
        guard !message.isEmpty  && !serverPublicKey.isEmpty else{
            return nil
        }
        
        var nonce:String?
        let sodium = Sodium()
        
        let result: (authenticatedCipherText: Bytes, nonce: Box.Nonce)? =   sodium.box.seal(message: message.bytes,
                                                                                            recipientPublicKey: base32DecodePublicKey(serverPublicKey)!,
                                                                                            senderSecretKey: sodium.utils.hex2bin(privateKey)!)
        let boxMessage:String   = base64Encode((result?.authenticatedCipherText)!)
        
        
        let nonceStr =  (result?.nonce)!.toUnicodeString()
        return (boxMessage:boxMessage,publicKey:publicKey,nonce:nonceStr)
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
    
        let senderPublicKey = base32DecodePublicKey(serverPublicKey)!
        let nonceBytes = nonce.getBytes()
        print("openBox nonce=\(nonceBytes.description)")
        let result =   sodium.box.open(authenticatedCipherText: base64DencodeMsg , senderPublicKey: senderPublicKey, recipientSecretKey: sodium.utils.hex2bin(privateKey)!, nonce: nonceBytes)
        return result?.utf8String ?? ""
    }
    
    /// 自己本机测试 解密数据（服务器交互）
    ///
    /// - Parameters:
    ///   - message: 密文
    ///   - serverPublicKey: 服务器公钥
    ///   - nonce: 当前加密需要的nonce
    /// - Returns: 解㊙️完成的数据
    public  func openBox(message:String,serverPublicKey:String,nonce:String,boboprivateKey:Bytes) -> String {
        let sodium = Sodium()
        let base64DencodeMsg:Bytes = base64Decode(message)!
        let senderPublicKey = base32DecodePublicKey(serverPublicKey)!
        let nonceBytes = nonce.getBytes()
        print("openBox nonce=\(nonceBytes.description)")
        //        let result =   sodium.box.open(authenticatedCipherText: base64DencodeMsg , senderPublicKey: senderPublicKey, recipientSecretKey: sodium.utils.hex2bin(privateKey)!, nonce: nonceBytes)
        //
        let result =   sodium.box.open(authenticatedCipherText: base64DencodeMsg , senderPublicKey: senderPublicKey, recipientSecretKey: boboprivateKey, nonce: nonceBytes)
        return result?.utf8String ?? ""
    }
}
