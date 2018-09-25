import Foundation
import Clibsodium

public class Utils {
    /**
     Tries to effectively zero bytes in `data`, even if optimizations are being applied to the code.

     - Parameter data: The `Bytes` object to zero.
     */
    public func zero(_ data: inout Bytes)  {
        let count = data.count
        sodium_memzero(&data, count)
    }

    /**
     Checks that two `Bytes` objects have the same content, without leaking information
     about the actual content of these objects.

     - Parameter b1: first object
     - Parameter b2: second object

     - Returns: `true` if the bytes in `b1` match the bytes in `b2`. Otherwise, it returns false.
     */
    public func equals(_ b1: Bytes, _ b2: Bytes) -> Bool {
        guard b1.count == b2.count else {
            return false
        }
        return .SUCCESS == sodium_memcmp(b1, b2, b1.count).exitCode
    }

    /**
     Compares two `Bytes` objects without leaking information about the content of these objects.

     - Returns: `0` if the bytes in `b1` match the bytes in `b2`.
     `-1` if `b2` is less than `b1` (considered as little-endian values) and
     `1`  if `b1` is less than `b2` (considered as little-endian values)
     */
    public func compare(_ b1: Bytes, _ b2: Bytes) -> Int? {
        guard b1.count == b2.count else { return nil }
        return Int(sodium_compare(b1, b2, b1.count))
    }

    /**
     Converts bytes stored in `bin` into a hexadecimal string.

     - Parameter bin: The data to encode as hexdecimal.

     - Returns: The encoded hexdecimal string.
     */
    public func bin2hex(_ bin: Bytes) -> String? {
        let hexBytesLen = bin.count * 2 + 1
        var hexBytes = Bytes(count: hexBytesLen).map(Int8.init)

        guard sodium_bin2hex(&hexBytes, hexBytesLen, bin, bin.count) != nil else {
            return nil
        }

        return String(validatingUTF8: hexBytes)
    }

    /**
     Decodes a hexdecimal string, ignoring characters included for readability.

     - Parameter hex: The hexdecimal string to decode.
     - Parameter ignore: Optional string containing readability characters to ignore during decoding.

     - Returns: The decoded data.
     */
    public func hex2bin(_ hex: String, ignore: String? = nil) -> Bytes? {
        let hexBytes = Bytes(hex.utf8)
        let hexBytesLen = hexBytes.count
        let binBytesCapacity = hexBytesLen / 2
        var binBytes = Bytes(count: binBytesCapacity)
        var binBytesLen: size_t = 0
        let ignore_nsstr = ignore.flatMap({ NSString(string: $0) })
        let ignore_cstr = ignore_nsstr?.cString(using: String.Encoding.isoLatin1.rawValue)

        guard .SUCCESS == sodium_hex2bin(
            &binBytes, binBytesCapacity,
            hex, hexBytesLen,
            ignore_cstr, &binBytesLen, nil
        ).exitCode else { return nil }

        binBytes = binBytes[..<binBytesLen].bytes

        return binBytes
    }

    public enum Base64Variant: CInt {
        case ORIGINAL            = 1
        case ORIGINAL_NO_PADDING = 3
        case URLSAFE             = 5
        case URLSAFE_NO_PADDING  = 7
    }

    /**
     Converts bytes stored in `bin` into a Base64 representation.

     - Parameter bin: The data to encode as Base64.
     - Parameter variant: the Base64 variant to use. By default: URLSAFE.

     - Returns: The encoded base64 string.
     */
    public func bin2base64(_ bin: Bytes, variant: Base64Variant = .URLSAFE) -> String? {
        let b64BytesLen = sodium_base64_encoded_len(bin.count, variant.rawValue)
        var b64Bytes = Bytes(count: b64BytesLen).map(Int8.init)

        guard sodium_bin2base64(&b64Bytes, b64BytesLen, bin, bin.count, variant.rawValue) != nil else {
            return nil
        }
        return String(validatingUTF8: b64Bytes)
    }

    /*
     Decodes a Base64 string, ignoring characters included for readability.

     - Parameter b64: The Base64 string to decode.
     - Parameter ignore: Optional string containing readability characters to ignore during decoding.

     - Returns: The decoded data.
     */
    public func base642bin(_ b64: String, variant: Base64Variant = .URLSAFE, ignore: String? = nil) -> Bytes? {
        let b64Bytes = Bytes(b64.utf8).map(Int8.init)
        let b64BytesLen = b64Bytes.count
        let binBytesCapacity = b64BytesLen * 3 / 4 + 1
        var binBytes = Bytes(count: binBytesCapacity)
        var binBytesLen: size_t = 0
        let ignore_nsstr = ignore.flatMap({ NSString(string: $0) })
        let ignore_cstr = ignore_nsstr?.cString(using: String.Encoding.isoLatin1.rawValue)

        guard .SUCCESS == sodium_base642bin(
            &binBytes, binBytesCapacity,
            b64Bytes, b64BytesLen,
            ignore_cstr, &binBytesLen,
            nil,
            variant.rawValue
        ).exitCode else { return nil }

        binBytes = binBytes[..<binBytesLen].bytes

        return binBytes
    }

    /*
     Adds padding to `data` so that its length becomes a multiple of `blockSize`

     - Parameter data: input/output buffer, will be modified in-place
     - Parameter blocksize: the block size
     */
    public func pad(data bytes: inout Bytes, blockSize: Int) -> ()? {
        // we must use Data and not Bytes because we need to increase the
        // count size before passing to `sodium_pad` without initilising bytes
        var data = Data(bytes)
        let dataCount = data.count
        data.reserveCapacity(dataCount + blockSize)
        data.count = dataCount + blockSize
        var paddedLen: size_t = 0
        guard .SUCCESS == data.withUnsafeMutableBytes({
            dataPtr in sodium_pad(
                &paddedLen,
                dataPtr, dataCount,
                blockSize,
                dataCount + blockSize
            ).exitCode
        }) else { return nil }

        data.count = paddedLen

        // return the new bytes by argument
        bytes = Bytes(data)
        return ()
    }

    /*
     Removes padding from `data` to restore its original size

     - Parameter data: input/output buffer, will be modified in-place
     - Parameter blocksize: the block size
     */
    public func unpad(bytes: inout Bytes, blockSize: Int) -> ()? {
        var unpaddedLen: size_t = 0
        let bytesLen = bytes.count
        guard .SUCCESS == sodium_unpad(
            &unpaddedLen,
            bytes, bytesLen,
            blockSize
        ).exitCode else { return nil }

        bytes = bytes[..<unpaddedLen].bytes

        return ()
    }
    
    
    /// 字符串base64编码
    ///
    /// - Parameter input:
    /// - Returns:
    public func base64Encode(_ input:String)-> String?{
        let utf8EncodeData = input.data(using: String.Encoding.utf8, allowLossyConversion: true)
        // 将NSData进行Base64编码
        let base64String = utf8EncodeData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
        return base64String
    }
    
    /// 字符串base64解码
    ///
    /// - Parameter base64String:
    /// - Returns:
    public func base64Decode(_ base64String:String)-> String?{
        // 将base64字符串转换成NSData
        let base64Data = NSData(base64Encoded:base64String, options:NSData.Base64DecodingOptions(rawValue: 0))
        // 对NSData数据进行UTF8解码
        let stringWithDecode = NSString(data:base64Data! as Data, encoding:String.Encoding.utf8.rawValue)?.description
        return stringWithDecode
    }
    
    
    
    /// base64编码 Bytes to String
    ///
    /// - Parameter input: <#input description#>
    /// - Returns: <#return value description#>
    public func base64B2SEncode(_ input:Bytes) ->String{
        let utf8EncodeData = Data.init(bytes: input)
        // 将NSData进行Base64编码
        let base64String = utf8EncodeData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
        return base64String
    }
    
    
    /// base64解码 String to Bytes
    ///
    /// - Parameter input: <#input description#>
    /// - Returns: <#return value description#>
    public func base64S2BDecode(_ input:String) ->Bytes?{
        if let nsdata = NSData(base64Encoded: input, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
            var bytes = [UInt8](repeating: 0, count: nsdata.length)
            nsdata.getBytes(&bytes)
            return bytes
        }
        return nil // Invalid input
    }
}
