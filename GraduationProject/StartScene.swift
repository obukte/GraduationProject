
import SpriteKit
import CoreMotion
import GameplayKit
import UIKit

class StartScene: SKScene {
    override init(size: CGSize) {
        super.init(size: size)
        
        print("here, you are in gameScene and game is ended!")
        // change the background of the scene to be black
        backgroundColor = SKColor.black
        
        // create a label to see game over on the screen
        let gameOverLabel = SKLabelNode(fontNamed: "Arial")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 90
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(gameOverLabel)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetGame()
    }
    func resetGame() {
        print("game again started!")
       
        run(
            SKAction.sequence([
                SKAction.run() {
                    let transitionDuration = SKTransition.doorsCloseHorizontal(withDuration: 0.2)
            
                    if let scene = GameScene(fileNamed: "GameScene") {
                        scene.scaleMode = .aspectFill
                        self.view?.presentScene(scene, transition:transitionDuration)
                    }
                }
                ])
        )
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


