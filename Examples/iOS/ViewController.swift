import UIKit
import Sodium
import Clibsodium

//publikey=
//alice privacekey=
var bobKeyPair:Box.KeyPair?
var publicKey = "6cc9bf2913cf5611622b62c8365b9418134094b03fa59ff20e5fd085fafcd04a"
var privateKey = "b0575d0712ad1f678fcbec3ae34fdd389a86ada0778df33a3b67b113573cafe7"

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sodium = Crypto.share.getNewSodium()
        print("start")
      
    }
    
    @IBAction func clickBtn(_ sender: Any) {
        
        
        let nonce  = "000000000001529393752900"
Crypto.initSelfKeys(privateKey: privateKey, publicKey: publicKey)
        
        let openResult  = Crypto.share.openBox(message: "RVPYRaxbplHdnFlWv7qzpZpd5TSXF+UlXgzhZqk=", serverPublicKey: "7475f1716920b52ac2057680cc80959b3ec1ec65b221724c30bca26d23b12150", nonce: "000000000001529393752900")
       print("openResult = \(openResult)")
        print("nonce str=\(nonce) , nonce byte=\(nonce.getBytes().description)")
        let sodium = Sodium()
        let keySwitch = KeySwitch()
      
        let boxResult = try!   Crypto.share.box(message: "你好,打嘴吧", serverPublicKey: "7475f1716920b52ac2057680cc80959b3ec1ec65b221724c30bca26d23b12150")
    print("boxResult msg=\(boxResult?.boxMessage), publickey =\(boxResult?.publicKey) , nonce = \(boxResult?.nonce)")
    }
    @objc func createKeyPair(){
        do{
            
            let keySwitch = KeySwitch()
            let result = try     keySwitch.createKeyPair()
            
            print("privaeKey = \(result.privateKey),publicKey = \(result.publicKey) ,ipv6 =\(result.ipv6)")
        }catch {
            print("have error \(error)")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

