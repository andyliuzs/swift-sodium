import UIKit
import Sodium
import Clibsodium

extension String {
    init(_ bytes: [UInt8]) {
        self.init()
        for b in bytes {
        self.append(b.description)
            
        }
    }
}
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
        
     
//
       

       
        let sodium = Sodium()
           bobKeyPair = sodium.box.keyPair()!
            let aliceKeyPair = sodium.box.keyPair()!
             print("alice publikey=\(aliceKeyPair.publicKey)\n alice privacekey=\(aliceKeyPair.secretKey)")
  
        while true {
            let decode:Bytes = [80, 152, 112, 248, 88, 102, 152, 80, 212, 24, 238, 76, 96, 92, 168, 181, 244, 176, 100, 184, 14, 96, 80, 206, 112, 45, 172, 176, 60, 120, 100, 64]
            if   let hashBuff = sodium.box._sha512(message:decode){
                print("result \(hashBuff)")
            }
 
        }
        
//        while true {
//            let message = "My Test Message".bytes;
//             print("Original Message:\(message.utf8String!)")
//            
//            let encryptedMessageFromAliceToBob: Bytes =
//                sodium.box.seal(
//                    message: message,
//                    recipientPublicKey: bobKeyPair!.publicKey,
//                    senderSecretKey: aliceKeyPair.secretKey)!
//            
//            let encryptedMessageFromAliceToBob2: Bytes =
//                sodium.box.seal(
//                    message: encryptedMessageFromAliceToBob,
//                    recipientPublicKey: bobKeyPair!.publicKey,
//                    senderSecretKey: aliceKeyPair.secretKey)!
//            print(encryptedMessageFromAliceToBob2)
//            
//
//        }

//        print("Encrypted Message:\(encryptedMessageFromAliceToBob)")
//
//        let messageVerifiedAndDecryptedByBob =
//            sodium.box.open(
//                nonceAndAuthenticatedCipherText: encryptedMessageFromAliceToBob,
//                senderPublicKey: aliceKeyPair.publicKey,
//                recipientSecretKey: (bobKeyPair?.secretKey)!)
//
//        print("Decrypted Message:\(messageVerifiedAndDecryptedByBob!.utf8String!)")


        
       
//        print("on click btn")
//        let myThread = Thread(target: self,selector: #selector(ViewController.createKeyPair),object: nil)
//        myThread.start()
//
    }
    
    @objc func createKeyPair(){
        do{
            
            let keySwitch = KeySwitch()
            keySwitch.createKeyPair()
        }catch {
            print("have error")
        }
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

