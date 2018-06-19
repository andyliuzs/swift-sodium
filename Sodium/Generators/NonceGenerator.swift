import Foundation
import Clibsodium

protocol NonceGenerator {
    var NonceBytes: Int { get }
    associatedtype Nonce where Nonce == Bytes
}

extension NonceGenerator {
    /**
     库自带生成nonce方法
     Generates a random nonce.
     - Returns: A nonce.
     */
//    public func nonce() -> Nonce {
//        var nonce = Bytes(count: NonceBytes)
//        randombytes_buf(&nonce, NonceBytes)
//        return nonce
//    }
    
    
    /// 自定义使用时间戳当作nonce
    ///
    /// - Returns: <#return value description#>
    public func nonce() -> Nonce {
        var nonce = Bytes(count: NonceBytes)
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        var timeStep  = String(round(timeInterval*1000))
        if timeStep.hasSuffix(".0"){
          timeStep =   String( timeStep[..<timeStep.index(timeStep.endIndex, offsetBy: -2)])
        }
        let millisecond =  UInt64(timeStep)
        let nonceStr = NSString.init(format: "%024lu", millisecond!).description
        nonce = nonceStr.getBytes()
        return nonce
    }
}
