//
//  GameOverRestartScene.swift
//  GraduationProject
//
//  Created by Ali Akdem on 15.01.2018.
//  Copyright © 2018 Omer Bukte. All rights reserved.
//
/*
import SpriteKit
import CoreMotion
import GameplayKit
import UIKit

class StartScene: SKScene {
    override init(size: CGSize) {
        super.init(size: size)
        print("here, you are in gameScene and game is ended!")
        // change the background of the scene to be black
        backgroundColor = SKColor.black
        
        // create a label to see game over on the screen
        let label = SKLabelNode(fontNamed: "Arial")
        label.text = "Game Over"
        label.fontSize = 80
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        backToPlay()
    }
    func backToPlay() {
        print("game again started!")
        // run a action or a sequence of actions
        run(
            // sequence of actions
            SKAction.sequence([
                // action block to run in order to presente the scene
                SKAction.run() {
                    // transition effect that seems like doors closing
                    let reveal = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                    // the game scene to present
                    if let scene = GameScene(fileNamed: "GameScene") {
                        // to best fill the screen
                        scene.scaleMode = .aspectFill
                        // present the scene
                        self.view?.presentScene(scene, transition:reveal)
                    }
                }
                ])
        )
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
*/
