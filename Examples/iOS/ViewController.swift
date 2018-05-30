import UIKit
import Sodium
import Clibsodium

//publikey=
//alice privacekey=
var bobKeyPair:Box.KeyPair?
//var publicKey:String? = "6f99275e5c0ce6239d1cfc88bb007dd86a930a6a2da1f37386e69a9150223978"
//var privateKey:String? = "7d38745bb0c6a556f71b9ff2480b1e81ab1d18ad25a230e42bd5545e566d48e0"

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sodium = Sodium()
        print("start")
        let aliceKeyPair = sodium.box.keyPair()!
        //        if  publicKey!.isEmpty && privateKey!.isEmpty{
        //            publicKey = sodium.utils.bin2hex(aliceKeyPair.publicKey)
        //            privateKey = sodium.utils.bin2hex(aliceKeyPair.secretKey)
        //            print("publickey is nil and private key is null ")
        //        }
        
    }
    
    @IBAction func clickBtn(_ sender: Any) {
        
        
        let nonce:[UInt8] = [48,48,48,48,48,48,48,48,48,48,49,53,50,55, 53,54, 51, 48, 54, 50,51,52,55]
        //000000000001527563062347
        
        let nonceStr = nonce.toUnicodeString()
        let nonce2 = nonceStr.getBytes()
        print("nonceStr\(nonceStr)")
        
        print("nonce2 \(nonce2.description)")

        
        print("on click btn")
        let sodium = Sodium()
        bobKeyPair = sodium.box.keyPair()!
     
        let keySwitch = KeySwitch()
        let aliceKeyResult =     keySwitch.createKeyPair()
        print("alice publikey=\(aliceKeyResult.publicKey)\n alice privacekey=\(aliceKeyResult.privateKey)")
        let message = "im is andyliu"
        let  boxResult =    Crypto.share.box(message: message, serverPublicKey: base32Encode((bobKeyPair?.publicKey)!)+".k")
        
        print("Encrypted Message:\(boxResult!.boxMessage)")
        
        let messageVerifiedAndDecryptedByBob =
            Crypto.share.openBox(message: (boxResult?.boxMessage)!, serverPublicKey: (boxResult?.publicKey)!, nonce: (boxResult?.nonce)!,boboprivateKey:(bobKeyPair?.secretKey)!)
//            sodium.box.open(authenticatedCipherText: (boxResult?.boxMessage.bytes)!, senderPublicKey: (boxResult?.publicKey.bytes)!, recipientSecretKey: (bobKeyPair?.secretKey)!, nonce: (boxResult?.nonce.bytes)!)
        
        print("Decrypted Message:\((messageVerifiedAndDecryptedByBob))")
        
        
        
//        
//        let myThread = Thread(target: self,selector: #selector(ViewController.createKeyPair),object: nil)
//        myThread.start()
//        
        
        
        //       let str = "abcdefgh".bytes
        //        print("result = \(str)")
        //      let enCodeStr =   Util.base32Encode(str)
        //
        //        print("encode \(enCodeStr)")
        //
        //        try! print("decode \( Util.base32Decode(enCodeStr))")
    }
    
    @objc func createKeyPair(){
        do{
            
            let keySwitch = KeySwitch()
            let result =     keySwitch.createKeyPair()
            
            print("privaeKey = \(result.privateKey),publicKey = \(result.publicKey) ,ipv6 =\(result.ipv6)")
        }catch {
            print("have error")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

