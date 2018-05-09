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
        
        
        
        let path = Bundle.main.path(forResource: "dataLogs", ofType: "txt")
        print("the path is: " + path!)
        
        let url = URL(fileURLWithPath: path!)
        print("the url is:" )
        print(url)
        
        
        /*
         //-----------Writing data to txt file------------
         let str = "Super long string here"
         
         do {
         try str.write(to: url, atomically: true, encoding: String.Encoding.utf8)
         } catch {
         // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
         }*/
        
        
        
        
        /*----------------It could be useful for wrıtıng ınput-------
         let file: FileHandle? = FileHandle(forWritingAtPath: "dataLogs.txt")
         
         
         // Set the data we want to write
         let data = ("Silentium est aureum" as NSString).data(using: String.Encoding.utf8.rawValue)
         
         // Write it to the file
         file?.write(data!)
         
         // Close the file
         file?.closeFile()
         
         print("Ooops! Something went wrong!")
         */
        
        
        // Set the file path
        
        
        // Set the contents
        let contents = "Here are my file's contents"
        
        do {
            /*
             try contents.write(to: url, atomically: false, encoding: String.Encoding.utf8)
             */
            // Write contents to file
            try contents.write(toFile: path!, atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
        
        
        
        
        
        
        
        // -----------Read from txt file---------
        // -----------For Reaching the Data that is located in the url-----------
        let contentString = try! NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue)
        print(contentString)
        
        /* let seperatedString = contentString.components(separatedBy: ":").last!.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "}", with: "")
         
         print(seperatedString)*/
        
        
        
        
        
        
        /* -----------DENEME BAŞARILI---------
         let file = "file.txt" //this is the file. we will write to and read from it
         
         let text = "some text" //just a text
         
         if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
         
         let fileURL = dir.appendingPathComponent(file)
         
         //writing
         do {
         try text.write(to: fileURL, atomically: false, encoding: .utf8)
         }
         catch {/* error handling here */}
         
         //reading
         do {
         let text2 = try String(contentsOf: fileURL, encoding: .utf8)
         }
         catch {/* error handling here */}
         }*/
        
        /* --------DENEME 1----------
         let DocumentDirURL = url(for directory: FileManager.SearchPathDirectory,
         in domain: FileManager.SearchPathDomainMask,
         appropriateFor url: URL?,
         create shouldCreate: Bool) throws -> URL
         
         let fileName = "Test"
         let writeString = "MERHABA!"
         let desktopURL = NSURL(fileURLWithPath: "/Users/aliakdem/Desktop/")
         do {
         try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
         
         
         let temporaryDirectoryURL = try FileManager.default.url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: desktopURL as URL, create: true)
         } catch {
         // handle the error
         }
         */
        
        
        /* ---------DENEME 2-----------
         let fileName = "Test"
         var dir = try? FileManager.default.url(for: <#T##FileManager.SearchPathDirectory#>, in: <#T##FileManager.SearchPathDomainMask#>, appropriateFor: nil, create: true)
         if let fileURL = dir?.appendPathComponent(fileName).appendingPathExtension("txt"){
         
         let outString = "Write this text to the file"
         do{
         try outString.write(to: fileURL, atomically: true, encoding: .utf8)
         }catch{
         print("failed writing from URL: \(fileURL), Error: " + error.localizedDescription)
         }
         
         // Then reading it back from the file
         var inString = ""
         do {
         inString = try String(contentsOf: fileURL)
         } catch {
         print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
         }
         print("Read from the file: \(inString)")
         }
         */
        
        
        
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

