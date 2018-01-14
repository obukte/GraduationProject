
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
    
    func setObstacles(_ image: UIImage) {

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
        let pixelHeight = (1334.0/Float(height))
        for j in 0..<height {
            for i in 0..<width {
                let color = currentPixel.pointee.hashValue
                let alpha = A(x: color)
                if (R(x: color) == 0){
                    let size = CGSize(width: CGFloat(pixelWidth), height: CGFloat(pixelHeight))
                    var pixel: SKSpriteNode!
//                    pixel = SKSpriteNode.init(color: UIColor(red:CGFloat(R(x: color)), green:CGFloat(G(x: color)), blue:CGFloat(B(x: color)), alpha:CGFloat(alpha)), size: size)
                    pixel = SKSpriteNode.init()
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
        for j in 0..<height {// y
            for i in 0..<width {// x
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
            }
        }
    }
    
    
    
    override func didMove(to view: SKView) {
        
        setBackground()
        
        setObstacles(#imageLiteral(resourceName: "obstaclex4"))
        setFriction(#imageLiteral(resourceName: "blueRedYellowGreenFriction"))
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(GameScene.increaseTimer), userInfo: nil, repeats: true)
        
        physicsWorld.contactDelegate = self as? SKPhysicsContactDelegate
        
        addBallToScene()
        
        manager = CMMotionManager()
        if let manager = manager, manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.001
            manager.startDeviceMotionUpdates()
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
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
            }
//            print("ImpulseX: \(impulseX) && FrictionX: \(frictionX) ImpulseY: \(impulseY) && FrictionY: \(frictionY)")
            if friction == 0.0 {
                ball.physicsBody?.applyImpulse(CGVector(dx: impulseX , dy: impulseY))
            }
            else if friction > 0.0 {
                
                if ballVelocity != CGFloat(0.0) {
                    if impulse > friction {
                        ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                    }
                    else if friction > 0.0 {
                        if ballVelocity != CGFloat(0.0) {
                            if impulse > friction {
                                if ((velocityX + impulseX) > CGFloat(0.0) && (velocityY + impulseY) > CGFloat(0.0)) {
                                    ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                                }else if ((velocityX + impulseX) > CGFloat(0.0) && (velocityY + impulseY) < CGFloat(0.0)){
                                    ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                                }else if ((velocityX + impulseX) < CGFloat(0.0) && (velocityY + impulseY) > CGFloat(0.0)){
                                    ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                                }else if ((velocityX + impulseX) > CGFloat(0.0) && (velocityY + impulseY) < CGFloat(0.0)){
                                    ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                                }else if ((velocityX + impulseX) < CGFloat(0.0) && (velocityY + impulseY) > CGFloat(0.0)){
                                    ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                                }else if ((velocityX + impulseX) < CGFloat(0.0) && (velocityY + impulseY) < CGFloat(0.0)){
                                    ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                                }else if ((velocityX + impulseX) == CGFloat(0.0) && (velocityY + impulseY) == CGFloat(0.0)){
                                    ball.physicsBody?.velocity.dx = 0.0
                                    ball.physicsBody?.velocity.dy = 0.0
                                }else if ((velocityX + impulseX) != CGFloat(0.0) && (velocityY + impulseY) == CGFloat(0.0)){
                                    ball.physicsBody?.velocity.dy = 0.0
                                    if((velocityX + impulseX) > CGFloat(0.0) ){
                                        ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: CGFloat(0.0)))
                                    }else {
                                        ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: CGFloat(0.0)))
                                    }
                                }else if ((velocityX + impulseX) == CGFloat(0.0) && (velocityY + impulseY) != CGFloat(0.0)){
                                    ball.physicsBody?.velocity.dy = 0.0
                                    if((velocityY + impulseY) > CGFloat(0.0) ){
                                        
                                        frictionY = -(frictionY)
                                        
                                        ball.physicsBody?.applyImpulse(CGVector(dx: CGFloat(0.0) , dy: impulseY + frictionY))
                                    }else {
                                        ball.physicsBody?.applyImpulse(CGVector(dx: CGFloat(0.0) , dy: impulseY + frictionY))
                                    }
                                }
                                
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
            }
        }
    }
    
    func setBackground() {
        let newImage = SetBackground().createBackground(#imageLiteral(resourceName: "obstacle"), #imageLiteral(resourceName: "blueRedYellowGreenFriction"), #imageLiteral(resourceName: "emptyImage"))
        let Texture = SKTexture(image: newImage!)
        let background = SKSpriteNode(texture:Texture)
        background.position = CGPoint(x: 0, y: 0 )
        background.zPosition = -1
        addChild(background)
    }
    
    func addBallToScene() {
        
        ball = SKSpriteNode(imageNamed: "Ball")
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.height / 2.0)
        ball.physicsBody?.mass = 1.0
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.affectedByGravity = false
        addChild(ball)
        
    }
    
    func centerBall() {
        ball.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        let moveAction = SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY), duration: 0.0)
        ball.run(moveAction)
    }
    
    
    @objc func increaseTimer() {
        seconds = (seconds ?? 0.0) + 0.00001
    }
    
    func resetTimer() {
        seconds = 0.0
    }
    
}
