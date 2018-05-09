import SpriteKit
import CoreMotion
import GameplayKit
import UIKit

class GameScene: SKScene {
    
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    
    var ball: SKSpriteNode!
    var manager: CMMotionManager?
    var timer: Timer?
    var seconds: Double?
    var velocityX = CGFloat(0.0)
    var velocityY = CGFloat(0.0)
    var touchTime = 0
    
    var sequence:SKAction!
    var wait:SKAction!
    var block:SKAction!
    
    var timerLabel = SKLabelNode(fontNamed: "ArialMT")
    var bestScoreLabel  = SKLabelNode(fontNamed: "ArialMT")
    var touchToBeginLabel    = SKLabelNode(fontNamed: "ArialMT")
    
    var loggedData = ""
    
    var levelTimerValue: Double = 0.0 {
        didSet {
            timerLabel.text = "\(round(10*levelTimerValue)/10)"
        }
    }
    
    let maxVelocity = CGFloat(50.0)
    
    var frictionMap = [[Double]](repeating: [Double](repeating: 0.0, count: 1334), count: 750)
    var heightMap = [[Int]](repeating: [Int](repeating: 0, count: 1334), count: 750)
    var obstacleMap = [[Int]](repeating: [Int](repeating: 0, count: 1334), count: 750)
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touchTime == 0 {
        touchToBeginLabel.removeFromParent()
        addChild(timerLabel)
        startTimer()
        ball.physicsBody?.isDynamic = true
        touchTime = 1
        }
    }
    
    func endGame(){
        addChild(touchToBeginLabel)
        timerLabel.removeFromParent()
        levelTimerValue = 0.0
        ball.physicsBody?.isDynamic = false
        ball.position = CGPoint(x: frame.midX, y: -600)
        touchTime = 0
        writeToFile()
    }
    
    
    func writeToFile(){
        let fileName = "experimentData.txt"
        var filePath = ""
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        let dir = dirs[0]
        filePath = dir.appending("/" + fileName)
        print("Local path = \(filePath)")
        
        let fileContentToWrite = loggedData
        
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
    
    override func didMove(to view: SKView) {

        createTouchToStartLabel()
        createTimerLabel()
        setBackground()
        setObstacles()
        
        addChild(touchToBeginLabel)
        
        frictionMap = SetFriction().createFrictionMap(#imageLiteral(resourceName: "newFriction"))!
        heightMap = SetHeight().createHeightMap(#imageLiteral(resourceName: "height"))!

        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(GameScene.increaseTimer), userInfo: nil, repeats: true)

        physicsWorld.contactDelegate = self as? SKPhysicsContactDelegate

        addBallToScene()

        manager = CMMotionManager()
        if let manager = manager, manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.001
            manager.startDeviceMotionUpdates()
        }
    }
    
    
    func createTimerLabel() {
        
        timerLabel.fontColor = SKColor.red
        timerLabel.fontSize = 30
        timerLabel.position = CGPoint(x: 0, y: 640)
        levelTimerValue = round(10*levelTimerValue)/10
        timerLabel.text = "\(levelTimerValue)"
        timerLabel.zPosition = 10
        wait = SKAction.wait(forDuration: 0.01)
        block = SKAction.run({
            [unowned self] in
            self.levelTimerValue = self.levelTimerValue + 0.01
            self.loggedData += "\(Int(self.ball.position.x)),\(Int(self.ball.position.y)) -> \(self.levelTimerValue) \n"
        })
        
        sequence = SKAction.sequence([wait,block])
    }
    
    func startTimer() {
        run(SKAction.repeatForever(sequence), withKey: "countdown")
    }
    
    
    func createTouchToStartLabel() {
        touchToBeginLabel.fontColor = SKColor.brown
        touchToBeginLabel.fontSize = 50
        touchToBeginLabel.position = CGPoint(x: 0, y: 0)
        touchToBeginLabel.text = "Touch To Start"
        touchToBeginLabel.zPosition = 10
    }
    
    func addBestScore() {
        
        bestScoreLabel.fontColor = SKColor.blue
        bestScoreLabel.fontSize = 30
        bestScoreLabel.position = CGPoint(x: 280, y: 640)
        /*if Values().getBestScore() == -1.0 {
         bestScoreLabel.text = "Best:n/a"
         }else{
         bestScoreLabel.text = "Best: \(Values().getBestScore())"
         }
         
         bestScoreLabel.zPosition = 10
         addChild(bestScoreLabel)*/
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if let gravityX = manager?.deviceMotion?.gravity.x, let gravityY = manager?.deviceMotion?.gravity.y, ball != nil {
            var posY:Int
            if ball.position.y > 0 {
                posY = 667 - Int(ball.position.y)
            } else {
                posY = 667 - Int(ball.position.y)
            }
            let frictionFactor = frictionMap[posY-32][Int(ball.position.x) + 375]
            let endGameCheck = obstacleMap[posY-32][Int(ball.position.x) + 375]
            let friction = CGFloat(frictionFactor) * (ball.physicsBody?.mass)! * CGFloat(9.8)
            let impulseX = CGFloat(gravityX) * (ball.physicsBody?.mass)! * CGFloat(9.8)
            let impulseY = CGFloat(gravityY) * (ball.physicsBody?.mass)! * CGFloat(9.8)
            let velocityX = CGFloat(ball.physicsBody!.velocity.dx)
            let velocityY = CGFloat(ball.physicsBody!.velocity.dy)
            let ballVelocity = sqrt((ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx) + (ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy))
            let totalImpulse = sqrt((impulseX * impulseX ) + (impulseY * impulseY))
            let totalCalculatedImpulse = sqrt(((impulseX*10) * (impulseX*10) ) + ((impulseY*10) * (impulseY*10)))
            
            if endGameCheck == -1 {
                endGame()
            }
            
            var frictionX = CGFloat(0.0)
            var frictionY = CGFloat(0.0)
            
            if ballVelocity == CGFloat(0.0) {
                frictionX = CGFloat(abs((impulseX * friction) / totalImpulse))
                frictionY = CGFloat(abs((impulseY * friction) / totalImpulse))
            } else {
                
                if frictionFactor == 0.2 {
                    frictionX = -CGFloat(velocityX/3.0)
                    frictionY = -CGFloat(velocityY/3.0)
                }else if frictionFactor == 0.4{
                    frictionX = -CGFloat(velocityX/8.0)
                    frictionY = -CGFloat(velocityY/8.0)
                }else if frictionFactor == 0.6{
                    frictionX = -CGFloat(velocityX/15.0)
                    frictionY = -CGFloat(velocityY/15.0)
                }else if frictionFactor == 1.3{
                    frictionX = CGFloat(velocityX/30.0)
                    frictionY = CGFloat(velocityY/30.0)
                }else if frictionFactor == 1.6{
                    frictionX = CGFloat(velocityX/25.0)
                    frictionY = CGFloat(velocityY/25.0)
                }
            }
            
            if frictionFactor == 0.0 {
                ball.physicsBody?.applyImpulse(CGVector(dx: impulseX , dy: impulseY ))
            } else {
                if ballVelocity == 0.0 {
                    if totalCalculatedImpulse > CGFloat(frictionFactor*10) {
                        ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
                    }
                } else {
                    let ballTotalX = velocityX + impulseX
                    let ballTotalY = velocityY + impulseY
                    let ballTotal = sqrt((ballTotalX * ballTotalX ) + (ballTotalY * ballTotalY))
                    let frictionTotal = sqrt((frictionX * frictionX ) + (frictionY * frictionY))
                    if ballTotal < frictionTotal {
                        ball.physicsBody?.velocity.dx = 0.0
                        ball.physicsBody?.velocity.dy = 0.0
                    } else {
                        ball.physicsBody?.applyImpulse(CGVector(dx: impulseX + frictionX , dy: impulseY + frictionY))
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
        ball.position = CGPoint(x: frame.midX, y: -600)//-640 tı
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.height / 2.0)
        ball.physicsBody?.mass = 1.0
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.isDynamic = false
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

