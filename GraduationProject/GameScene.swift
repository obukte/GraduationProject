//
//  GameScene.swift
//  GraduationProject
//
//  Created by OMER BUKTE on 11/19/17.
//  Copyright © 2017 Omer Bukte. All rights reserved.
//

import SpriteKit
import CoreMotion
import GameplayKit
import UIKit

class GameScene: SKScene {
    
    var ball: SKSpriteNode!
    var manager: CMMotionManager?
    var timer: Timer?
    var seconds: Double?
    //var frictionMap: [[[Double]]]  = [[[0.0]],[[0.0]],[[0.0]]]//i,j,friction.
    
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    let deviceHeight = 1334.0
    let deviceWidth = 750.0
    
    func logPixelsOf(_ image: UIImage) {
        /* override init() {
         setFriction(#imageLiteral(resourceName: "friction"))
         }
         
         required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
         }*/
        print("1")
        // 1. Get pixels of image
        let inputCGImage = image.cgImage
        let width: Int = (inputCGImage?.width)!
        let height: Int = (inputCGImage?.height)!
        let bytesPerPixel: Int = 4
        let bytesPerRow: Int = bytesPerPixel * width
        let bitsPerComponent: Int = 8
        let pixels = UnsafeMutablePointer<UInt32>.allocate(capacity: (width * height))
        let bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixels, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        context?.draw(inputCGImage!, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        
        func Mask8(x: Int) -> Int {
            return (x & 0xff)
        }
        func R(x: Int) -> Int {
            return Mask8(x: x)
        }
        func G(x: Int) -> Int {
            return (Mask8(x: x >> 8))
        }
        func B(x: Int) -> Int {
            return (Mask8(x: x >> 16))
        }
        func A(x: Int) -> Int {
            return (Mask8(x: x >> 24))
        }
        
        var currentPixel = pixels
        let pixelWidth = (750.0/Float(width))
        print(width)
        print(height)
        let pixelHeight = (1334.0/Float(height))
        print(CGFloat(pixelWidth))
        for j in 0..<height {
            for i in 0..<width {
                let color = currentPixel.pointee.hashValue
                let alpha = A(x: color)
                if (R(x: color) == 0){
                    let size = CGSize(width: CGFloat(pixelWidth), height: CGFloat(pixelHeight))
                    var pixel: SKSpriteNode!
                    pixel = SKSpriteNode.init(color: UIColor(red:CGFloat(R(x: color)), green:CGFloat(G(x: color)), blue:CGFloat(B(x: color)), alpha:CGFloat(alpha)), size: size)
                    pixel.physicsBody = SKPhysicsBody(rectangleOf: size)
                    pixel.physicsBody?.pinned = true
                    pixel.physicsBody?.isDynamic = false
                    pixel.physicsBody?.affectedByGravity = false
                    pixel.physicsBody?.allowsRotation = false
                    pixel.position = CGPoint(x: (CGFloat(i)*CGFloat(pixelWidth)-CGFloat(375.0)), y: (CGFloat(j)*CGFloat(pixelHeight)-CGFloat(667.0)))
                    addChild(pixel)
                }
                currentPixel += 1
            }
        }
        
    }
    
    func setFriction(_ image: UIImage) {
        
        //https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Subscripts.html   alındı.
        struct Matrix {
            let rows: Int, columns: Int
            var grid: [Double]
            init(rows: Int, columns: Int) {
                self.rows = rows
                self.columns = columns
                grid = Array(repeating: 0.0, count: rows * columns)
            }
            func indexIsValid(row: Int, column: Int) -> Bool {
                return row >= 0 && row < rows && column >= 0 && column < columns
            }
            subscript(row: Int, column: Int) -> Double {
                get {
                    assert(indexIsValid(row: row, column: column), "Index out of range")
                    return grid[(row * columns) + column]
                }
                set {
                    assert(indexIsValid(row: row, column: column), "Index out of range")
                    grid[(row * columns) + column] = newValue
                }
            }
        }
        var matrix = Matrix(rows: 750, columns: 1334)
        
        
        
        
        
        
        
        print("2")
        //var friction = frictionMap[Int(ball.position.x)][Int(ball.position.y)]
        
        // 1. Get pixels of image
        let inputCGImage = image.cgImage
        let width: Int = (inputCGImage?.width)!
        let height: Int = (inputCGImage?.height)!
        let bytesPerPixel: Int = 4
        let bytesPerRow: Int = bytesPerPixel * width
        let bitsPerComponent: Int = 8
        let pixels = UnsafeMutablePointer<UInt32>.allocate(capacity: (width * height))
        let bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixels, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        context?.draw(inputCGImage!, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        
        func Mask8(x: Int) -> Int {
            return (x & 0xff)
        }
        func R(x: Int) -> Int {
            return Mask8(x: x)
        }
        func G(x: Int) -> Int {
            return (Mask8(x: x >> 8))
        }
        func B(x: Int) -> Int {
            return (Mask8(x: x >> 16))
        }
        func A(x: Int) -> Int {
            return (Mask8(x: x >> 24))
        }
        
        var currentPixel = pixels
        for j in 0..<height {// y coordinate
            for i in 0..<width {// x coordinate
                //var friction: [Double] = [0.0]
                let color = currentPixel.pointee.hashValue
                let alpha = A(x: color)
                if (alpha == 0){
                    //friction = [0.5]
                    matrix[i,j] = 0.5
                }else if (alpha <= 20 ){
                    matrix[i,j] = 0.9
                    //frictionMap[i][j] = 0.9
                }else if (alpha <= 50 ){
                    matrix[i,j] = 0.8
                    //frictionMap[i][j] = 0.8
                }else if (alpha <= 100 ){
                    matrix[i,j] = 0.7
                    //frictionMap[i][j] = 0.7
                }else if (alpha <= 200 ){
                    matrix[i,j] = 0.3
                    //frictionMap[i][j] = 0.3
                }
                //var temp = frictionMap[i][j][friction]
                currentPixel += 1
                //print("currentPixel: ",currentPixel, "alpha:" ,alpha, "frictionMap:" ,matrix, "i:" ,i, "j:" ,j)
            }
        }
        print("frictionMap:" ,matrix)
    }
    
    
    override func didMove(to view: SKView) {
        print("3")
        logPixelsOf(#imageLiteral(resourceName: "obstaclex4"))
        setFriction(#imageLiteral(resourceName: "friction"))
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(GameScene.increaseTimer), userInfo: nil, repeats: true)
        
        
        physicsWorld.contactDelegate = self as? SKPhysicsContactDelegate
        
        ball = SKSpriteNode(imageNamed: "Ball")
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.height / 2.0)
        ball.physicsBody?.mass = 4.5
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.isDynamic = true // necessary to detect collision
        ball.physicsBody?.affectedByGravity = false
        addChild(ball)
        
        manager = CMMotionManager()
        if let manager = manager, manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.01
            manager.startDeviceMotionUpdates()
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        print("4")
        if let gravityX = manager?.deviceMotion?.gravity.x, let gravityY = manager?.deviceMotion?.gravity.y, ball != nil {
            /* 18.12.2017 Faris Commented
             let friction = frictionMap[Int(ball.position.x)][Int(ball.position.y)]
             */
            
            // let newPosition = CGPoint(x: Double(ball.position.x) + gravityX * 35.0, y: Double(ball.position.y) + gravityY * 35.0)
            // let moveAction = SKAction.moveTo(newPosition, duration: 0.0)
            // ball.runAction(moveAction)
            
            // applyImpulse() is much better than applyForce()
            // ball.physicsBody?.applyForce(CGVector(dx: CGFloat(gravityX) * 5000.0, dy: CGFloat(gravityY) * 5000.0))
            
            
            // var friction = frictionMap[Int(ball.position.x)][Int(ball.position.y)]
            /* 18.12.2017 Faris Commented
             ball.physicsBody?.applyImpulse(CGVector(dx: CGFloat(gravityX) * 200.0 * CGFloat(friction), dy: CGFloat(gravityY) * 200.0 * CGFloat(friction)))
             */
        }
    }
    
    func centerBall() {
        print("5")
        ball.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        let moveAction = SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY), duration: 0.0)
        ball.run(moveAction)
    }
    
    // MARK: - Timer Methods
    
    @objc func increaseTimer() {
        print("6")
        seconds = (seconds ?? 0.0) + 0.01
    }
    
    func resetTimer() {
        print("7")
        seconds = 0.0
    }
    
}


