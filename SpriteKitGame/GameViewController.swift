import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    


    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = MenuScene(size: view.bounds.size)

        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    
     //   addChild(backgroundMusic)
        
        
        let soundSwitch=UISwitch();
        soundSwitch.isOn = true
        soundSwitch.setOn(true, animated: false);
       // self.addTarget(self, action: "switchValueDidChange:", for: .valueChanged);
        self.view?.addSubview(soundSwitch);
        
        

        
//        if(soundSwitch.isOn) {
//            GameScene.Sound.playSound()
//        }
//        
//        if(soundSwitch.isOn == false) {
//            GameScene.Sound.stopSound()
//        }


    }
 
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    

}
