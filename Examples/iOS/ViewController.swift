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
        let data1  = "fgYUE8UnMjUlnJOKrLQ6zYEph3xgC3R24m44F3wDZ5OmCOVSdPcEZzJwayag3I7nrJHPJ9zQj5ihXPqGvw26PR1uUSll3FxqQd4e7ID8MBctmSyfM6GtdEHBHxG9n5E6H3dXJABaY8ak4tp2t2J5I+sl3QlbaNQ+aU0CXRFaVqjf+4IqFdasAKwq0U4NPMCNprE7FFDqx321Lsj0bO0wyDGZQo+Z3/Hy1wMtXdXVy1clTfRKQ4OSsE6F8FkHzYEYpMOodY/dV8KvsIAap56ZZCZMleOQPv03T9ez7/WialkPv8BGjd6MVquQINYdL5boQ2wqBSP7NCIOxc8j/bdRBTAPqhq6M5E="
        let nonce1 = "000000000001530066625856"
        let publickey1 =    "df88506dd02f87d57347b3d6e0a40608bd9a48e8247376da8780c405b32c8363"
        let result =    Crypto.share.openBox(message: data1, serverPublicKey: publickey1, nonce: nonce1)
        print("result is \(result.description)")
        
        let nonce  = "000000000001529393752900"
        Crypto.initSelfKeys(privateKey: privateKey, publicKey: publicKey)
        
        let openResult  = Crypto.share.openBox(message: "RVPYRaxbplHdnFlWv7qzpZpd5TSXF+UlXgzhZqk=", serverPublicKey: "7475f1716920b52ac2057680cc80959b3ec1ec65b221724c30bca26d23b12150", nonce: "000000000001529393752900")
        print("openResult = \(openResult)")
        print("nonce str=\(nonce) , nonce byte=\(nonce.getBytes().description)")
        let sodium = Sodium()
        let keySwitch = KeySwitch()
        
        let boxResult = try!   Crypto.share.box(message: "你好,打嘴吧", serverPublicKey: "7475f1716920b52ac2057680cc80959b3ec1ec65b221724c30bca26d23b12150")
        print("boxResult msg=\(boxResult?.boxMessage), publickey =\(boxResult?.publicKey) , nonce = \(boxResult?.nonce)")
        
        
  let setPrivBoxResult =    try!  Crypto.share.boxByPrivKey(selfPrivateKey: "34336a82828afe08bc8d813f7c964155b7f1246dfe1808b0ec68758c1d3c0fb7"    , message: "aaaabbbbcccc", serverPublicKey: "df88506dd02f87d57347b3d6e0a40608bd9a48e8247376da8780c405b32c8363")
        
        print("setPrivBoxResult \(setPrivBoxResult.debugDescription)")
        
        let openSetPrivBoxResult = Crypto.share.openBoxByPrivKey(selfPrivateKey: "34336a82828afe08bc8d813f7c964155b7f1246dfe1808b0ec68758c1d3c0fb7", message: setPrivBoxResult!.boxMessage, serverPublicKey: "df88506dd02f87d57347b3d6e0a40608bd9a48e8247376da8780c405b32c8363", nonce: (setPrivBoxResult?.nonce)!)
        
        print("openSetPrivBoxResult :\(openSetPrivBoxResult)")
        createKeyPair()
        
        
    }
    @objc func createKeyPair(){
        do{
            
            let keySwitch = KeySwitch()
            let result = try     keySwitch.createKeyPair()
            
            print("privaeKey = \(result.privateKey),publicKey = \(result.publicKey) ,ipv6 =\(result.ipv6)")
            if   let switchKey =  keySwitch.private2PubKey(privateKey: result.privateKey){
                print("private to publicKey is :\(switchKey)")
            }
        }catch {
            print("have error \(error)")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

