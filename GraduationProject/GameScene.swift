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
    var velocityX = CGFloat(0.0)
    var velocityY = CGFloat(0.0)
    
    let maxVelocity = CGFloat(50.0)
    
    var frictionMap = [[Double]](repeating: [Double](repeating: 0.0, count: 1334), count: 750)
    var heightMap = [[Int]](repeating: [Int](repeating: 0, count: 1334), count: 750)
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    let deviceHeight = 1334.0
    let deviceWidth = 750.0
    
    func logPixelsOf(_ image: UIImage) {
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
        
        print("2")
        
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
                let color = currentPixel.pointee.hashValue
                let red = R(x: color)
                let green = G(x: color)
                let blue = B(x: color)
                let alpha = A(x: color)
                if (red < 150 ){
                    frictionMap[i][j] = 0.02
                }else if (red > 230 && red < 250  ){
                    frictionMap[i][j] = 0.03
                }else if (red > 250 && alpha == 255 ){
                    frictionMap[i][j] = 0.04
                }else if (red == 255 &&  alpha == 255){
                    frictionMap[i][j] = 1.0
                }else {
                    frictionMap[i][j] = 1.0
                }
                currentPixel += 1
                //print("currentPixel: ",currentPixel, "alpha:" ,alpha, "frictionMap:" ,matrix, "i:" ,i, "j:" ,j)
            }
        }
        //        print("frictionMap:" ,frictionMap)
    }
    
    //    func setHeight(_ image: UIImage) {
    //
    //        let inputCGImage = image.cgImage
    //        let width: Int = (inputCGImage?.width)!
    //        let height: Int = (inputCGImage?.height)!
    //        let bytesPerPixel: Int = 4
    //        let bytesPerRow: Int = bytesPerPixel * width
    //        let bitsPerComponent: Int = 8
    //        let pixels = UnsafeMutablePointer<UInt32>.allocate(capacity: (width * height))
    //        let bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
    //        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
    //        let context = CGContext(data: pixels, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
    //        context?.draw(inputCGImage!, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
    //
    //        func Mask8(x: Int) -> Int {
    //            return (x & 0xff)
    //        }
    //        func R(x: Int) -> Int {
    //            return Mask8(x: x)
    //        }
    //        func G(x: Int) -> Int {
    //            return (Mask8(x: x >> 8))
    //        }
    //        func B(x: Int) -> Int {
    //            return (Mask8(x: x >> 16))
    //        }
    //        func A(x: Int) -> Int {
    //            return (Mask8(x: x >> 24))
    //        }
    //
    //        var currentPixel = pixels
    //        for j in 0..<height {// y coordinate
    //            for i in 0..<width {// x coordinate
    //                let color = currentPixel.pointee.hashValue
    //                let red = R(x: color)
    //                let green = G(x: color)
    //                let blue = B(x: color)
    //                let alpha = A(x: color)
    //                if (blue < 10 ){
    //                    heightMap[i][j] = 10
    //                }else if (blue > 10 && blue < 20  ){
    //                    heightMap[i][j] = 9
    //                }else if (blue > 20 && blue < 30  ){
    //                    heightMap[i][j] = 8
    //                }else if (blue > 30 &&  blue < 40){
    //                    heightMap[i][j] = 7
    //                }else if (blue > 40 &&  blue < 50){
    //                    heightMap[i][j] = 6
    //                }else if (blue > 50 &&  blue < 60){
    //                    heightMap[i][j] = 5
    //                }else if (blue > 60 &&  blue < 70){
    //                    heightMap[i][j] = 4
    //                }else if (blue > 70 &&  blue < 80){
    //                    heightMap[i][j] = 3
    //                }else if (blue > 80 &&  blue < 90){
    //                    heightMap[i][j] = 2
    //                }else if (blue > 90 &&  blue < 100){
    //                    heightMap[i][j] = 1
    //                }else {
    //                    heightMap[i][j] = 0
    //                }
    //                currentPixel += 1
    //            }
    //        }
    //
    //
    //        //20.12.2017
    //        var currentBallPositionX = ball.position.x
    //        var backBallPositionX = ball.position.x-1
    //        var nextBallPositionX = ball.position.x+1
    //
    //        var currentBallPositionY = ball.position.y
    //        var backBallPositionY = ball.position.y-1
    //        var nextBallPositionY = ball.position.y+1
    //
    //        let heightOfPos = heightMap[Int(ball.position.x) + 375][Int(ball.position.y) + 667]
    //        var x: Int?
    //        var y: Int?
    //        var heightDifference: Int?
    //        var comparedDifference = 0
    //
    //        for i in 0...2{
    //            for j in 0...2{
    //                if(i != 1 && j != 1 ){
    //                    let nextHeight = heightMap[i-1][j-1]// [x-1][y-1], [x-1][y+1], [x+1][y-1], [x+1][y+1]
    //                    heightDifference = heightOfPos - nextHeight
    //
    //                    if(heightDifference! > comparedDifference){
    //
    //                        x = i-1
    //                        y = j-1
    //                        comparedDifference = heightDifference!
    //                        //velocity
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    
    
    override func didMove(to view: SKView) {
        print("3")
        logPixelsOf(#imageLiteral(resourceName: "obstaclex4"))
        setFriction(#imageLiteral(resourceName: "NewFrictionMap"))
        //        setHeight(#imageLiteral(resourceName: "HeightMap"))
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(GameScene.increaseTimer), userInfo: nil, repeats: true)
        
        
        physicsWorld.contactDelegate = self as? SKPhysicsContactDelegate
        
        ball = SKSpriteNode(imageNamed: "Ball")
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.height / 2.0)
        ball.physicsBody?.mass = 1.0
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.isDynamic = true // necessary to detect collision
        ball.physicsBody?.affectedByGravity = false
        addChild(ball)
        
        manager = CMMotionManager()
        if let manager = manager, manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.001
            manager.startDeviceMotionUpdates()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        //bu neden if içinde?
        if let gravityX = manager?.deviceMotion?.gravity.x, let gravityY = manager?.deviceMotion?.gravity.y, ball != nil {
            
            let friction = frictionMap[Int(ball.position.x) + 375][Int(ball.position.y) + 667]
            let impulseX = CGFloat(gravityX) * (ball.physicsBody?.mass)! * CGFloat(9.8)
            let impulseY = CGFloat(gravityY) * (ball.physicsBody?.mass)! * CGFloat(9.8)
            
            
            
            
            // let newPosition = CGPoint(x: Double(ball.position.x) + gravityX * 35.0, y: Double(ball.position.y) + gravityY * 35.0)
            // let moveAction = SKAction.moveTo(newPosition, duration: 0.0)
            // ball.runAction(moveAction)
            
            //             applyImpulse() is much better than applyForce()
            //             ball.physicsBody?.applyForce(CGVector(dx: CGFloat(gravityX) * (ball.physicsBody?.mass)! * CGFloat(9.8) , dy: CGFloat(gravityY) * (ball.physicsBody?.mass)! * CGFloat(9.8)))
            
            
            if friction == 1.0 {
                ball.physicsBody?.applyImpulse(CGVector(dx: impulseX , dy: impulseY))
                
                
                
                
                //  ball.physicsBody?.velocity = (CGVector(dx: impulseX  , dy: impulseY))
                print("Frictionless Hız \(ball.physicsBody!.velocity.dx, ball.physicsBody!.velocity.dy)")
            }
                
            else if friction < 1.0 {
                let frictionTotal = CGFloat((ball.physicsBody?.mass)! * CGFloat(9.8) * CGFloat(friction)) // Fs = k * mass * gravity
                let totalImpulse = impulseX + impulseY
                
                let frictionX = (frictionTotal/totalImpulse) * impulseX
                let frictionY = (frictionTotal/totalImpulse) * impulseY
                
                let lastVelocityX = impulseX - frictionX
                let lastVelocityY = impulseY - frictionY
                
                ball.physicsBody?.applyImpulse(CGVector(dx: lastVelocityX, dy: lastVelocityY ))
                
                let velocityX = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx)
                let velocityY = sqrt(ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
                
                let totalVelocity = velocityX + velocityY
                print("sürtünmeli ortam Hızı \(ball.physicsBody!.velocity.dx, ball.physicsBody!.velocity.dy)")
                
                if(totalVelocity > maxVelocity){
                    ball.physicsBody!.linearDamping = 0.4
                    //Linear damping reduces the body's linear velocity.
                    print("azaltılmış hız \(ball.physicsBody!.velocity.dx, ball.physicsBody!.velocity.dy)")
                } else {
                    ball.physicsBody!.linearDamping = 0.0
                }
                
                // ball.physicsBody?.velocity = (CGVector(dx: velocityX + lastVelocityX  , dy: velocityY + lastVelocityY ))
                
                
                
                /*if ((ball.physicsBody?.velocity.dx)! < frictionX || (ball.physicsBody?.velocity.dy)! < frictionY ){
                 ball.physicsBody?.velocity.dx = 0.0
                 ball.physicsBody?.velocity.dy = 0.0
                 }*/
                
            }
            
            
        }
    }
    
    func centerBall() {
        ball.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        let moveAction = SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY), duration: 0.0)
        ball.run(moveAction)
    }
    
    // MARK: - Timer Methods
    
    @objc func increaseTimer() {
        seconds = (seconds ?? 0.0) + 0.001
    }
    
    func resetTimer() {
        seconds = 0.0
    }
    
}


