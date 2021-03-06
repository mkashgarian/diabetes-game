//
//  MenuScene.swift
//  SpriteKitGame
//
//  Created by Marina Kashgarian on 3/23/17.
//  Copyright © 2017 Marina Kashgarian. All rights reserved.
//
import SpriteKit
import UIKit

import Foundation
class MenuScene: SKScene {
    
    
    let info = SKLabelNode(fontNamed: "Chalkduster")
    let music = SKLabelNode(fontNamed: "Chalkduster")
    var l1 = SKSpriteNode(imageNamed: "level_1_button")
    var l2 = SKSpriteNode(imageNamed: "level_2_button")
    var l3 = SKSpriteNode(imageNamed: "level_3_button")
    let bg = SKSpriteNode(imageNamed: "menu_background")
    static var level = 0

    override func didMove(to view: SKView) {
        bg.size = self.frame.size
        bg.position = CGPoint(x: size.width/2, y: size.height/2)
        bg.zPosition = -1
        addChild(bg)

    }
    
    override init(size: CGSize) {
        super.init(size: size)

        l1.setScale(2)
        l1.position = CGPoint(x: size.width / 2, y: size.height * 0.6)
        addChild(l1)

        l2.setScale(2)
        l2.position = CGPoint(x: size.width / 2, y: size.height * 0.4)
        addChild(l2)
        
        l3.setScale(2)
        l3.position = CGPoint(x: size.width / 2, y: size.height * 0.2)
        addChild(l3)
        
//        info.fontColor = SKColor.white
//        info.text = "Info Tab"
//        info.fontSize = 50
//        info.position = CGPoint(x: size.width / 2, y: size.height * 0.05)
//        addChild(info)
        
        music.fontColor = SKColor.white
        music.text = "Music On/Off"
        music.fontSize = 20
        music.position = CGPoint(x: size.width * 0.13, y: size.height * 0.98)
        addChild(music)

    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        if l1.contains(touchLocation) {
            MenuScene.level = 1
        } else if l2.contains(touchLocation) {
            MenuScene.level = 2
        } else if l3.contains(touchLocation) {
            MenuScene.level = 3
        }
        if(MenuScene.level != 0) {
            let reveal = SKTransition.flipVertical(withDuration: 3)
            let scene = RoundSelect(size: self.size)
            self.view?.presentScene(scene, transition: reveal)
        }
    }
}
