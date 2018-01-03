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
                    frictionMap[i][j] = 0.3
                }else if (red > 230 && red < 250  ){
                    frictionMap[i][j] = 0.5
                }else if (red > 250 && alpha == 255 ){
                    frictionMap[i][j] = 0.8
                }else if (red == 255 &&  alpha == 255){
                    frictionMap[i][j] = 0.0
                }else {
                    frictionMap[i][j] = 0.0
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
            
            let frictionFactor = frictionMap[Int(ball.position.x) + 375][Int(ball.position.y) + 667]
            let friction = CGFloat(frictionFactor) * (ball.physicsBody?.mass)! * CGFloat(9.8)
            let impulseX = CGFloat(gravityX) * (ball.physicsBody?.mass)! * CGFloat(9.8)
            let impulseY = CGFloat(gravityY) * (ball.physicsBody?.mass)! * CGFloat(9.8)
            let ballVelocity = sqrt((ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx) + (ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy))
            let impulse = sqrt((impulseX * impulseX ) + (impulseY * impulseY))
            var frictionX = CGFloat(0.0)
            var frictionY = CGFloat(0.0)

            
            if ballVelocity == CGFloat(0.0) && impulse > CGFloat(0.0) {

            if ballVelocity == CGFloat(0.0) {

                frictionX = CGFloat((impulseX * friction) / impulse)
                frictionY = CGFloat((impulseY * friction) / impulse)
            } else {
                frictionX = CGFloat((ball.physicsBody!.velocity.dx * friction) / ballVelocity)
                frictionY = CGFloat((ball.physicsBody!.velocity.dy * friction) / ballVelocity)
            }

            
            
            
            print("ImpulseX: \(impulseX) && FrictionX: \(frictionX) ImpulseY: \(impulseY) && FrictionY: \(frictionY)")
            
            if friction == 0.0 {
                ball.physicsBody?.applyImpulse(CGVector(dx: impulseX , dy: impulseY))
            }
            else if friction > 0.0 {
                if ballVelocity != CGFloat(0.0) {//top hareketlıyse
                    if impulse > friction && impulse > ballVelocity{//impulse frictiondan ve topun hizindan buyuk ise
                        if impulseX > 0.0 && impulseY > 0.0 {
                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX - frictionX , dy: impulseY - frictionY))
                        }else if impulseX > 0.0 && impulseY < 0.0 {
                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX - frictionX , dy: impulseY + frictionY))
                        }else if impulseX < 0.0 && impulseY > 0.0 {
                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY - frictionY))
                        }else if impulseX < 0.0 && impulseY < 0.0 {
                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                        }
                    }else if impulse > friction && impulse < ballVelocity {
                        if (ball.physicsBody!.velocity.dx > 0.0 && ball.physicsBody!.velocity.dy > 0.0) {
                            frictionX = -(frictionX)
                            frictionY = -(frictionY)
                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                        }else if(ball.physicsBody!.velocity.dx > 0.0 && ball.physicsBody!.velocity.dy < 0.0){
                            frictionX = -(frictionX)
                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                        }else if(ball.physicsBody!.velocity.dx < 0.0 && ball.physicsBody!.velocity.dy > 0.0){
                            frictionY = -(frictionY)
                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                        }else if (ball.physicsBody!.velocity.dx < 0.0 && ball.physicsBody!.velocity.dy < 0.0){
                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                        }
                    }else if friction > impulse {
                        if ((ball.physicsBody!.velocity.dx < CGFloat(0.0) && impulseX < CGFloat(0.0)) || (ball.physicsBody!.velocity.dx > CGFloat(0.0) && impulseX > CGFloat(0.0))) && ((ball.physicsBody!.velocity.dy < CGFloat(0.0) && impulseY < CGFloat(0.0)) || (ball.physicsBody!.velocity.dy > CGFloat(0.0) && impulseY > CGFloat(0.0))) {
                            
                            if (abs(ball.physicsBody!.velocity.dx + impulseX) < frictionX){
                                if (abs(ball.physicsBody!.velocity.dy + impulseY) < frictionY){
                                    ball.physicsBody?.applyImpulse(CGVector(dx: -CGFloat(ball.physicsBody!.velocity.dx),  dy: -CGFloat(ball.physicsBody!.velocity.dy)))
                                }else if (abs(ball.physicsBody!.velocity.dy + impulseY) > frictionY){
                                    if impulseY > CGFloat(0.0) {
                                        ball.physicsBody?.applyImpulse(CGVector(dx: -CGFloat(ball.physicsBody!.velocity.dx),  dy: impulseY - frictionY ))
                                    }else {
                                        ball.physicsBody?.applyImpulse(CGVector(dx: -CGFloat(ball.physicsBody!.velocity.dx),  dy: impulseY + frictionY ))
                                    }
                                }
                            }else if (abs(ball.physicsBody!.velocity.dx + impulseX) > frictionX){
                                if (abs(ball.physicsBody!.velocity.dy + impulseY) < frictionY){
                                    if impulseX > CGFloat(0.0){
                                        ball.physicsBody?.applyImpulse(CGVector(dx: impulseX - frictionX,  dy: -CGFloat(ball.physicsBody!.velocity.dy)))
                                    }else {
                                        ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX,  dy: -CGFloat(ball.physicsBody!.velocity.dy)))
                                    }
                                }else if (abs(ball.physicsBody!.velocity.dy + impulseY) > frictionY){
                                    if impulseY > CGFloat(0.0) {
                                        if impulseX > CGFloat(0.0){
                                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX - frictionX,  dy: impulseY - frictionY ))
                                        }else {
                                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX,  dy: impulseY - frictionY ))
                                        }
                                    }else {
                                        if impulseX > CGFloat(0.0){
                                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX - frictionX,  dy: impulseY + frictionY ))
                                        }else {
                                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX,  dy: impulseY + frictionY ))
                                        }
                                    }
                                }
                            }
                            
                            
                            
                            
                            
                            
                        } else if ((ball.physicsBody!.velocity.dx < CGFloat(0.0) && impulseX < CGFloat(0.0)) || (ball.physicsBody!.velocity.dx > CGFloat(0.0) && impulseX > CGFloat(0.0))) && ((ball.physicsBody!.velocity.dy < CGFloat(0.0) && impulseY > CGFloat(0.0)) || (ball.physicsBody!.velocity.dy > CGFloat(0.0) && impulseY < CGFloat(0.0))){
                            
                            if (abs(ball.physicsBody!.velocity.dx + impulseX) < frictionX){
                                if (abs(ball.physicsBody!.velocity.dy) < (abs(impulseY) + frictionY)){
                                    
                                    ball.physicsBody?.applyImpulse(CGVector(dx: -CGFloat(ball.physicsBody!.velocity.dx),  dy: -CGFloat(ball.physicsBody!.velocity.dy)))
                                    
                                }else if (abs(ball.physicsBody!.velocity.dy) > (abs(impulseY) + frictionY)){
                                    if impulseY > CGFloat(0.0) {
                                        ball.physicsBody?.applyImpulse(CGVector(dx: -CGFloat(ball.physicsBody!.velocity.dx),  dy: impulseY - frictionY ))
                                    }else {
                                        ball.physicsBody?.applyImpulse(CGVector(dx: -CGFloat(ball.physicsBody!.velocity.dx),  dy: impulseY + frictionY ))
                                    }
                                }
                            }else if (abs(ball.physicsBody!.velocity.dx + impulseX) > frictionX){
                                if (abs(ball.physicsBody!.velocity.dy + impulseY) < frictionY){
                                    if impulseX > CGFloat(0.0){
                                        ball.physicsBody?.applyImpulse(CGVector(dx: impulseX - frictionX,  dy: -CGFloat(ball.physicsBody!.velocity.dy)))
                                    }else {
                                        ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX,  dy: -CGFloat(ball.physicsBody!.velocity.dy)))
                                    }
                                }else if (abs(ball.physicsBody!.velocity.dy + impulseY) > frictionY){
                                    if impulseY > CGFloat(0.0) {
                                        if impulseX > CGFloat(0.0){
                                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX - frictionX,  dy: impulseY - frictionY ))
                                        }else {
                                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX,  dy: impulseY - frictionY ))
                                        }
                                    }else {
                                        if impulseX > CGFloat(0.0){
                                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX - frictionX,  dy: impulseY + frictionY ))
                                        }else {
                                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX,  dy: impulseY + frictionY ))
                                        }
                                    }
                                }
                            }
                            
                            
                            
                        } else if ((ball.physicsBody!.velocity.dx < CGFloat(0.0) && impulseX > CGFloat(0.0)) || (ball.physicsBody!.velocity.dx > CGFloat(0.0) && impulseX < CGFloat(0.0))) && ((ball.physicsBody!.velocity.dy < CGFloat(0.0) && impulseY < CGFloat(0.0)) || (ball.physicsBody!.velocity.dy > CGFloat(0.0) && impulseY > CGFloat(0.0))){
                        }else if ((ball.physicsBody!.velocity.dx < CGFloat(0.0) && impulseX > CGFloat(0.0)) || (ball.physicsBody!.velocity.dx > CGFloat(0.0) && impulseX < CGFloat(0.0))) && ((ball.physicsBody!.velocity.dy < CGFloat(0.0) && impulseY > CGFloat(0.0)) || (ball.physicsBody!.velocity.dy > CGFloat(0.0) && impulseY < CGFloat(0.0))){
                        }
                            if ball.physicsBody!.velocity.dx < (impulseX + frictionX) && ball.physicsBody!.velocity.dy < (impulseY + frictionY){
                                ball.physicsBody?.velocity.dx = 0.0
                                ball.physicsBody?.velocity.dy = 0.0
                            }else{
                                ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                            }
                    }
                }else if ballVelocity == CGFloat(0.0) {//top hareketsizse
                    if friction < impulse {
                        if impulseX > 0.0 && impulseY > 0.0{
                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX - frictionX , dy: impulseY - frictionY))
                        }else if impulseX > 0.0 && impulseY < 0.0 {
                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX - frictionX , dy: impulseY + frictionY))
                        }else if impulseX < 0.0 && impulseY > 0.0 {
                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY - frictionY))
                        }else if impulseX < 0.0 && impulseY < 0.0 {
                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                        }
                    }
                }
                //impulse velocity arttırıyorsa

            print("ImpulseX: \(impulseX) && FrictionX: \(frictionX) ImpulseY: \(impulseY) && FrictionY: \(frictionY)")
            if friction == 0.0 {
                ball.physicsBody?.applyImpulse(CGVector(dx: impulseX , dy: impulseY))
                
                //  ball.physicsBody?.velocity = (CGVector(dx: impulseX  , dy: impulseY))
                //                print("Frictionless Hız \(ball.physicsBody!.velocity.dx, ball.physicsBody!.velocity.dy)")
            }
                // -> fric 50
                
                // 4 yukari 0 saga -> vel 100 sag capraz  sqrt(dx^2 + dy^2) = sqrt(genelHız^2)      = frictionX = - OLMALI frictionY = -
            else if friction > 0.0 {
                
                if ballVelocity != CGFloat(0.0) {//top hareketlıyse
                    if impulse > friction {
                        if (ball.physicsBody!.velocity.dx > 0.0 && ball.physicsBody!.velocity.dy > 0.0) {
                            frictionX = -(frictionX)
                            frictionY = -(frictionY)
                        }else if(ball.physicsBody!.velocity.dx > 0.0 && ball.physicsBody!.velocity.dy < 0.0){
                            frictionX = -(frictionX)
                        }else if(ball.physicsBody!.velocity.dx < 0.0 && ball.physicsBody!.velocity.dy > 0.0){
                            frictionY = -(frictionY)
                        }else if (ball.physicsBody!.velocity.dx < 0.0 && ball.physicsBody!.velocity.dy < 0.0){
                            
                        }
                        ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                    }
                    else if friction > impulse {
                        if (ball.physicsBody!.velocity.dx > 0.0 && ball.physicsBody!.velocity.dy > 0.0) {
                            frictionX = -(frictionX)
                            frictionY = -(frictionY)
                        }else if(ball.physicsBody!.velocity.dx > 0.0 && ball.physicsBody!.velocity.dy < 0.0){
                            frictionX = -(frictionX)
                        }else if(ball.physicsBody!.velocity.dx < 0.0 && ball.physicsBody!.velocity.dy > 0.0){
                            frictionY = -(frictionY)
                        }else if (ball.physicsBody!.velocity.dx < 0.0 && ball.physicsBody!.velocity.dy < 0.0){
                            
                        }
                        if ball.physicsBody!.velocity.dx < impulseX + frictionX && ball.physicsBody!.velocity.dy < impulseY + frictionY{
                            ball.physicsBody?.velocity.dx = 0.0
                            ball.physicsBody?.velocity.dy = 0.0
                        }else {
                            ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                        }
                    }
                    
                    
                }

            }
            
            if ballVelocity == CGFloat(0.0) {
                if friction < impulse {
                    if impulseX > 0.0 && impulseY > 0.0{
                        ball.physicsBody?.applyImpulse(CGVector(dx: impulseX - frictionX , dy: impulseY - frictionY))
                    }else if impulseX > 0.0 && impulseY < 0.0 {
                        ball.physicsBody?.applyImpulse(CGVector(dx: impulseX - frictionX , dy: impulseY + frictionY))
                    }else if impulseX < 0.0 && impulseY > 0.0 {
                        ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY - frictionY))
                    }else if impulseX < 0.0 && impulseY < 0.0 {
                        ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                    }
                }
            }
            //impulse velocity arttırıyorsa
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


