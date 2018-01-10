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
                if ((red == 150 && blue == 0 && green == 0) || (red == 0 && blue == 150 && green == 0 )){
                    frictionMap[i][j] = 0.3
                }else if ((red == 200 && blue == 0 && green == 0) || (red == 0 && blue == 200 && green == 0 )){
                    frictionMap[i][j] = 0.5
                }else if ((red == 240 && blue == 0 && green == 0) || (red == 0 && blue == 240 && green == 0 )){
                    frictionMap[i][j] = 0.8
                }else if ((red == 0 && blue == 0 && green == 200) || (red == 255 && blue == 0 && green == 255 )){
                    frictionMap[i][j] = 0.01
                }else if ((red == 0 && blue == 0 && green == 160) || (red == 255 && blue == 0 && green == 220 )){
                    frictionMap[i][j] = 0.02
                }
                else {
                    frictionMap[i][j] = 0.0
                }
                currentPixel += 1
                //print("currentPixel: ",currentPixel, "alpha:" ,alpha, "frictionMap:" ,matrix, "i:" ,i, "j:" ,j)
            }
        }
        //        print("frictionMap:" ,frictionMap)
    }
    
    func backgroundImage(_ obstacleImage:UIImage,  _ frictionImage:UIImage,_ emptyImage: UIImage) -> UIImage{
        
        //getting frictionimage as bitmap
        let inputFrictionImage = frictionImage.cgImage
        let frictionWidth: Int = (inputFrictionImage?.width)!
        let frictionHeight: Int = (inputFrictionImage?.height)!
        let frictionBytesPerPixel: Int = 4
        let frictionBytesPerRow: Int = frictionBytesPerPixel * frictionWidth
        let frictionBitsPerComponent: Int = 8
        let frictionPixels = UnsafeMutablePointer<UInt32>.allocate(capacity: (frictionWidth * frictionHeight))
        let frictionBitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        let frictionColorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let frictionContext = CGContext(data: frictionPixels, width: frictionWidth, height: frictionHeight, bitsPerComponent: frictionBitsPerComponent, bytesPerRow: frictionBytesPerRow, space: frictionColorSpace, bitmapInfo: frictionBitmapInfo)
        frictionContext?.draw(inputFrictionImage!, in: CGRect(x: 0, y: 0, width: CGFloat(frictionWidth), height: CGFloat(frictionHeight)))
        
        //getting obstacleImage as bitmap
        let inputObstacleImage = obstacleImage.cgImage
        let obstacleWidth: Int = (inputFrictionImage?.width)!
        let obstacleHeight: Int = (inputFrictionImage?.height)!
        let obstacleBytesPerPixel: Int = 4
        let obstacleBytesPerRow: Int = obstacleBytesPerPixel * obstacleWidth
        let obstacleBitsPerComponent: Int = 8
        let obstaclePixels = UnsafeMutablePointer<UInt32>.allocate(capacity: (obstacleWidth * obstacleHeight))
        let obstacleBitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        let obstacleColorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let obstacleContext = CGContext(data: obstaclePixels, width: obstacleWidth, height: obstacleHeight, bitsPerComponent: obstacleBitsPerComponent, bytesPerRow: obstacleBytesPerRow, space: obstacleColorSpace, bitmapInfo: obstacleBitmapInfo)
        obstacleContext?.draw(inputObstacleImage!, in: CGRect(x: 0, y: 0, width: CGFloat(obstacleWidth), height: CGFloat(obstacleHeight)))
        
        //empty image for combining all
        let inputEmptyImage = emptyImage.cgImage
        let emptyWidth: Int = (inputEmptyImage?.width)!
        let emptyHeight: Int = (inputEmptyImage?.height)!
        let emptyBytesPerPixel: Int = 4
        let emptyBytesPerRow: Int = emptyBytesPerPixel * emptyWidth
        let emptyBitsPerComponent: Int = 8
        let emptyPixels = UnsafeMutablePointer<UInt32>.allocate(capacity: (emptyWidth * emptyHeight))
        let emptyBitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        let emptyColorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let emptyContext = CGContext(data: emptyPixels, width: emptyWidth, height: emptyHeight, bitsPerComponent: emptyBitsPerComponent, bytesPerRow: emptyBytesPerRow, space: emptyColorSpace, bitmapInfo: emptyBitmapInfo)
        emptyContext?.draw(inputEmptyImage!, in: CGRect(x: 0, y: 0, width: CGFloat(emptyWidth), height: CGFloat(emptyHeight)))
        
        
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
        
        //HATA NEEDS TO BE FIXED
        func rgba(red: Int , green: Int , blue: Int , alpha: Int ) -> Int32 {
            return (Mask8(x: alpha) << 24) | (Mask8(x: red) << 16) | (Mask8(x: green) << 8) | (Mask8(x: blue) << 0)
        }
        
        var obstacleCurrentPixel = obstaclePixels
        var frictionCurrentPixel = frictionPixels
        var emptyCurrentPixel = emptyPixels
        
        for j in 0..<emptyHeight {// y coordinate
            for i in 0..<emptyWidth {// x coordinate
                let colorObst = obstacleCurrentPixel.pointee.hashValue
                let redObst = R(x: colorObst)
                let greenObst = G(x: colorObst)
                let blueObst = B(x: colorObst)
                let alphaObst = A(x: colorObst)
                
                let colorFric = frictionCurrentPixel.pointee.hashValue
                let redFric = R(x: colorFric)
                let greenFric = G(x: colorFric)
                let blueFric = B(x: colorFric)
                let alphaFric = A(x: colorFric)
                
                let colorEmpty = emptyCurrentPixel.pointee.hashValue
                var redEmpty = R(x: colorEmpty)
                var greenEmpty = G(x: colorEmpty)
                var blueEmpty = B(x: colorEmpty)
                var alphaEmpty = A(x: colorEmpty)
                
                if (redObst == 0){
                    redEmpty = 0
                    greenEmpty = 0
                    blueEmpty = 0
                }
                else if (redFric == 150 && blueFric == 0 && greenFric == 0) {
                    redEmpty = 150
                    greenEmpty = 0
                    blueEmpty = 0
                }else if ( redFric == 0 && blueFric == 150 && greenFric == 0 ) {
                    redEmpty = 0
                    greenEmpty = 240
                    blueEmpty = 240
                }else if ( redFric == 200 && blueFric == 0 && greenFric == 0 ) {
                    redEmpty = 200
                    greenEmpty = 0
                    blueEmpty = 0
                }else if ( redFric == 0 && blueFric == 200 && greenFric == 0 ) {
                    redEmpty = 0
                    greenEmpty = 240
                    blueEmpty = 240
                }else if ( redFric == 240 && blueFric == 0 && greenFric == 0 ) {
                    redEmpty = 240
                    greenEmpty = 0
                    blueEmpty = 0
                }else if ( redFric == 0 && blueFric == 240 && greenFric == 0 ) {
                    redEmpty = 0
                    greenEmpty = 240
                    blueEmpty = 240
                }else if ( redFric == 0 && blueFric == 0 && greenFric == 200 ) {
                    redEmpty = 0
                    greenEmpty = 200
                    blueEmpty = 0
                }else if ( redFric == 255 && blueFric == 0 && greenFric == 255 ) {
                    redEmpty = 0
                    greenEmpty = 240
                    blueEmpty = 240
                }else if ( redFric == 0 && blueFric == 0 && greenFric == 160 ) {
                    redEmpty = 0
                    greenEmpty = 160
                    blueEmpty = 0
                }else if ( redFric == 255 && blueFric == 0 && greenFric == 220 ) {
                    redEmpty = 0
                    greenEmpty = 240
                    blueEmpty = 240
                }
                else {
                    redEmpty = 0
                    greenEmpty = 240
                    blueEmpty = 240
                }
                
                emptyCurrentPixel.pointee = UInt32(rgba(red: redEmpty, green: greenEmpty, blue: blueEmpty, alpha: 0))
                
                emptyCurrentPixel = emptyCurrentPixel.successor()
                
                emptyCurrentPixel += 1
                frictionCurrentPixel += 1
                obstacleCurrentPixel += 1
            }
            
            
        }
        
        //hata need to be fixed
        
        let emptyOutputCGImage = CGBitmapContextCreateImage(emptyContext!)
        let emptyOutputImage = UIImage(CGImage: emptyOutputCGImage!, scale: inputEmptyImage.scale, orientation: inputEmptyImage.imageOrientation)
        
        return emptyOutputImage
    }
    
    //hata needs to be fixed
    
//    let background = self.backgroundImage(#imageLiteral(resourceName: "obstacle"), #imageLiteral(resourceName: "blueRedYellowGreenFriction"), #imageLiteral(resourceName: "emptyImage"))
//    var setBackground = SKSpriteNode(imageNamed: "bacground")
    
    
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
        setBackground.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        addChild(setBackground)
        
        print("3")
        logPixelsOf(#imageLiteral(resourceName: "obstaclex4"))
        setFriction(#imageLiteral(resourceName: "blueRedYellowGreenFriction"))
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
            let velocityX = CGFloat(ball.physicsBody!.velocity.dx)
            let velocityY = CGFloat(ball.physicsBody!.velocity.dy)
            let ballVelocity = sqrt((ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx) + (ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy))
            let impulse = sqrt((impulseX * impulseX ) + (impulseY * impulseY))
            
            var frictionX = CGFloat(0.0)
            var frictionY = CGFloat(0.0)
            
            if ballVelocity == CGFloat(0.0) {
                frictionX = CGFloat(abs((impulseX * friction) / impulse))
                frictionY = CGFloat(abs((impulseY * friction) / impulse))
            } else {
                
                if frictionFactor == 0.3 {
                    frictionX = -CGFloat(velocityX/10.0)
                    frictionY = -CGFloat(velocityY/10.0)
                }else if frictionFactor == 0.5{
                    frictionX = -CGFloat(velocityX/7.0)
                    frictionY = -CGFloat(velocityY/7.0)
                }else if frictionFactor == 0.8{
                    frictionX = -CGFloat(velocityX/5.0)
                    frictionY = -CGFloat(velocityY/5.0)
                }else if frictionFactor == 0.01{
                    frictionX = CGFloat(velocityX/15.0)
                    frictionY = CGFloat(velocityY/15.0)
                }else if frictionFactor == 0.02{
                    frictionX = CGFloat(velocityX/10.0)
                    frictionY = CGFloat(velocityY/10.0)
                }
                
                frictionX = CGFloat(abs((velocityX * friction) / ballVelocity))
                frictionY = CGFloat(abs((velocityY * friction) / ballVelocity))
                
            }
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
                        
                        /*    if (ball.physicsBody!.velocity.dx > 0.0 && ball.physicsBody!.velocity.dy > 0.0) {
                         frictionX = -(frictionX)
                         frictionY = -(frictionY)
                         }else if(ball.physicsBody!.velocity.dx > 0.0 && ball.physicsBody!.velocity.dy < 0.0){
                         frictionX = -(frictionX)
                         }else if(ball.physicsBody!.velocity.dx < 0.0 && ball.physicsBody!.velocity.dy > 0.0){
                         frictionY = -(frictionY)
                         }else if (ball.physicsBody!.velocity.dx < 0.0 && ball.physicsBody!.velocity.dy < 0.0){
                         
                         } */
                        
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
                    else if friction > 0.0 {
                        
                        if ballVelocity != CGFloat(0.0) {//top hareketlıyse
                            if impulse > friction {
                                if ((velocityX + impulseX) > CGFloat(0.0) && (velocityY + impulseY) > CGFloat(0.0)) {
                                    
                                    /*    frictionX = -(frictionX)
                                     frictionY = -(frictionY) */
                                    ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                                }else if ((velocityX + impulseX) > CGFloat(0.0) && (velocityY + impulseY) < CGFloat(0.0)){
                                    /*  frictionX = -(frictionX) */
                                    ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                                }else if ((velocityX + impulseX) < CGFloat(0.0) && (velocityY + impulseY) > CGFloat(0.0)){
                                    /*   frictionY = -(frictionY) */
                                    
                                    frictionX = -(frictionX)
                                    frictionY = -(frictionY)
                                    ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                                }else if ((velocityX + impulseX) > CGFloat(0.0) && (velocityY + impulseY) < CGFloat(0.0)){
                                    frictionX = -(frictionX)
                                    ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                                }else if ((velocityX + impulseX) < CGFloat(0.0) && (velocityY + impulseY) > CGFloat(0.0)){
                                    frictionY = -(frictionY)
                                    
                                    ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                                }else if ((velocityX + impulseX) < CGFloat(0.0) && (velocityY + impulseY) < CGFloat(0.0)){
                                    ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                                }else if ((velocityX + impulseX) == CGFloat(0.0) && (velocityY + impulseY) == CGFloat(0.0)){
                                    ball.physicsBody?.velocity.dx = 0.0
                                    ball.physicsBody?.velocity.dy = 0.0
                                }else if ((velocityX + impulseX) != CGFloat(0.0) && (velocityY + impulseY) == CGFloat(0.0)){
                                    ball.physicsBody?.velocity.dy = 0.0
                                    if((velocityX + impulseX) > CGFloat(0.0) ){
                                        
                                        /*    frictionX = -(frictionX) */
                                        
                                        frictionX = -(frictionX)
                                        
                                        ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: CGFloat(0.0)))
                                    }else {
                                        ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: CGFloat(0.0)))
                                    }
                                }else if ((velocityX + impulseX) == CGFloat(0.0) && (velocityY + impulseY) != CGFloat(0.0)){
                                    ball.physicsBody?.velocity.dy = 0.0
                                    if((velocityY + impulseY) > CGFloat(0.0) ){
                                        
                                        /*   frictionY = -(frictionY) */
                                        
                                        frictionY = -(frictionY)
                                        
                                        ball.physicsBody?.applyImpulse(CGVector(dx: CGFloat(0.0) , dy: impulseY + frictionY))
                                    }else {
                                        ball.physicsBody?.applyImpulse(CGVector(dx: CGFloat(0.0) , dy: impulseY + frictionY))
                                    }
                                }
                                
                            }
                            
                            /*      else if friction >= impulse {
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
                             
                             } */
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
    }
    func centerBall() {
        ball.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        let moveAction = SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY), duration: 0.0)
        ball.run(moveAction)
    }
    
    // MARK: - Timer Methods
    
    @objc func increaseTimer() {
        seconds = (seconds ?? 0.0) + 0.00001
    }
    
    func resetTimer() {
        seconds = 0.0
    }
    
}



