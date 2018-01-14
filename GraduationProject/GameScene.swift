
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
    var obstacleMap = [[Int]](repeating: [Int](repeating: 0, count: 1334), count: 750)
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    let deviceHeight = 1334.0
    let deviceWidth = 750.0
    
    func setObstacles() {

        obstacleMap = SetObstacles().setObstacles(#imageLiteral(resourceName: "obstacle"))!
        
        let height = 1334
        let width = 750
        
        for row in 0 ..< height {
            for column in 0 ..< width {
                if obstacleMap[row][column] == 1 {
                    let size = CGSize(width: CGFloat(1), height: CGFloat(1))
                    var pixel: SKSpriteNode!
                    pixel = SKSpriteNode.init()
                    pixel.physicsBody = SKPhysicsBody(rectangleOf: size)
                    pixel.physicsBody?.pinned = true
                    pixel.physicsBody?.isDynamic = false
                    pixel.physicsBody?.affectedByGravity = false
                    pixel.physicsBody?.allowsRotation = false
                    pixel.position = CGPoint(x: (CGFloat(column)*CGFloat(1)-CGFloat(375.0)), y: (CGFloat(height-row)*CGFloat(1)-CGFloat(667.0)))
                    addChild(pixel)
                }
            }
        }
        
    }
    
    
    
    override func didMove(to view: SKView) {
        
        setBackground()
        
        setObstacles()
        frictionMap = SetFriction().createBackground(#imageLiteral(resourceName: "newFriction"))!
        
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
            
            let frictionFactor = frictionMap[Int(ball.position.y) + 667][Int(ball.position.x) + 375]
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
                    frictionX = -CGFloat(velocityX/15.0)
                    frictionY = -CGFloat(velocityY/15.0)
                }else if frictionFactor == 0.5{
                    frictionX = -CGFloat(velocityX/10.0)
                    frictionY = -CGFloat(velocityY/10.0)
                }else if frictionFactor == 0.8{
                    frictionX = -CGFloat(velocityX/8.0)
                    frictionY = -CGFloat(velocityY/8.0)
                }else if frictionFactor == 1.3{
                    frictionX = CGFloat(velocityX/15.0)
                    frictionY = CGFloat(velocityY/15.0)
                }else if frictionFactor == 1.6{
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
