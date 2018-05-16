import SpriteKit
import CoreMotion
import GameplayKit
import UIKit

struct Variables {
    static var experimenterID = ""
    static var mapCode = 0
}

class GameScene: SKScene {
    
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    
    var backGroundImage: UIImage?
    
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
    var dataLogTime:Double = 0.0
    
    var ballPosX:Int = 0
    var ballPosY:Int = 0
    
    var timerLabel = SKLabelNode(fontNamed: "ArialMT")
    var bestScoreLabel  = SKLabelNode(fontNamed: "ArialMT")
    var touchToBeginLabel    = SKLabelNode(fontNamed: "ArialMT")
    
    var loggedData = "ID,Time,Map\n"
    var attemptCount = 0
    var dataWriteCheck = 1
    
    var levelTimerValue: Double = 0.0 {
        didSet {
            timerLabel.text = "\(round(10*levelTimerValue)/10)"
        }
    }
    
    let maxVelocity = CGFloat(50.0)
    
    var frictionMap = [[Int]](repeating: [Int](repeating: 0, count: 1334), count: 750)
    var heightMap = [[Int]](repeating: [Int](repeating: 0, count: 1334), count: 750)
    var obstacleMap = [[Int]](repeating: [Int](repeating: 0, count: 1334), count: 750)
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    func setObstacles() {
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
            dataWriteCheck = 1
            touchToBeginLabel.removeFromParent()
            addChild(timerLabel)
            startTimer()
            ball.physicsBody?.isDynamic = true
            touchTime = 1
            attemptCount += 1
            levelTimerValue = 0.0
            self.loggedData += "\(Variables.experimenterID),\(attemptCount),\(Variables.mapCode)\n"
        }
    }
    
    func endGame(){
        touchTime = 0
        dataWriteCheck = 0
        writeToFile(loggedTime: loggedData)
        addChild(touchToBeginLabel)
        timerLabel.removeFromParent()
        ball.position = CGPoint(x: frame.midX, y: -600)
        ball.physicsBody?.isDynamic = false
    }
    
    
    func writeToFile(loggedTime: String){
        let fileName = "subject_\(Variables.experimenterID)_Data.txt"
        var filePath = ""
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let dir = dirs[0]
        filePath = dir.appending("/" + fileName)
        
        
        let fileContentToWrite = loggedTime
        
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
        createMap()
        addChild(touchToBeginLabel)

        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(GameScene.increaseTimer), userInfo: nil, repeats: true)

        physicsWorld.contactDelegate = self as? SKPhysicsContactDelegate

        addBallToScene()

        manager = CMMotionManager()
        if let manager = manager, manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.001
            manager.startDeviceMotionUpdates()
        }
    }
    
    func createMap() {
        
        if Variables.mapCode == 1 {
            frictionMap = SetFriction().createFrictionMap(#imageLiteral(resourceName: "MapOne_Friction"))!
            obstacleMap = SetObstacles().setObstacles(#imageLiteral(resourceName: "MapOne_Obstacle"))!
            backGroundImage = SetBackground().createBackground(#imageLiteral(resourceName: "MapOne_Obstacle"), #imageLiteral(resourceName: "MapOne_Friction"), #imageLiteral(resourceName: "BackGroundImage"))
        }else if Variables.mapCode == 2{
            frictionMap = SetFriction().createFrictionMap(#imageLiteral(resourceName: "MapTwo_Friction"))!
            obstacleMap = SetObstacles().setObstacles(#imageLiteral(resourceName: "MapTwo_Obstacle"))!
            backGroundImage = SetBackground().createBackground(#imageLiteral(resourceName: "MapTwo_Obstacle"), #imageLiteral(resourceName: "MapTwo_Friction"), #imageLiteral(resourceName: "BackGroundImage"))
            
        }else if Variables.mapCode == 3{
            frictionMap = SetFriction().createFrictionMap(#imageLiteral(resourceName: "MapThree_Friction"))!
            obstacleMap = SetObstacles().setObstacles(#imageLiteral(resourceName: "MapThree_Obstacle"))!
            backGroundImage = SetBackground().createBackground(#imageLiteral(resourceName: "MapThree_Obstacle"), #imageLiteral(resourceName: "MapThree_Friction"), #imageLiteral(resourceName: "BackGroundImage"))
        }else if Variables.mapCode == 4{
            frictionMap = SetFriction().createFrictionMap(#imageLiteral(resourceName: "MapFour_Friction"))!
            obstacleMap = SetObstacles().setObstacles(#imageLiteral(resourceName: "MapFour_Obstacle"))!
            backGroundImage = SetBackground().createBackground(#imageLiteral(resourceName: "MapFour_Obstacle"), #imageLiteral(resourceName: "MapFour_Friction"), #imageLiteral(resourceName: "BackGroundImage"))
            
        }
        setBackground()
        setObstacles()
    }
    
    func createTimerLabel() {
        
        timerLabel.fontColor = SKColor.red
        timerLabel.fontSize = 30
        timerLabel.position = CGPoint(x: 0, y: 640)
        levelTimerValue = round(10*levelTimerValue)/10
        timerLabel.text = "\(levelTimerValue)"
        timerLabel.zPosition = 10
        wait = SKAction.wait(forDuration: 0.1)
        block = SKAction.run({
            [unowned self] in
            self.levelTimerValue = self.levelTimerValue + 0.1
            self.dataLogTime = self.dataLogTime + 0.1
            self.dataLogTime = round(10*self.levelTimerValue)/10
            let posX = Int(self.ball.position.x) + 375
            let posY = 1334 - (667 - Int(self.ball.position.y))
            
            if self.dataWriteCheck == 1{
            self.loggedData += "\(posX),\(posY),\(self.dataLogTime)\n"
            }
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
            ballPosY = 667 - Int(ball.position.y)
            ballPosX = Int(ball.position.x) + 375
            let frictionFactor = frictionMap[ballPosY][ballPosX]
            let endGameCheck = obstacleMap[ballPosY][ballPosX]
            let friction = CGFloat(frictionFactor) * (ball.physicsBody?.mass)! * CGFloat(9.8)
            let impulseX = CGFloat(gravityX) * (ball.physicsBody?.mass)! * CGFloat(20.0)
            let impulseY = CGFloat(gravityY) * (ball.physicsBody?.mass)! * CGFloat(20.0)
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
                if frictionFactor == 3 {
                    frictionX = -CGFloat(velocityX/3.0)
                    frictionY = -CGFloat(velocityY/3.0)
                }else if frictionFactor == 2{
                    frictionX = -CGFloat(velocityX/8.0)
                    frictionY = -CGFloat(velocityY/8.0)
                }else if frictionFactor == 1{
                    frictionX = -CGFloat(velocityX/15.0)
                    frictionY = -CGFloat(velocityY/15.0)
                }else if frictionFactor == -1{
                    frictionX = CGFloat(velocityX/30.0)
                    frictionY = CGFloat(velocityY/30.0)
                }else if frictionFactor == -2{
                    frictionX = CGFloat(velocityX/25.0)
                    frictionY = CGFloat(velocityY/25.0)
                }
            }
            
            if frictionFactor == 0 {
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
        let Texture = SKTexture(image: backGroundImage!)
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

