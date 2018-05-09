//
//  GameViewController.swift
//  GraduationProject
//
//  Created by OMER BUKTE on 11/19/17.
//  Copyright © 2017 Omer Bukte. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit



class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createLogFile()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func createLogFile(){
        let fileName = "experimentData.txt"
        var filePath = ""
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        let dir = dirs[0]
        filePath = dir.appending("/" + fileName)
        print("Local path = \(filePath)")
        
        let fileContentToWrite = "Text to be recorded into file"
        
        do {
            try fileContentToWrite.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
        
        do {
            let contentFromFile = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
            print(contentFromFile)
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

